import 'dart:convert';
import 'package:test/test.dart';
import 'package:license_manager/license_manager.dart';
import 'support/jws_test_generator.dart';

void main() {
  late JwsTestGenerator generator;
  late TrustedLicenseKeySet trustedKeys;
  late TrustedLicenseKeySet trustedKeysWithRotation;
  late JwsTestGenerator oldGenerator;

  const defaultContext = LicenseVerificationContext(
    expectedIssuer: 'SAMTECH',
    expectedAudience: 'samtech_crm',
    expectedAppId: 'samtech.crm.starter',
    expectedEdition: 'starter',
    expectedInstallationThumbprint: 'THUMB_123',
    currentTimeSeconds: 100000,
    lastServerTimeSeconds: 99000,
  );

  final defaultPayload = <String, dynamic>{
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

  setUp(() async {
    generator = await JwsTestGenerator.create(
      kid: 'key_1',
      seed: List.filled(32, 1),
    );
    trustedKeys = TrustedLicenseKeySet([
      TrustedLicenseKey(kid: 'key_1', publicKey: await generator.publicKey),
    ]);

    oldGenerator = await JwsTestGenerator.create(
      kid: 'key_0',
      seed: List.filled(32, 0),
    );
    trustedKeysWithRotation = TrustedLicenseKeySet([
      TrustedLicenseKey(kid: 'key_1', publicKey: await generator.publicKey),
      TrustedLicenseKey(kid: 'key_0', publicKey: await oldGenerator.publicKey),
    ]);
  });

  group('Signature & Structure', () {
    const verifier = Ed25519LicenseTokenVerifier();

    test('Valid token evaluates to valid', () async {
      final token = await generator.generate(payload: defaultPayload);
      final result = await verifier.verify(
        token: token,
        trustedKeys: trustedKeys,
        context: defaultContext,
      );
      expect(result.state, LicenseState.valid);
      expect(result.requiresOnlineCheck, false);
    });

    test('Modified payload fails signature validation', () async {
      final token = await generator.generate(payload: defaultPayload);
      final parts = token.split('.');
      final modifiedPayloadB64 = base64Url
          .encode(
            utf8.encode(jsonEncode({...defaultPayload, 'max_devices': 99})),
          )
          .replaceAll('=', '');
      final badToken = '${parts[0]}.$modifiedPayloadB64.${parts[2]}';

      expect(
        () => verifier.verify(
          token: badToken,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidSignatureException>()),
      );
    });

    test('Corrupted signature bytes', () async {
      final token = await generator.generate(
        payload: defaultPayload,
        corruptSignature: true,
      );
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidSignatureException>()),
      );
    });

    test('Signature length mismatch', () async {
      final token = await generator.generate(payload: defaultPayload);
      final parts = token.split('.');
      final badSig = base64Url.encode(List.filled(63, 0)).replaceAll('=', '');
      final badToken = '${parts[0]}.${parts[1]}.$badSig';

      expect(
        () => verifier.verify(
          token: badToken,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidSignatureException>()),
      );
    });

    test('Missing segments', () async {
      expect(
        () => verifier.verify(
          token: 'a.b',
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidFormatException>()),
      );
    });

    test('Empty token', () async {
      expect(
        () => verifier.verify(
          token: '',
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidFormatException>()),
      );
    });

    test('Too many segments', () async {
      expect(
        () => verifier.verify(
          token: 'a.b.c.d',
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidFormatException>()),
      );
    });

    test('Base64 padding is rejected', () async {
      // Create a valid token, then manually pad a segment if possible
      final token = await generator.generate(payload: defaultPayload);
      final parts = token.split('.');
      final badToken = '${parts[0]}=.${parts[1]}.${parts[2]}';

      expect(
        () => verifier.verify(
          token: badToken,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidFormatException>()),
      );
    });
  });

  group('Header Rules', () {
    const verifier = Ed25519LicenseTokenVerifier();

    test('alg: none is rejected', () async {
      final token = await generator.generate(
        customHeader: {'alg': 'none', 'typ': 'SAMTECH-LICENSE', 'kid': 'key_1'},
        payload: defaultPayload,
      );
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidHeaderException>()),
      );
    });

    test('Wrong typ is rejected', () async {
      final token = await generator.generate(
        customHeader: {'alg': 'EdDSA', 'typ': 'JWT', 'kid': 'key_1'},
        payload: defaultPayload,
      );
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidHeaderException>()),
      );
    });

    test('Missing kid is rejected', () async {
      final token = await generator.generate(
        customHeader: {'alg': 'EdDSA', 'typ': 'SAMTECH-LICENSE'},
        payload: defaultPayload,
      );
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidHeaderException>()),
      );
    });

    test('Unknown kid throws KeyNotFoundException', () async {
      final token = await generator.generate(
        customHeader: {
          'alg': 'EdDSA',
          'typ': 'SAMTECH-LICENSE',
          'kid': 'key_unknown',
        },
        payload: defaultPayload,
      );
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<KeyNotFoundException>()),
      );
    });
  });

  group('Claims & Binding', () {
    const verifier = Ed25519LicenseTokenVerifier();

    Future<void> expectBindingError(
      Map<String, dynamic> modifiedPayload,
    ) async {
      final token = await generator.generate(
        payload: {...defaultPayload, ...modifiedPayload},
      );
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidBindingException>()),
      );
    }

    Future<void> expectClaimsError(Map<String, dynamic> modifiedPayload) async {
      final token = await generator.generate(
        payload: {...defaultPayload, ...modifiedPayload},
      );
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidClaimsException>()),
      );
    }

    test('Wrong issuer', () => expectBindingError({'issuer': 'OTHER'}));
    test('Wrong audience', () => expectBindingError({'audience': 'other_app'}));
    test('Wrong appId', () => expectBindingError({'app_id': 'other'}));
    test('Wrong edition', () => expectBindingError({'edition': 'pro'}));
    test(
      'Wrong thumbprint',
      () => expectBindingError({'installation_thumbprint': 'THUMB_999'}),
    );
    test(
      'KeyId mismatch with header kid',
      () => expectBindingError({'key_id': 'key_0'}),
    );

    test('Wrong token_version', () => expectClaimsError({'token_version': 2}));
    test('max_devices <= 0', () => expectClaimsError({'max_devices': 0}));
    test('Missing field', () async {
      final payload = Map<String, dynamic>.from(defaultPayload);
      payload.remove('issuer');
      final token = await generator.generate(payload: payload);
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<InvalidClaimsException>()),
      );
    });
    test('Wrong field type', () => expectClaimsError({'issued_at': '90000'}));

    test(
      'Chronological failure',
      () => expectClaimsError({'not_before': 130000, 'recheck_after': 110000}),
    );
  });

  group('Time & States', () {
    const verifier = Ed25519LicenseTokenVerifier();

    test('License not yet valid', () async {
      final token = await generator.generate(payload: defaultPayload);
      final ctx = LicenseVerificationContext(
        expectedIssuer: defaultContext.expectedIssuer,
        expectedAudience: defaultContext.expectedAudience,
        expectedAppId: defaultContext.expectedAppId,
        expectedEdition: defaultContext.expectedEdition,
        expectedInstallationThumbprint:
            defaultContext.expectedInstallationThumbprint,
        currentTimeSeconds: 80000,
        lastServerTimeSeconds: 80000,
      );
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: ctx,
        ),
        throwsA(isA<InvalidClaimsException>()),
      );
    });

    test('In grace period', () async {
      final token = await generator.generate(payload: defaultPayload);
      final ctx = LicenseVerificationContext(
        expectedIssuer: defaultContext.expectedIssuer,
        expectedAudience: defaultContext.expectedAudience,
        expectedAppId: defaultContext.expectedAppId,
        expectedEdition: defaultContext.expectedEdition,
        expectedInstallationThumbprint:
            defaultContext.expectedInstallationThumbprint,
        currentTimeSeconds:
            115000, // > recheckAfter(110000) and < graceEndsAt(120000)
        lastServerTimeSeconds: 115000,
      );
      final result = await verifier.verify(
        token: token,
        trustedKeys: trustedKeys,
        context: ctx,
      );
      expect(result.state, LicenseState.grace);
      expect(result.requiresOnlineCheck, true);
    });

    test('Expired', () async {
      final token = await generator.generate(payload: defaultPayload);
      final ctx = LicenseVerificationContext(
        expectedIssuer: defaultContext.expectedIssuer,
        expectedAudience: defaultContext.expectedAudience,
        expectedAppId: defaultContext.expectedAppId,
        expectedEdition: defaultContext.expectedEdition,
        expectedInstallationThumbprint:
            defaultContext.expectedInstallationThumbprint,
        currentTimeSeconds: 125000, // > graceEndsAt(120000)
        lastServerTimeSeconds: 125000,
      );
      final result = await verifier.verify(
        token: token,
        trustedKeys: trustedKeys,
        context: ctx,
      );
      expect(result.state, LicenseState.expired);
      expect(result.requiresOnlineCheck, true);
    });

    test('Clock rollback uses last server time', () async {
      final token = await generator.generate(payload: defaultPayload);
      final ctx = LicenseVerificationContext(
        expectedIssuer: defaultContext.expectedIssuer,
        expectedAudience: defaultContext.expectedAudience,
        expectedAppId: defaultContext.expectedAppId,
        expectedEdition: defaultContext.expectedEdition,
        expectedInstallationThumbprint:
            defaultContext.expectedInstallationThumbprint,
        currentTimeSeconds: 95000,
        lastServerTimeSeconds:
            115000, // server time is higher (rollback detected)
      );
      final result = await verifier.verify(
        token: token,
        trustedKeys: trustedKeys,
        context: ctx,
      );

      // effective time is 115000, so it's in grace
      expect(result.state, LicenseState.grace);
      expect(result.requiresOnlineCheck, true);
    });
  });

  group('Rotation', () {
    const verifier = Ed25519LicenseTokenVerifier();

    test('Accepts token from old key still in set', () async {
      final oldPayload = {...defaultPayload, 'key_id': 'key_0'};
      final token = await oldGenerator.generate(payload: oldPayload);

      final result = await verifier.verify(
        token: token,
        trustedKeys: trustedKeysWithRotation,
        context: defaultContext,
      );
      expect(result.state, LicenseState.valid);
    });

    test('Rejects token from key removed from set', () async {
      final oldPayload = {...defaultPayload, 'key_id': 'key_0'};
      final token = await oldGenerator.generate(payload: oldPayload);

      // trustedKeys only contains key_1
      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeys,
          context: defaultContext,
        ),
        throwsA(isA<KeyNotFoundException>()),
      );
    });

    test('Rejects if header kid does not match signature key', () async {
      // generate with oldGenerator (key_0 signature) but claim it's key_1
      final token = await oldGenerator.generate(
        customHeader: {
          'alg': 'EdDSA',
          'typ': 'SAMTECH-LICENSE',
          'kid': 'key_1',
        },
        payload: defaultPayload,
      );

      expect(
        () => verifier.verify(
          token: token,
          trustedKeys: trustedKeysWithRotation,
          context: defaultContext,
        ),
        throwsA(isA<InvalidSignatureException>()),
      );
    });
  });
}
