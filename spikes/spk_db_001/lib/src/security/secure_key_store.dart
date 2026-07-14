abstract interface class SecureKeyStore {
  Future<String?> read();

  Future<void> write(String encodedKey);

  Future<void> delete();
}

sealed class KeyAccessException implements Exception {
  const KeyAccessException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

final class KeyMissingForExistingDatabase extends KeyAccessException {
  const KeyMissingForExistingDatabase()
    : super('The encrypted database exists but its key is absent.');
}

final class KeyVaultUnavailable extends KeyAccessException {
  const KeyVaultUnavailable([Object? cause])
    : super('The platform secure vault is unavailable.', cause);
}

final class KeyPersistenceFailure extends KeyAccessException {
  const KeyPersistenceFailure()
    : super('The generated key could not be verified in secure storage.');
}

final class InvalidStoredKey extends KeyAccessException {
  const InvalidStoredKey([Object? cause])
    : super('The value stored in the secure vault is not a valid key.', cause);
}
