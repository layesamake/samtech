import 'package:meta/meta.dart';

@immutable
class LicenseClaims {
  final int tokenVersion;
  final String issuer;
  final String audience;
  final String licenseId;
  final String activationId;
  final String edition;
  final String appId;
  final String installationThumbprint;
  final int issuedAt;
  final int notBefore;
  final int recheckAfter;
  final int graceEndsAt;
  final int maxDevices;
  final String keyId;

  const LicenseClaims({
    required this.tokenVersion,
    required this.issuer,
    required this.audience,
    required this.licenseId,
    required this.activationId,
    required this.edition,
    required this.appId,
    required this.installationThumbprint,
    required this.issuedAt,
    required this.notBefore,
    required this.recheckAfter,
    required this.graceEndsAt,
    required this.maxDevices,
    required this.keyId,
  });
}
