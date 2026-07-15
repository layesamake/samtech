import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/app_config.dart';

/// Démarre l'application avec la configuration fournie.
void bootstrap(AppConfig config) {
  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const SamtechApp(),
    ),
  );
}
