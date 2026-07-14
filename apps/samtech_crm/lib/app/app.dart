import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samtech_ui_kit/samtech_ui_kit.dart';

import 'app_config.dart';
import 'router/app_router.dart';

/// Root widget responsible only for application-wide composition.
class SamtechApp extends ConsumerWidget {
  const SamtechApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return MaterialApp.router(
      title: config.name,
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: SamtechTheme.light(),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
