import 'package:cryptography/cryptography.dart';

/// Represents a trusted public key used to verify license tokens.
class TrustedLicenseKey {
  static final RegExp _validKeyId = RegExp(r'^[A-Za-z0-9_-]{1,64}$');

  final String kid;
  final SimplePublicKey publicKey;
  final bool isEnabled;

  factory TrustedLicenseKey({
    required String kid,
    required SimplePublicKey publicKey,
    bool isEnabled = true,
  }) {
    final keyIdMatch = _validKeyId.matchAsPrefix(kid);
    if (keyIdMatch == null || keyIdMatch.end != kid.length) {
      throw ArgumentError.value(
        null,
        'kid',
        'Must be a safe 1-64 character key identifier',
      );
    }
    if (publicKey.type != KeyPairType.ed25519 || publicKey.bytes.length != 32) {
      throw ArgumentError.value(
        null,
        'publicKey',
        'Must be a 32-byte Ed25519 public key',
      );
    }
    return TrustedLicenseKey._(
      kid: kid,
      publicKey: SimplePublicKey(
        List<int>.unmodifiable(publicKey.bytes),
        type: KeyPairType.ed25519,
      ),
      isEnabled: isEnabled,
    );
  }

  TrustedLicenseKey._({
    required this.kid,
    required this.publicKey,
    required this.isEnabled,
  });
}

/// A set of trusted public keys (e.g. current and previous keys).
class TrustedLicenseKeySet {
  final Map<String, TrustedLicenseKey> _keys;

  TrustedLicenseKeySet(Iterable<TrustedLicenseKey> keys) : _keys = _build(keys);

  static Map<String, TrustedLicenseKey> _build(
    Iterable<TrustedLicenseKey> keys,
  ) {
    final result = <String, TrustedLicenseKey>{};
    for (final key in keys) {
      if (result.containsKey(key.kid)) {
        throw ArgumentError('Duplicate trusted key identifier');
      }
      result[key.kid] = key;
    }
    return Map.unmodifiable(result);
  }

  TrustedLicenseKey? findByKeyId(String kid) {
    final key = _keys[kid];
    return key != null && key.isEnabled ? key : null;
  }
}
