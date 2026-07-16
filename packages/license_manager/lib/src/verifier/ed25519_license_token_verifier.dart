import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../errors/license_verification_error.dart';
import '../models/license_claims.dart';
import '../models/license_evaluation.dart';
import '../models/license_state.dart';
import '../models/license_verification_context.dart';
import '../models/trusted_license_key.dart';
import 'license_token_verifier.dart';

/// Strict verifier for the version 1 SAMTECH license profile.
///
/// JWS protects authenticity and integrity. It does not encrypt the payload.
class Ed25519LicenseTokenVerifier implements LicenseTokenVerifier {
  static const int _maxTokenLength = 12 * 1024;
  static const int _maxHeaderSegmentLength = 1024;
  static const int _maxPayloadSegmentLength = 8 * 1024;
  static const int _maxUnixTimeSeconds = 253402300799;
  static final RegExp _base64UrlAlphabet = RegExp(r'^[A-Za-z0-9_-]+$');
  static final RegExp _safeKeyId = RegExp(r'^[A-Za-z0-9_-]{1,64}$');
  static const Set<String> _headerNames = {'alg', 'typ', 'kid'};
  static const Set<String> _claimNames = {
    'token_version',
    'issuer',
    'audience',
    'license_id',
    'activation_id',
    'edition',
    'app_id',
    'installation_thumbprint',
    'issued_at',
    'not_before',
    'recheck_after',
    'grace_ends_at',
    'max_devices',
    'key_id',
  };

  const Ed25519LicenseTokenVerifier();

  @override
  Future<LicenseEvaluation> verify({
    required String token,
    required TrustedLicenseKeySet trustedKeys,
    required LicenseVerificationContext context,
  }) async {
    if (token.isEmpty || token.length > _maxTokenLength) {
      throw const InvalidFormatException('Token size is invalid.');
    }

    final segments = token.split('.');
    if (segments.length != 3 || segments.any((segment) => segment.isEmpty)) {
      throw const InvalidFormatException(
        'A compact JWS must contain three non-empty segments.',
      );
    }

    final headerB64 = segments[0];
    final payloadB64 = segments[1];
    final signatureB64 = segments[2];
    if (headerB64.length > _maxHeaderSegmentLength ||
        payloadB64.length > _maxPayloadSegmentLength) {
      throw const InvalidFormatException(
        'A JWS segment exceeds the accepted size.',
      );
    }

    final headerBytes = _decodeCanonicalBase64Url(headerB64);
    // Decode only the envelope representation here. Payload JSON and UTF-8 are
    // deliberately not interpreted until the signature has been verified.
    final payloadBytes = _decodeCanonicalBase64Url(payloadB64);
    final signatureBytes = _decodeCanonicalBase64Url(signatureB64);

    final header = _decodeJsonObject(
      headerBytes,
      error: const InvalidHeaderException(
        'Protected header is not strict JSON UTF-8.',
      ),
    );
    if (header.keys.toSet().difference(_headerNames).isNotEmpty ||
        _headerNames.difference(header.keys.toSet()).isNotEmpty) {
      throw const InvalidHeaderException(
        'Protected header members are not allowed.',
      );
    }
    if (header['alg'] != 'EdDSA') {
      throw const InvalidHeaderException(
        'The only accepted algorithm is EdDSA.',
      );
    }
    if (header['typ'] != 'SAMTECH-LICENSE') {
      throw const InvalidHeaderException('Protected header type is invalid.');
    }
    final kid = header['kid'];
    if (kid is! String || !_matchesEntirely(_safeKeyId, kid)) {
      throw const InvalidHeaderException(
        'Protected header key identifier is invalid.',
      );
    }

    final trustedKey = trustedKeys.findByKeyId(kid);
    if (trustedKey == null) {
      throw const KeyNotFoundException();
    }
    if (signatureBytes.length != 64) {
      throw const InvalidSignatureException();
    }

    final signingInput = utf8.encode('$headerB64.$payloadB64');
    final signature = Signature(
      signatureBytes,
      publicKey: trustedKey.publicKey,
    );
    final isValid = await Ed25519().verify(signingInput, signature: signature);
    if (!isValid) {
      throw const InvalidSignatureException();
    }

    final payload = _decodeJsonObject(
      payloadBytes,
      error: const InvalidClaimsException('Payload is not strict JSON UTF-8.'),
    );
    if (payload.keys.toSet().difference(_claimNames).isNotEmpty ||
        _claimNames.difference(payload.keys.toSet()).isNotEmpty) {
      throw const InvalidClaimsException('Payload claim members are invalid.');
    }
    final claims = _parseClaims(payload);
    _validateContext(context);

    if (claims.keyId != kid) {
      throw const InvalidBindingException('Key binding mismatch.');
    }
    if (claims.issuer != context.expectedIssuer) {
      throw const InvalidBindingException('Issuer binding mismatch.');
    }
    if (claims.audience != context.expectedAudience) {
      throw const InvalidBindingException('Audience binding mismatch.');
    }
    if (claims.appId != context.expectedAppId) {
      throw const InvalidBindingException('Application binding mismatch.');
    }
    if (claims.edition != context.expectedEdition) {
      throw const InvalidBindingException('Edition binding mismatch.');
    }
    if (claims.installationThumbprint !=
        context.expectedInstallationThumbprint) {
      throw const InvalidBindingException('Installation binding mismatch.');
    }

    if (claims.issuedAt > claims.notBefore ||
        claims.notBefore > claims.recheckAfter ||
        claims.recheckAfter > claims.graceEndsAt) {
      throw const InvalidClaimsException('License dates are inconsistent.');
    }

    final effectiveTime = context.effectiveTimeSeconds;
    if (effectiveTime < claims.notBefore) {
      throw const InvalidClaimsException('License is not yet valid.');
    }

    final rollbackDetected =
        context.lastServerTimeSeconds != null &&
        context.currentTimeSeconds < context.lastServerTimeSeconds!;
    if (effectiveTime <= claims.recheckAfter) {
      return LicenseEvaluation(
        state: LicenseState.valid,
        requiresOnlineCheck: rollbackDetected,
        claims: claims,
      );
    }
    if (effectiveTime <= claims.graceEndsAt) {
      return LicenseEvaluation(
        state: LicenseState.grace,
        requiresOnlineCheck: true,
        claims: claims,
      );
    }
    return LicenseEvaluation(
      state: LicenseState.expired,
      requiresOnlineCheck: true,
      claims: claims,
    );
  }

  List<int> _decodeCanonicalBase64Url(String segment) {
    if (!_matchesEntirely(_base64UrlAlphabet, segment) ||
        segment.length % 4 == 1) {
      throw const InvalidFormatException(
        'A JWS segment is not canonical base64url.',
      );
    }
    try {
      final decoded = base64Url.decode(base64Url.normalize(segment));
      if (base64Url.encode(decoded).replaceAll('=', '') != segment) {
        throw const InvalidFormatException(
          'A JWS segment is not canonical base64url.',
        );
      }
      return decoded;
    } on FormatException {
      throw const InvalidFormatException(
        'A JWS segment is not canonical base64url.',
      );
    }
  }

  Map<String, dynamic> _decodeJsonObject(
    List<int> bytes, {
    required LicenseVerificationException error,
  }) {
    try {
      final source = utf8.decode(bytes, allowMalformed: false);
      final decoded = jsonDecode(source);
      if (decoded is! Map<String, dynamic>) {
        throw error;
      }
      final keys = _TopLevelJsonKeys(source).read();
      if (keys.length != keys.toSet().length) {
        throw error;
      }
      return decoded;
    } on LicenseVerificationException {
      rethrow;
    } on Object {
      throw error;
    }
  }

  LicenseClaims _parseClaims(Map<String, dynamic> payload) {
    int integer(String name) {
      final value = payload[name];
      if (value is! int) {
        throw InvalidClaimsException('Claim $name must be an integer.');
      }
      return value;
    }

    String string(String name, int maxLength) {
      final value = payload[name];
      if (value is! String ||
          value.isEmpty ||
          value.length > maxLength ||
          value.trim().isEmpty ||
          value.runes.any((rune) => rune < 0x20 || rune == 0x7f)) {
        throw InvalidClaimsException('Claim $name has an invalid value.');
      }
      return value;
    }

    final tokenVersion = integer('token_version');
    if (tokenVersion != 1) {
      throw const InvalidClaimsException('Token version is unsupported.');
    }
    final maxDevices = integer('max_devices');
    if (maxDevices <= 0 || maxDevices > 1000000) {
      throw const InvalidClaimsException('Device allowance is invalid.');
    }
    final issuedAt = _date(integer('issued_at'));
    final notBefore = _date(integer('not_before'));
    final recheckAfter = _date(integer('recheck_after'));
    final graceEndsAt = _date(integer('grace_ends_at'));
    final keyId = string('key_id', 64);
    if (!_matchesEntirely(_safeKeyId, keyId)) {
      throw const InvalidClaimsException('Claim key_id has an invalid value.');
    }

    return LicenseClaims(
      tokenVersion: tokenVersion,
      issuer: string('issuer', 64),
      audience: string('audience', 128),
      licenseId: string('license_id', 128),
      activationId: string('activation_id', 128),
      edition: string('edition', 64),
      appId: string('app_id', 128),
      installationThumbprint: string('installation_thumbprint', 256),
      issuedAt: issuedAt,
      notBefore: notBefore,
      recheckAfter: recheckAfter,
      graceEndsAt: graceEndsAt,
      maxDevices: maxDevices,
      keyId: keyId,
    );
  }

  int _date(int value) {
    if (value < 0 || value > _maxUnixTimeSeconds) {
      throw const InvalidClaimsException(
        'A license date is outside the accepted range.',
      );
    }
    return value;
  }

  void _validateContext(LicenseVerificationContext context) {
    if (context.currentTimeSeconds < 0 ||
        context.currentTimeSeconds > _maxUnixTimeSeconds ||
        (context.lastServerTimeSeconds != null &&
            (context.lastServerTimeSeconds! < 0 ||
                context.lastServerTimeSeconds! > _maxUnixTimeSeconds))) {
      throw const InvalidBindingException(
        'Verification time context is invalid.',
      );
    }
  }

  bool _matchesEntirely(RegExp expression, String value) {
    final match = expression.matchAsPrefix(value);
    return match != null && match.end == value.length;
  }
}

/// Extracts decoded member names from a JSON root object.
///
/// `jsonDecode` validates the full grammar; this scanner exists because its
/// normal map representation would otherwise silently overwrite duplicates.
class _TopLevelJsonKeys {
  final String source;
  int _offset = 0;

  _TopLevelJsonKeys(this.source);

  List<String> read() {
    final keys = <String>[];
    _skipWhitespace();
    _expect('{');
    _skipWhitespace();
    if (_consume('}')) {
      return keys;
    }
    while (true) {
      final rawKey = _readString();
      keys.add(jsonDecode(rawKey) as String);
      _skipWhitespace();
      _expect(':');
      _skipWhitespace();
      _skipValue();
      _skipWhitespace();
      if (_consume('}')) {
        return keys;
      }
      _expect(',');
      _skipWhitespace();
    }
  }

  void _skipValue() {
    if (_offset >= source.length) {
      throw const FormatException();
    }
    final char = source[_offset];
    if (char == '"') {
      _readString();
      return;
    }
    if (char == '{') {
      _skipContainer();
      return;
    }
    if (char == '[') {
      _skipContainer();
      return;
    }
    while (_offset < source.length && !',}] \t\r\n'.contains(source[_offset])) {
      _offset++;
    }
  }

  void _skipContainer() {
    final closings = <String>[];
    while (_offset < source.length) {
      final char = source[_offset];
      if (char == '"') {
        _readString();
        continue;
      }
      _offset++;
      if (char == '{') {
        closings.add('}');
      } else if (char == '[') {
        closings.add(']');
      } else if (closings.isNotEmpty && char == closings.last) {
        closings.removeLast();
        if (closings.isEmpty) {
          return;
        }
      }
    }
    throw const FormatException();
  }

  String _readString() {
    final start = _offset;
    _expect('"');
    var escaped = false;
    while (_offset < source.length) {
      final char = source[_offset++];
      if (escaped) {
        escaped = false;
      } else if (char == r'\') {
        escaped = true;
      } else if (char == '"') {
        return source.substring(start, _offset);
      }
    }
    throw const FormatException();
  }

  void _skipWhitespace() {
    while (_offset < source.length && ' \t\r\n'.contains(source[_offset])) {
      _offset++;
    }
  }

  bool _consume(String expected) {
    if (_offset < source.length && source[_offset] == expected) {
      _offset++;
      return true;
    }
    return false;
  }

  void _expect(String expected) {
    if (!_consume(expected)) {
      throw const FormatException();
    }
  }
}
