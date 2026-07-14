import 'dart:io';

import 'package:spk_db_001/src/database/encrypted_database_factory.dart';
import 'package:spk_db_001/src/security/database_key.dart';
import 'package:spk_db_001/src/security/secure_key_store.dart';

final class DatabaseKeyRotationService {
  DatabaseKeyRotationService({
    required this.keyStore,
    this.factory = const EncryptedDatabaseFactory(),
    DatabaseKeyGenerator? generator,
  }) : _generator = generator ?? DatabaseKeyGenerator();

  final SecureKeyStore keyStore;
  final EncryptedDatabaseFactory factory;
  final DatabaseKeyGenerator _generator;

  Future<DatabaseKey> rotate({
    required File databaseFile,
    required DatabaseKey currentKey,
  }) async {
    final replacementKey = _generator.generate();
    await factory.rotateKey(
      file: databaseFile,
      currentKey: currentKey,
      replacementKey: replacementKey,
    );

    try {
      await keyStore.write(replacementKey.toHex());
      if (await keyStore.read() != replacementKey.toHex()) {
        throw const KeyPersistenceFailure();
      }
      return replacementKey;
    } catch (error) {
      try {
        await factory.rotateKey(
          file: databaseFile,
          currentKey: replacementKey,
          replacementKey: currentKey,
        );
      } catch (rollbackError) {
        throw KeyRotationFailure(error, rollbackError);
      }
      throw KeyRotationFailure(error);
    }
  }
}

final class KeyRotationFailure implements Exception {
  const KeyRotationFailure(this.cause, [this.rollbackCause]);

  final Object cause;
  final Object? rollbackCause;

  @override
  String toString() => rollbackCause == null
      ? 'KeyRotationFailure: secure-vault update failed; database rekey was '
            'rolled back.'
      : 'KeyRotationFailure: secure-vault update and database rollback failed.';
}
