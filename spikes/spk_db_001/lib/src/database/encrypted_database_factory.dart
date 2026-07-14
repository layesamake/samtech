import 'dart:io';

import 'package:drift/native.dart';
import 'package:spk_db_001/src/database/cipher_configuration.dart';
import 'package:spk_db_001/src/database/spike_database.dart';
import 'package:spk_db_001/src/security/database_key.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

final class EncryptedDatabaseFactory {
  const EncryptedDatabaseFactory();

  SpikeDatabase open({required File file, required DatabaseKey key}) {
    final executor = NativeDatabase.createInBackground(
      file,
      setup: (database) => configureEncryptedConnection(database, key),
    );
    return SpikeDatabase(executor);
  }

  Future<void> createVersionOneFixture({
    required File file,
    required DatabaseKey key,
  }) async {
    final database = sqlite.sqlite3.open(file.path);
    try {
      configureEncryptedConnection(database, key);
      database
        ..execute('''
          CREATE TABLE prototype_groups (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            label TEXT NOT NULL CHECK (length(label) BETWEEN 1 AND 80)
          );
        ''')
        ..execute('''
          CREATE TABLE prototype_entries (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            group_id INTEGER NOT NULL REFERENCES prototype_groups(id)
              ON DELETE CASCADE,
            payload TEXT NOT NULL CHECK (length(payload) BETWEEN 1 AND 512),
            created_at INTEGER NOT NULL
          );
        ''')
        ..execute('PRAGMA user_version = 1;');
    } finally {
      database.close();
    }
  }

  Future<void> rotateKey({
    required File file,
    required DatabaseKey currentKey,
    required DatabaseKey replacementKey,
  }) async {
    final database = sqlite.sqlite3.open(file.path);
    try {
      configureEncryptedConnection(database, currentKey);
      database.select('SELECT count(*) FROM sqlite_schema;');
      database
        ..execute('PRAGMA wal_checkpoint(TRUNCATE);')
        ..execute('PRAGMA journal_mode = DELETE;');
      database.execute('PRAGMA rekey = "x\'${replacementKey.toHex()}\'";');
      database
        ..select('SELECT count(*) FROM sqlite_schema;')
        ..execute('PRAGMA journal_mode = WAL;');
    } finally {
      database.close();
    }
  }
}
