import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:license_manager/license_manager.dart';
import 'package:test/test.dart';

import 'support/jws_test_generator.dart';

void main() {
  late JwsTestGenerator generator;
  late SimplePublicKey publicKey;
  late TrustedLicenseKeySet keys;

  const context = LicenseVerificationContext(
    expectedIssuer: 'SAMTECH',
    expectedAudience: 'samtech_crm',
    expectedAppId: 'samtech.crm.starter',
    expectedEdition: 'starter',
    expectedInstallationThumbprint: 'THUMB_123',
    currentTimeSeconds: 100000,
    lastServerTimeSeconds: 99000,
  );
  final payload = <String, dynamic>{
    'token_version': 1,
    'issuer': 'SAMTECH',
    'audience': 'samtech_crm',
    'license_id': 'LIC_123',
    'activation_id': 'ACT_123',
    'edition': 'starter',
    'app_id': 'samtech.crm.starter',
    'installation_thumbprint': 'THUMB_123',
    'issued_at': 90000,
    'not_before': 90000,
    'recheck_after': 110000,
    'grace_ends_at': 120000,
    'max_devices': 1,
    'key_id': 'key_1',
  };
  const verifier = Ed25519LicenseTokenVerifier();

  Future<void> expectError(
    String token,
    Matcher matcher, {
    TrustedLicenseKeySet? trustedKeys,
    LicenseVerificationContext verificationContext = context,
  }) async {
    await expectLater(
      verifier.verify(
        token: token,
        trustedKeys: trustedKeys ?? keys,
        context: verificationContext,
      ),
      throwsA(matcher),
    );
  }

  String b64(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');
  String repeat(String value, int count) =>
      List<String>.filled(count, value).join();

  setUp(() async {
    generator = await JwsTestGenerator.create(
      kid: 'key_1',
      seed: List<int>.filled(32, 1),
    );
    publicKey = await generator.publicKey;
    keys = TrustedLicenseKeySet([
      TrustedLicenseKey(kid: 'key_1', publicKey: publicKey),
    ]);
  });

  group('independent normative vector', () {
    test('RFC 8037 Appendix A.4 Ed25519 JWS verifies', () async {
      const signingInput =
          'eyJhbGciOiJFZERTQSJ9.RXhhbXBsZSBvZiBFZDI1NTE5IHNpZ25pbmc';
      const signatureB64 =
          'hgyY0il_MGCjP0JzlnLWG1PPOt7-09PGcvMg3AIbQR6dWbhijcNR4ki4iylGjg5BhVsPt9g7sVvpAr_MuM0KAg';
      const publicKeyB64 = '11qYAYKxCrfVS_7TyWQHOg7hcvPapiMlrwIaaPcHURo';
      final rfcPublicKey = SimplePublicKey(
        base64Url.decode(base64Url.normalize(publicKeyB64)),
        type: KeyPairType.ed25519,
      );
      final signature = Signature(
        base64Url.decode(base64Url.normalize(signatureB64)),
        publicKey: rfcPublicKey,
      );

      expect(rfcPublicKey.bytes, hasLength(32));
      expect(signature.bytes, hasLength(64));
      expect(
        await Ed25519().verify(utf8.encode(signingInput), signature: signature),
        isTrue,
      );

      final corrupted = List<int>.from(signature.bytes)..[0] ^= 1;
      expect(
        await Ed25519().verify(
          utf8.encode(signingInput),
          signature: Signature(corrupted, publicKey: rfcPublicKey),
        ),
        isFalse,
      );
    });
  });

  group('compact and canonical parsing', () {
    for (final token in ['', '.', '..', 'a.b', 'a.b.c.d']) {
      test('rejects invalid segment structure ${jsonEncode(token)}', () async {
        await expectError(token, isA<InvalidFormatException>());
      });
    }

    test('rejects each empty segment', () async {
      for (final token in ['.YQ.YQ', 'YQ..YQ', 'YQ.YQ.']) {
        await expectError(token, isA<InvalidFormatException>());
      }
    });

    test('rejects padding and all non-base64url character classes', () async {
      final valid = await generator.generate(payload: payload);
      final parts = valid.split('.');
      for (final invalid in [
        '=',
        '+',
        '/',
        '!',
        '%',
        ' ',
        '\t',
        '\r',
        '\n',
        'é',
        '☃',
      ]) {
        await expectError(
          '${parts[0]}$invalid.${parts[1]}.${parts[2]}',
          isA<InvalidFormatException>(),
        );
      }
    });

    test(
      'rejects impossible base64url lengths and non-canonical encodings',
      () async {
        for (final segment in ['A', 'AAAAA']) {
          await expectError('$segment.e30.AAAA', isA<InvalidFormatException>());
        }
      },
    );

    test('rejects oversized token, protected header, and payload', () async {
      await expectError(repeat('A', 13000), isA<InvalidFormatException>());
      await expectError(
        '${repeat('A', 1028)}.e30.AAAA',
        isA<InvalidFormatException>(),
      );
      await expectError(
        'e30.${repeat('A', 8196)}.AAAA',
        isA<InvalidFormatException>(),
      );
    });

    test('rejects signature sizes 0, 63, 64 invalid, and 65 bytes', () async {
      final token = await generator.generate(payload: payload);
      final parts = token.split('.');
      await expectError(
        '${parts[0]}.${parts[1]}.',
        isA<InvalidFormatException>(),
      );
      for (final size in [63, 64, 65]) {
        await expectError(
          '${parts[0]}.${parts[1]}.${b64(List<int>.filled(size, 0))}',
          isA<InvalidSignatureException>(),
        );
      }
    });
  });

  group('strict protected header', () {
    Future<String> withHeader(Object header) => generator.generateRaw(
      headerBytes: utf8.encode(jsonEncode(header)),
      payloadBytes: utf8.encode(jsonEncode(payload)),
    );

    for (final algorithm in [
      'none',
      'HS256',
      'ES256',
      'RS256',
      'Ed448',
      'eddsa',
    ]) {
      test('rejects algorithm $algorithm', () async {
        final token = await withHeader({
          'alg': algorithm,
          'typ': 'SAMTECH-LICENSE',
          'kid': 'key_1',
        });
        await expectError(token, isA<InvalidHeaderException>());
      });
    }

    for (final member in ['jku', 'jwk', 'x5u', 'x5c', 'crit', 'unknown']) {
      test('rejects protected header member $member', () async {
        final token = await withHeader({
          'alg': 'EdDSA',
          'typ': 'SAMTECH-LICENSE',
          'kid': 'key_1',
          member: member == 'x5c' ? <String>[] : 'value',
        });
        await expectError(token, isA<InvalidHeaderException>());
      });
    }

    test('rejects invalid JSON, non-object roots, and invalid UTF-8', () async {
      for (final bytes in [
        utf8.encode('{'),
        utf8.encode('[]'),
        utf8.encode('"header"'),
        utf8.encode('null'),
        <int>[0xff],
      ]) {
        final token = await generator.generateRaw(
          headerBytes: bytes,
          payloadBytes: utf8.encode(jsonEncode(payload)),
        );
        await expectError(token, isA<InvalidHeaderException>());
      }
    });

    test('rejects duplicate kid including escaped spelling', () async {
      for (final source in [
        '{"alg":"EdDSA","typ":"SAMTECH-LICENSE","kid":"key_1","kid":"key_1"}',
        '{"alg":"EdDSA","typ":"SAMTECH-LICENSE","kid":"key_1","k\\u0069d":"key_1"}',
      ]) {
        final token = await generator.generateRaw(
          headerBytes: utf8.encode(source),
          payloadBytes: utf8.encode(jsonEncode(payload)),
        );
        await expectError(token, isA<InvalidHeaderException>());
      }
    });

    test('kid cannot be empty, long, URL, path, or control-bearing', () async {
      for (final kid in [
        '',
        repeat('a', 65),
        'https://example.test/key',
        '../key',
        'key\r',
        'key\nlog',
        'key\r\nlog',
      ]) {
        final token = await withHeader({
          'alg': 'EdDSA',
          'typ': 'SAMTECH-LICENSE',
          'kid': kid,
        });
        await expectError(token, isA<InvalidHeaderException>());
      }
    });

    test('unknown kid error does not echo attacker-controlled value', () async {
      final token = await withHeader({
        'alg': 'EdDSA',
        'typ': 'SAMTECH-LICENSE',
        'kid': 'attacker_controlled',
      });
      try {
        await verifier.verify(
          token: token,
          trustedKeys: keys,
          context: context,
        );
        fail('Expected verification to fail');
      } on KeyNotFoundException catch (error) {
        expect(error.toString(), isNot(contains('attacker_controlled')));
      }
    });
  });

  group('payload is interpreted only after signature verification', () {
    test(
      'invalid signature wins over malformed payload JSON and UTF-8',
      () async {
        for (final bytes in [
          utf8.encode('{'),
          <int>[0xff],
        ]) {
          final token = await generator.generateRaw(
            headerBytes: utf8.encode(
              jsonEncode({
                'alg': 'EdDSA',
                'typ': 'SAMTECH-LICENSE',
                'kid': 'key_1',
              }),
            ),
            payloadBytes: bytes,
            corruptSignature: true,
          );
          await expectError(token, isA<InvalidSignatureException>());
        }
      },
    );

    test('signed invalid JSON, root values, and UTF-8 are rejected', () async {
      for (final bytes in [
        utf8.encode('{'),
        utf8.encode('[]'),
        utf8.encode('"payload"'),
        utf8.encode('null'),
        <int>[0xff],
      ]) {
        final token = await generator.generateRaw(
          headerBytes: utf8.encode(
            jsonEncode({
              'alg': 'EdDSA',
              'typ': 'SAMTECH-LICENSE',
              'kid': 'key_1',
            }),
          ),
          payloadBytes: bytes,
        );
        await expectError(token, isA<InvalidClaimsException>());
      }
    });

    test('duplicate audience including escaped spelling is rejected', () async {
      final prefix = jsonEncode(
        payload,
      ).substring(0, jsonEncode(payload).length - 1);
      for (final suffix in [
        ',"audience":"samtech_crm"}',
        ',"aud\\u0069ence":"samtech_crm"}',
      ]) {
        final token = await generator.generateRaw(
          headerBytes: utf8.encode(
            jsonEncode({
              'alg': 'EdDSA',
              'typ': 'SAMTECH-LICENSE',
              'kid': 'key_1',
            }),
          ),
          payloadBytes: utf8.encode('$prefix$suffix'),
        );
        await expectError(token, isA<InvalidClaimsException>());
      }
    });

    test('unknown claim is rejected', () async {
      final token = await generator.generate(
        payload: {...payload, 'extra': true},
      );
      await expectError(token, isA<InvalidClaimsException>());
    });
  });

  group('claims and bindings', () {
    test('each mandatory claim is rejected when absent', () async {
      for (final name in payload.keys) {
        final modified = Map<String, dynamic>.from(payload)..remove(name);
        await expectError(
          await generator.generate(payload: modified),
          isA<InvalidClaimsException>(),
        );
      }
    });

    test(
      'every String claim rejects empty, wrong type, and excessive values',
      () async {
        const names = [
          'issuer',
          'audience',
          'license_id',
          'activation_id',
          'edition',
          'app_id',
          'installation_thumbprint',
          'key_id',
        ];
        for (final name in names) {
          for (final value in <Object?>[
            '',
            ' ',
            'bad\nvalue',
            null,
            7,
            repeat('x', 300),
          ]) {
            await expectError(
              await generator.generate(payload: {...payload, name: value}),
              isA<InvalidClaimsException>(),
            );
          }
        }
      },
    );

    test('integer claims reject empty and wrong types', () async {
      for (final name in [
        'token_version',
        'issued_at',
        'not_before',
        'recheck_after',
        'grace_ends_at',
        'max_devices',
      ]) {
        for (final value in <Object>['', 1.0, true]) {
          await expectError(
            await generator.generate(payload: {...payload, name: value}),
            isA<InvalidClaimsException>(),
          );
        }
      }
    });

    test('version, max_devices, dates, and chronology are bounded', () async {
      for (final change in [
        {'token_version': 0},
        {'token_version': 2},
        {'max_devices': 0},
        {'max_devices': -1},
        {'max_devices': 1000001},
        {'issued_at': -1},
        {'not_before': 253402300800},
        {'recheck_after': -1},
        {'grace_ends_at': 253402300800},
        {'issued_at': 90001, 'not_before': 90000},
        {'not_before': 110001, 'recheck_after': 110000},
        {'recheck_after': 120001, 'grace_ends_at': 120000},
      ]) {
        await expectError(
          await generator.generate(payload: {...payload, ...change}),
          isA<InvalidClaimsException>(),
        );
      }
    });

    test('future dates are rejected', () async {
      final token = await generator.generate(
        payload: {
          ...payload,
          'issued_at': 200000,
          'not_before': 200000,
          'recheck_after': 210000,
          'grace_ends_at': 220000,
        },
      );
      await expectError(token, isA<InvalidClaimsException>());
    });

    test('each contextual binding is strict', () async {
      for (final change in [
        {'issuer': 'OTHER'},
        {'audience': 'other'},
        {'app_id': 'other'},
        {'edition': 'other'},
        {'installation_thumbprint': 'other'},
        {'key_id': 'other_key'},
      ]) {
        await expectError(
          await generator.generate(payload: {...payload, ...change}),
          isA<InvalidBindingException>(),
        );
      }
    });
  });

  group('time boundaries and rollback', () {
    LicenseVerificationContext at(int current, {int? server}) =>
        LicenseVerificationContext(
          expectedIssuer: context.expectedIssuer,
          expectedAudience: context.expectedAudience,
          expectedAppId: context.expectedAppId,
          expectedEdition: context.expectedEdition,
          expectedInstallationThumbprint:
              context.expectedInstallationThumbprint,
          currentTimeSeconds: current,
          lastServerTimeSeconds: server,
        );

    test('checks every exact temporal boundary', () async {
      final token = await generator.generate(payload: payload);
      await expectError(
        token,
        isA<InvalidClaimsException>(),
        verificationContext: at(89999),
      );
      for (final expected in <(int, LicenseState, bool)>[
        (90000, LicenseState.valid, false),
        (110000, LicenseState.valid, false),
        (110001, LicenseState.grace, true),
        (120000, LicenseState.grace, true),
        (120001, LicenseState.expired, true),
      ]) {
        final result = await verifier.verify(
          token: token,
          trustedKeys: keys,
          context: at(expected.$1),
        );
        expect(result.state, expected.$2);
        expect(result.requiresOnlineCheck, expected.$3);
      }
    });

    test(
      'rollback uses authenticated server time and never extends grace',
      () async {
        final token = await generator.generate(payload: payload);
        final inGrace = await verifier.verify(
          token: token,
          trustedKeys: keys,
          context: at(95000, server: 115000),
        );
        expect(inGrace.state, LicenseState.grace);
        expect(inGrace.requiresOnlineCheck, isTrue);

        final expired = await verifier.verify(
          token: token,
          trustedKeys: keys,
          context: at(95000, server: 120001),
        );
        expect(expired.state, LicenseState.expired);
        expect(expired.requiresOnlineCheck, isTrue);
      },
    );
  });

  group('trusted key set', () {
    test('rejects duplicate, empty, long, and incompatible keys', () {
      final key = TrustedLicenseKey(kid: 'key_1', publicKey: publicKey);
      expect(() => TrustedLicenseKeySet([key, key]), throwsArgumentError);
      expect(
        () => TrustedLicenseKey(kid: '', publicKey: publicKey),
        throwsArgumentError,
      );
      expect(
        () => TrustedLicenseKey(kid: repeat('a', 65), publicKey: publicKey),
        throwsArgumentError,
      );
      expect(
        () => TrustedLicenseKey(
          kid: 'x25519',
          publicKey: SimplePublicKey(
            List<int>.filled(32, 0),
            type: KeyPairType.x25519,
          ),
        ),
        throwsArgumentError,
      );
      expect(
        () => TrustedLicenseKey(
          kid: 'short',
          publicKey: SimplePublicKey(
            List<int>.filled(31, 0),
            type: KeyPairType.ed25519,
          ),
        ),
        throwsArgumentError,
      );
      expect(
        () => TrustedLicenseKey(
          kid: 'long',
          publicKey: SimplePublicKey(
            List<int>.filled(33, 0),
            type: KeyPairType.ed25519,
          ),
        ),
        throwsArgumentError,
      );
    });

    test(
      'accepts current and old enabled keys, rejects disabled key',
      () async {
        final oldGenerator = await JwsTestGenerator.create(
          kid: 'key_0',
          seed: List<int>.filled(32, 2),
        );
        final rotated = TrustedLicenseKeySet([
          TrustedLicenseKey(kid: 'key_1', publicKey: publicKey),
          TrustedLicenseKey(
            kid: 'key_0',
            publicKey: await oldGenerator.publicKey,
          ),
        ]);
        final currentToken = await generator.generate(payload: payload);
        final oldToken = await oldGenerator.generate(
          payload: {...payload, 'key_id': 'key_0'},
        );
        expect(
          (await verifier.verify(
            token: currentToken,
            trustedKeys: rotated,
            context: context,
          )).state,
          LicenseState.valid,
        );
        expect(
          (await verifier.verify(
            token: oldToken,
            trustedKeys: rotated,
            context: context,
          )).state,
          LicenseState.valid,
        );

        final disabled = TrustedLicenseKeySet([
          TrustedLicenseKey(
            kid: 'key_1',
            publicKey: publicKey,
            isEnabled: false,
          ),
        ]);
        await expectError(
          currentToken,
          isA<KeyNotFoundException>(),
          trustedKeys: disabled,
        );
      },
    );

    test('signature from a key other than kid is rejected', () async {
      final other = await JwsTestGenerator.create(
        kid: 'key_1',
        seed: List<int>.filled(32, 3),
      );
      final token = await other.generate(payload: payload);
      await expectError(token, isA<InvalidSignatureException>());
    });

    test(
      'copies public key bytes instead of retaining mutable input',
      () async {
        final mutableBytes = List<int>.from(publicKey.bytes);
        final copiedSet = TrustedLicenseKeySet([
          TrustedLicenseKey(
            kid: 'key_1',
            publicKey: SimplePublicKey(mutableBytes, type: KeyPairType.ed25519),
          ),
        ]);
        mutableBytes.fillRange(0, mutableBytes.length, 0);
        final token = await generator.generate(payload: payload);
        expect(
          (await verifier.verify(
            token: token,
            trustedKeys: copiedSet,
            context: context,
          )).state,
          LicenseState.valid,
        );
      },
    );
  });

  test('verification exceptions never contain token material', () async {
    final token = await generator.generate(
      payload: payload,
      corruptSignature: true,
    );
    try {
      await verifier.verify(token: token, trustedKeys: keys, context: context);
      fail('Expected verification to fail');
    } on LicenseVerificationException catch (error) {
      expect(error.toString(), isNot(contains(token)));
      for (final segment in token.split('.')) {
        expect(error.toString(), isNot(contains(segment)));
      }
    }
  });
}
