import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spk_db_001/spk_db_001.dart';
import 'package:path/path.dart' as p;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  late Directory tempDir;
  late File dbFile;
  late KeyManager keyManager;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('spk_db_001_test_enc');
    dbFile = File(p.join(tempDir.path, 'app.db'));
    keyManager = KeyManager();
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('Database is created, encrypted, and can be reopened', () async {
    // 1. Initialisation : création et chiffrement
    var dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();

    // Insertion d'une donnée
    await dbService.db
        .into(dbService.db.contacts)
        .insert(
          ContactsCompanion.insert(
            id: 'c1',
            organizationId: 'org1',
            phoneNormalized: '123456789',
            createdAt: 1000,
            updatedAt: 1000,
          ),
        );

    await dbService.close();

    // 2. Réouverture : déchiffrement avec la même clé
    dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();

    final contacts = await dbService.db.select(dbService.db.contacts).get();
    expect(contacts.length, 1);
    expect(contacts.first.id, 'c1');

    await dbService.close();
  });

  test('Database rejects incorrect key', () async {
    if (Platform.isWindows) {
      return;
    }

    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    await dbService.close();

    // Try opening with wrong key
    final wrongKey = 'wrong_key_123';
    final badDb = AppDatabase(openEncryptedConnection(dbFile, wrongKey));

    expect(
      () async => await badDb.customStatement('PRAGMA user_version;'),
      throwsA(anything),
    );

    await badDb.close();
  });

  test('Database file does not contain plain SQLite header', () async {
    if (Platform.isWindows) {
      return;
    }

    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    await dbService.close();

    final bytes = await dbFile.readAsBytes();
    final headerStr = String.fromCharCodes(bytes.take(16));
    expect(headerStr, isNot(equals('SQLite format 3\x00')));
  });

  test('Fails safely if database exists but key is lost from vault', () async {
    // 1. Create DB
    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    await dbService.close();

    // 2. Simulate vault wipe (e.g. app reinstalled, but DB remained in Auto Backup)
    FlutterSecureStorage.setMockInitialValues({}); // wipes mock secure storage

    // 3. Try to reopen
    final newDbService = DatabaseService(keyManager, dbFile);
    expect(
      () async => await newDbService.initialize(),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('DatabaseKeyLostException'),
        ),
      ),
    );
  });
}
