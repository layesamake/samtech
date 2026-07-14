import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spk_db_001/src/bootstrap/spike_bootstrap.dart';
import 'package:spk_db_001/src/database/database_artifact_inspector.dart';
import 'package:spk_db_001/src/database/database_key_rotation_service.dart';
import 'package:spk_db_001/src/database/encrypted_database_factory.dart';
import 'package:spk_db_001/src/security/database_key.dart';

import 'support/fake_secure_key_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const factory = EncryptedDatabaseFactory();
  const inspector = DatabaseArtifactInspector();
  final generator = DatabaseKeyGenerator();
  late Directory directory;
  late File databaseFile;
  late DatabaseKey key;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('spk-encrypted-db-');
    databaseFile = File('${directory.path}/prototype.sqlite3');
    key = generator.generate();
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('creates, closes and reopens an encrypted database', () async {
    var database = factory.open(file: databaseFile, key: key);
    final groupId = await database.createGroup('Groupe fictif');
    await database.createEntry(groupId: groupId, payload: 'contenu fictif');
    await database.close();

    database = factory.open(file: databaseFile, key: key);
    expect(await database.entryCount(), 1);
    await database.close();
  });

  test('rejects a wrong key', () async {
    var database = factory.open(file: databaseFile, key: key);
    await database.createGroup('Initialisation fictive');
    await database.close();

    database = factory.open(file: databaseFile, key: generator.generate());
    await expectLater(
      database.customSelect('SELECT count(*) FROM sqlite_schema;').get(),
      throwsA(anything),
    );
    await database.close();
  });

  test(
    'does not expose row plaintext in database or journal artifacts',
    () async {
      final marker = 'marqueur-fictif-${DateTime.now().microsecondsSinceEpoch}';
      final database = factory.open(file: databaseFile, key: key);
      final groupId = await database.createGroup('Groupe du marqueur');
      await database.createEntry(groupId: groupId, payload: marker);

      expect(
        await inspector.containsPlaintext(
          databaseFile: databaseFile,
          marker: marker,
        ),
        isFalse,
      );
      await database.close();

      expect(
        await inspector.containsPlaintext(
          databaseFile: databaseFile,
          marker: marker,
        ),
        isFalse,
      );
      expect(
        utf8.decode(
          await databaseFile.openRead(0, 16).expand((chunk) => chunk).toList(),
          allowMalformed: true,
        ),
        isNot(startsWith('SQLite format 3')),
      );
    },
  );

  test('commits and rolls back transactions', () async {
    final database = factory.open(file: databaseFile, key: key);
    final groupId = await database.createGroup('Transactions fictives');

    await database.transaction(() async {
      await database.createEntry(groupId: groupId, payload: 'validée');
    });
    expect(await database.entryCount(), 1);

    await expectLater(
      database.transaction(() async {
        await database.createEntry(groupId: groupId, payload: 'annulée');
        throw StateError('rollback requested by test');
      }),
      throwsStateError,
    );
    expect(await database.entryCount(), 1);
    await database.close();
  });

  test('migrates schema version 1 to version 2', () async {
    await factory.createVersionOneFixture(file: databaseFile, key: key);

    final database = factory.open(file: databaseFile, key: key);
    final columns = await database
        .customSelect('PRAGMA table_info(prototype_entries);')
        .get();
    final version = await database
        .customSelect('PRAGMA user_version;')
        .getSingle();

    expect(columns.map((row) => row.data['name']), contains('note'));
    expect(version.data.values.single, 2);
    await database.close();
  });

  test('enables and enforces foreign keys', () async {
    final database = factory.open(file: databaseFile, key: key);
    final pragma = await database
        .customSelect('PRAGMA foreign_keys;')
        .getSingle();
    expect(pragma.data.values.single, 1);

    await expectLater(
      database.createEntry(groupId: 999999, payload: 'référence invalide'),
      throwsA(anything),
    );
    expect(
      await database.customSelect('PRAGMA foreign_key_check;').get(),
      isEmpty,
    );
    await database.close();
  });

  test('uses WAL with in-memory temporary storage', () async {
    final database = factory.open(file: databaseFile, key: key);
    await database.createGroup('Journal fictif');
    final journal = await database
        .customSelect('PRAGMA journal_mode;')
        .getSingle();
    final tempStore = await database
        .customSelect('PRAGMA temp_store;')
        .getSingle();

    expect(journal.data.values.single.toString().toLowerCase(), 'wal');
    expect(tempStore.data.values.single, 2);
    expect(
      (await inspector.existingArtifacts(
        databaseFile,
      )).map((file) => file.path),
      contains('${databaseFile.path}-wal'),
    );
    await database.close();
  });

  test('rotates the raw key and invalidates the previous key', () async {
    var database = factory.open(file: databaseFile, key: key);
    await database.createGroup('Rotation fictive');
    await database.close();

    final replacement = generator.generate();
    await factory.rotateKey(
      file: databaseFile,
      currentKey: key,
      replacementKey: replacement,
    );

    database = factory.open(file: databaseFile, key: key);
    await expectLater(database.entryCount(), throwsA(anything));
    await database.close();

    database = factory.open(file: databaseFile, key: replacement);
    expect(await database.select(database.prototypeGroups).get(), hasLength(1));
    await database.close();
  });

  test('updates the secure vault when rotating the database key', () async {
    final store = FakeSecureKeyStore()..value = key.toHex();
    var database = factory.open(file: databaseFile, key: key);
    await database.createGroup('Rotation coordonnée fictive');
    await database.close();

    final replacement = await DatabaseKeyRotationService(
      keyStore: store,
    ).rotate(databaseFile: databaseFile, currentKey: key);

    expect(store.value, replacement.toHex());
    database = factory.open(file: databaseFile, key: replacement);
    expect(await database.select(database.prototypeGroups).get(), hasLength(1));
    await database.close();
  });

  test('restores the database key when vault rotation fails', () async {
    final store = FakeSecureKeyStore()..value = key.toHex();
    var database = factory.open(file: databaseFile, key: key);
    await database.createGroup('Rollback de rotation fictif');
    await database.close();
    store.writeError = StateError('simulated vault failure');

    await expectLater(
      DatabaseKeyRotationService(
        keyStore: store,
      ).rotate(databaseFile: databaseFile, currentKey: key),
      throwsA(isA<KeyRotationFailure>()),
    );

    database = factory.open(file: databaseFile, key: key);
    expect(await database.select(database.prototypeGroups).get(), hasLength(1));
    await database.close();
  });

  test('measures opening, batch writing and reading fictional rows', () async {
    final store = FakeSecureKeyStore();
    final bootstrap = SpikeBootstrap(
      supportDirectory: directory,
      keyStore: store,
    );

    final report = await bootstrap.run(sampleSize: 1500);

    expect(report.insertedRows, 1500);
    expect(report.foreignKeysEnabled, isTrue);
    expect(report.journalMode.toLowerCase(), 'wal');
    expect(report.cipher.toLowerCase(), 'chacha20');
    expect(report.openDuration, isNot(Duration.zero));
    expect(report.writeDuration, isNot(Duration.zero));
    expect(report.readDuration, isNot(Duration.zero));
  });
}
