import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

import 'router/app_router.dart';

/// Racine matérielle de l'application.
class SamtechApp extends ConsumerWidget {
  const SamtechApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'SAMTECH CRM',
      theme: SamtechTheme.light(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
