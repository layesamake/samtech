import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spk_db_001/src/security/database_key_manager.dart';
import 'package:spk_db_001/src/security/secure_key_store.dart';

import 'support/fake_secure_key_store.dart';

void main() {
  late Directory directory;
  late File databaseFile;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('spk-key-manager-');
    databaseFile = File('${directory.path}/prototype.sqlite3');
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('persists a generated key and reuses it', () async {
    final store = FakeSecureKeyStore();
    final manager = DatabaseKeyManager(keyStore: store);

    final first = await manager.loadOrCreate(databaseFile: databaseFile);
    final second = await manager.loadOrCreate(databaseFile: databaseFile);

    expect(second.copyBytes(), first.copyBytes());
    expect(store.value, isNotNull);
  });

  test('fails closed when the database exists without a key', () async {
    await databaseFile.writeAsBytes([1, 2, 3]);
    final manager = DatabaseKeyManager(keyStore: FakeSecureKeyStore());

    expect(
      () => manager.loadOrCreate(databaseFile: databaseFile),
      throwsA(isA<KeyMissingForExistingDatabase>()),
    );
  });

  test('fails when secure storage does not retain the generated key', () async {
    final store = FakeSecureKeyStore()..ignoreWrites = true;
    final manager = DatabaseKeyManager(keyStore: store);

    expect(
      () => manager.loadOrCreate(databaseFile: databaseFile),
      throwsA(isA<KeyPersistenceFailure>()),
    );
  });

  test(
    'propagates an inaccessible vault without generating a fallback',
    () async {
      final store = FakeSecureKeyStore()
        ..readError = const KeyVaultUnavailable();
      final manager = DatabaseKeyManager(keyStore: store);

      expect(
        () => manager.loadOrCreate(databaseFile: databaseFile),
        throwsA(isA<KeyVaultUnavailable>()),
      );
    },
  );
}
