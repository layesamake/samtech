import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Environnements de déploiement supportés.
enum Environment { development, staging, production }

/// Configuration globale de l'application.
class AppConfig {
  const AppConfig({required this.environment});

  final Environment environment;
}

/// Fournit la configuration courante de l'application.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError(
    'appConfigProvider doit être surchargé au bootstrap.',
  );
});
