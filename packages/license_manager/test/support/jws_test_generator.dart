import 'dart:convert';

import 'package:cryptography/cryptography.dart';

/// WARNING: TEST ONLY. DO NOT USE IN PRODUCTION.
/// Generates deterministic JWS tokens for tests.
class JwsTestGenerator {
  final SimpleKeyPair keyPair;
  final String kid;

  JwsTestGenerator._(this.keyPair, this.kid);

  static Future<JwsTestGenerator> create({
    required String kid,
    List<int>? seed,
  }) async {
    final ed25519 = Ed25519();
    final actualSeed = seed ?? List<int>.generate(32, (i) => i);
    final keyPair = await ed25519.newKeyPairFromSeed(actualSeed);
    return JwsTestGenerator._(keyPair, kid);
  }

  Future<SimplePublicKey> get publicKey => keyPair.extractPublicKey();

  String _base64UrlEncode(List<int> bytes) {
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  Future<String> generate({
    Map<String, dynamic>? customHeader,
    required Map<String, dynamic> payload,
    bool corruptSignature = false,
  }) async {
    final header =
        customHeader ?? {'alg': 'EdDSA', 'typ': 'SAMTECH-LICENSE', 'kid': kid};

    return generateRaw(
      headerBytes: utf8.encode(jsonEncode(header)),
      payloadBytes: utf8.encode(jsonEncode(payload)),
      corruptSignature: corruptSignature,
    );
  }

  Future<String> generateRaw({
    required List<int> headerBytes,
    required List<int> payloadBytes,
    bool corruptSignature = false,
  }) async {
    final headerB64 = _base64UrlEncode(headerBytes);
    final payloadB64 = _base64UrlEncode(payloadBytes);

    final signingInput = '$headerB64.$payloadB64';
    final signingInputBytes = utf8.encode(signingInput);

    final signature = await Ed25519().sign(signingInputBytes, keyPair: keyPair);

    var sigBytes = signature.bytes;
    if (corruptSignature) {
      sigBytes = List<int>.from(sigBytes);
      sigBytes[0] ^= 0xFF; // flip bits
    }

    final signatureB64 = _base64UrlEncode(sigBytes);
    return '$signingInput.$signatureB64';
  }
}
