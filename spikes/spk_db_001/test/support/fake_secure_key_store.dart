import 'package:spk_db_001/src/security/secure_key_store.dart';

final class FakeSecureKeyStore implements SecureKeyStore {
  String? value;
  Object? readError;
  Object? writeError;
  bool ignoreWrites = false;

  @override
  Future<void> delete() async {
    value = null;
  }

  @override
  Future<String?> read() async {
    if (readError case final error?) {
      throw error;
    }
    return value;
  }

  @override
  Future<void> write(String encodedKey) async {
    if (writeError case final error?) {
      throw error;
    }
    if (!ignoreWrites) {
      value = encodedKey;
    }
  }
}
