import 'package:meta/meta.dart';
import 'license_state.dart';
import 'license_claims.dart';

@immutable
class LicenseEvaluation {
  final LicenseState state;
  final bool requiresOnlineCheck;
  final LicenseClaims claims;

  const LicenseEvaluation({
    required this.state,
    required this.requiresOnlineCheck,
    required this.claims,
  });
}
