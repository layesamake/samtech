import 'package:meta/meta.dart';

@immutable
class LicenseVerificationContext {
  final String expectedIssuer;
  final String expectedAudience;
  final String expectedAppId;
  final String expectedEdition;
  final String expectedInstallationThumbprint;
  final int currentTimeSeconds;
  final int? lastServerTimeSeconds;

  const LicenseVerificationContext({
    required this.expectedIssuer,
    required this.expectedAudience,
    required this.expectedAppId,
    required this.expectedEdition,
    required this.expectedInstallationThumbprint,
    required this.currentTimeSeconds,
    this.lastServerTimeSeconds,
  });

  /// The effective time must not be earlier than the last known authenticated server time.
  int get effectiveTimeSeconds {
    if (lastServerTimeSeconds != null &&
        currentTimeSeconds < lastServerTimeSeconds!) {
      return lastServerTimeSeconds!;
    }
    return currentTimeSeconds;
  }
}
