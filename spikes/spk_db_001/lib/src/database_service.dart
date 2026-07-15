import 'dart:io';

import 'database.dart';
import 'key_manager.dart';

class DatabaseService {
  final KeyManager _keyManager;
  final File _dbFile;
  AppDatabase? _db;
  String? _currentKey;

  AppDatabase get db => _db!;

  DatabaseService(this._keyManager, this._dbFile);

  Future<void> initialize() async {
    await _recoverFromInterruptionIfNeeded();

    var mainKey = await _keyManager.getMainKey();
    if (_dbFile.existsSync() && mainKey == null) {
      throw Exception(
        'DatabaseKeyLostException: Database exists but main key is missing from vault. Cannot open or safely recover.',
      );
    }

    _currentKey = await _keyManager.getOrCreateKey();
    _db = AppDatabase(openEncryptedConnection(_dbFile, _currentKey!));

    // Force une requête pour s'assurer que la base s'ouvre bien (décryptage OK)
    await _db!.customSelect('SELECT 1').get();
  }

  Future<void> _recoverFromInterruptionIfNeeded() async {
    final state = await _keyManager.getRotationState();
    if (state == KeyRotationState.idle) return;

    final tempKey = await _keyManager.getTempKey();
    final mainKey = await _keyManager.getMainKey();

    switch (state) {
      case KeyRotationState.preparing:
        // Interrompu avant rekey. On efface l'état.
        await _keyManager.clearRotationState();
        break;
      case KeyRotationState.rekeying:
        // Interrompu pendant rekey. L'opération a-t-elle réussi sur le disque ?
        // On teste avec mainKey. Si ça échoue, on essaie tempKey.
        bool mainKeyWorks = mainKey != null ? await _testKey(mainKey) : false;
        if (mainKeyWorks) {
          // Rekey a échoué ou n'a pas commencé. On annule.
          await _keyManager.clearRotationState();
        } else {
          // Rekey a réussi mais on n'a pas mis à jour le vault. On continue avec tempKey.
          if (tempKey != null && await _testKey(tempKey)) {
            await _keyManager.commitTempKeyToMain();
          }
          await _keyManager.clearRotationState();
        }
        break;
      case KeyRotationState.updatingVault:
        // Interrompu pendant la mise à jour du vault. Le rekey est fait.
        // La nouvelle clé (tempKey) est déjà la bonne pour la db, et a peut-être été committée.
        if (tempKey != null && await _testKey(tempKey)) {
          await _keyManager.commitTempKeyToMain();
        }
        await _keyManager.clearRotationState();
        break;
      case KeyRotationState.cleanup:
        await _keyManager.clearRotationState();
        break;
      case KeyRotationState.idle:
        break;
    }
  }

  Future<bool> _testKey(String key) async {
    final testDb = AppDatabase(openEncryptedConnection(_dbFile, key));
    try {
      await testDb.customSelect('SELECT 1').get();
      return true;
    } catch (_) {
      return false;
    } finally {
      await testDb.close();
    }
  }

  Future<void> rotateKey() async {
    final newKey = _keyManager.generateNewKey();

    // 1. Preparing
    await _keyManager.setRotationState(KeyRotationState.preparing);
    await _keyManager.saveTempKey(newKey);

    // 2. Rekeying
    await _keyManager.setRotationState(KeyRotationState.rekeying);
    await _db!.customStatement("PRAGMA rekey = '$newKey';");

    // Fermer et rouvrir avec la nouvelle clé pour s'assurer que c'est appliqué en mémoire
    await close();
    _currentKey = newKey;
    _db = AppDatabase(openEncryptedConnection(_dbFile, _currentKey!));
    await _db!.customSelect('SELECT 1').get(); // vérifie la nouvelle clé

    // 3. Updating Vault
    await _keyManager.setRotationState(KeyRotationState.updatingVault);
    await _keyManager.commitTempKeyToMain();

    // 4. Cleanup
    await _keyManager.setRotationState(KeyRotationState.cleanup);
    await _keyManager.clearRotationState();
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
