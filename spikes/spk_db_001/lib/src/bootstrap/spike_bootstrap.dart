import 'dart:io';

import 'package:drift/drift.dart';
import 'package:spk_db_001/src/bootstrap/spike_report.dart';
import 'package:spk_db_001/src/database/encrypted_database_factory.dart';
import 'package:spk_db_001/src/database/spike_database.dart';
import 'package:spk_db_001/src/security/database_key_manager.dart';
import 'package:spk_db_001/src/security/secure_key_store.dart';

final class SpikeBootstrap {
  SpikeBootstrap({
    required Directory supportDirectory,
    required SecureKeyStore keyStore,
    this.factory = const EncryptedDatabaseFactory(),
  }) : _databaseFile = File('${supportDirectory.path}/spk_db_001.sqlite3'),
       _keyManager = DatabaseKeyManager(keyStore: keyStore);

  final File _databaseFile;
  final DatabaseKeyManager _keyManager;
  final EncryptedDatabaseFactory factory;

  Future<SpikeReport> run({int sampleSize = 5000}) async {
    final openWatch = Stopwatch()..start();
    final key = await _keyManager.loadOrCreate(databaseFile: _databaseFile);
    final database = factory.open(file: _databaseFile, key: key);

    try {
      await database.customSelect('SELECT count(*) FROM sqlite_schema;').get();
      openWatch.stop();

      await database.delete(database.prototypeEntries).go();
      await database.delete(database.prototypeGroups).go();
      final groupId = await database.createGroup('Groupe fictif de benchmark');

      final writeWatch = Stopwatch()..start();
      await database.batch((batch) {
        batch.insertAll(
          database.prototypeEntries,
          List.generate(
            sampleSize,
            (index) => PrototypeEntriesCompanion.insert(
              groupId: groupId,
              payload: 'donnée-fictive-$index-${index * 7919}',
              createdAt: DateTime.utc(2026, 1, 1).add(Duration(seconds: index)),
              note: const Value('prototype'),
            ),
            growable: false,
          ),
        );
      });
      writeWatch.stop();

      final readWatch = Stopwatch()..start();
      final insertedRows = await database.entryCount();
      await (database.select(database.prototypeEntries)..limit(250)).get();
      readWatch.stop();

      final foreignKeys = await database
          .customSelect('PRAGMA foreign_keys;')
          .getSingle();
      final journal = await database
          .customSelect('PRAGMA journal_mode;')
          .getSingle();
      final cipher = await database.customSelect('PRAGMA cipher;').getSingle();

      return SpikeReport(
        openDuration: openWatch.elapsed,
        writeDuration: writeWatch.elapsed,
        readDuration: readWatch.elapsed,
        insertedRows: insertedRows,
        foreignKeysEnabled: foreignKeys.data.values.single == 1,
        journalMode: journal.data.values.single.toString(),
        cipher: cipher.data.values.single.toString(),
      );
    } finally {
      await database.close();
    }
  }
}
