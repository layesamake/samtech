import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spk_db_001/src/security/secure_key_store.dart';

final class FlutterSecureKeyStore implements SecureKeyStore {
  FlutterSecureKeyStore({
    FlutterSecureStorage? storage,
    this.storageKey = 'database_key_v1',
  }) : _storage =
           storage ??
           const FlutterSecureStorage(
             aOptions: AndroidOptions(
               resetOnError: false,
               storageNamespace: 'samtech_spk_db_001',
             ),
             iOptions: IOSOptions(
               accountName: 'com.samtech.spk_db_001.database',
               accessibility: KeychainAccessibility.first_unlock_this_device,
               synchronizable: false,
             ),
           );

  final FlutterSecureStorage _storage;
  final String storageKey;

  @override
  Future<void> delete() => _guard(() => _storage.delete(key: storageKey));

  @override
  Future<String?> read() => _guard(() => _storage.read(key: storageKey));

  @override
  Future<void> write(String encodedKey) =>
      _guard(() => _storage.write(key: storageKey, value: encodedKey));

  Future<T> _guard<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on Exception catch (error) {
      throw KeyVaultUnavailable(error);
    }
  }
}
