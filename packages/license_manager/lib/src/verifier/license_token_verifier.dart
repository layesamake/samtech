import '../models/license_evaluation.dart';
import '../models/license_verification_context.dart';
import '../models/trusted_license_key.dart';

abstract class LicenseTokenVerifier {
  /// Verifies a token strictly according to JWS EdDSA rules and SAMTECH business rules.
  Future<LicenseEvaluation> verify({
    required String token,
    required TrustedLicenseKeySet trustedKeys,
    required LicenseVerificationContext context,
  });
}
