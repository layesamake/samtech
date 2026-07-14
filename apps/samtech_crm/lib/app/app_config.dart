import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable values selected before the application is mounted.
class AppConfig {
  const AppConfig({this.name = 'SAMTECH CRM', this.showDebugBanner = false});

  final String name;
  final bool showDebugBanner;
}

/// Stable application configuration, replaceable in tests and future flavors.
final appConfigProvider = Provider<AppConfig>((ref) => const AppConfig());
