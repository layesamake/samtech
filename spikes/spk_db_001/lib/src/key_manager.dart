import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum KeyRotationState { idle, preparing, rekeying, updatingVault, cleanup }

class KeyManager {
  static const _keyAlias = 'samtech_db_key_v1';
  static const _keyStateAlias = 'samtech_db_key_state_v1';
  static const _keyTempAlias = 'samtech_db_key_temp_v1';

  final FlutterSecureStorage _storage;

  KeyManager({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  Future<String?> getMainKey() async {
    return await _storage.read(key: _keyAlias);
  }

  Future<String> getOrCreateKey() async {
    final existing = await getMainKey();
    if (existing != null) {
      return existing;
    }

    final newKey = _generateCryptoKey();
    await _storage.write(key: _keyAlias, value: newKey);
    return newKey;
  }

  Future<void> saveTempKey(String key) async {
    await _storage.write(key: _keyTempAlias, value: key);
  }

  Future<String?> getTempKey() async {
    return await _storage.read(key: _keyTempAlias);
  }

  Future<void> commitTempKeyToMain() async {
    final temp = await getTempKey();
    if (temp != null) {
      await _storage.write(key: _keyAlias, value: temp);
    }
  }

  Future<void> setRotationState(KeyRotationState state) async {
    await _storage.write(key: _keyStateAlias, value: state.name);
  }

  Future<KeyRotationState> getRotationState() async {
    final stateStr = await _storage.read(key: _keyStateAlias);
    if (stateStr == null) return KeyRotationState.idle;
    return KeyRotationState.values.firstWhere(
      (e) => e.name == stateStr,
      orElse: () => KeyRotationState.idle,
    );
  }

  Future<void> clearRotationState() async {
    await _storage.delete(key: _keyStateAlias);
    await _storage.delete(key: _keyTempAlias);
  }

  String generateNewKey() {
    return _generateCryptoKey();
  }

  String _generateCryptoKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
