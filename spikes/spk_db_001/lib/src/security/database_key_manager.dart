import 'dart:io';

import 'package:spk_db_001/src/security/database_key.dart';
import 'package:spk_db_001/src/security/secure_key_store.dart';

final class DatabaseKeyManager {
  DatabaseKeyManager({required this.keyStore, DatabaseKeyGenerator? generator})
    : _generator = generator ?? DatabaseKeyGenerator();

  final SecureKeyStore keyStore;
  final DatabaseKeyGenerator _generator;

  Future<DatabaseKey> loadOrCreate({required File databaseFile}) async {
    final encodedKey = await keyStore.read();
    if (encodedKey != null) {
      try {
        return DatabaseKey.fromHex(encodedKey);
      } on FormatException catch (error) {
        throw InvalidStoredKey(error);
      }
    }

    if (await _databaseArtifactsExist(databaseFile)) {
      throw const KeyMissingForExistingDatabase();
    }

    final key = _generator.generate();
    await keyStore.write(key.toHex());
    final persisted = await keyStore.read();
    if (persisted != key.toHex()) {
      throw const KeyPersistenceFailure();
    }
    return key;
  }

  Future<bool> _databaseArtifactsExist(File databaseFile) async {
    for (final suffix in const ['', '-wal', '-shm', '-journal']) {
      if (await File('${databaseFile.path}$suffix').exists()) {
        return true;
      }
    }
    return false;
  }
}
