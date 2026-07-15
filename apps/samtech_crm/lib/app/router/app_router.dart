import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/startup_screen.dart';

/// Fournit l'instance de [GoRouter] pour l'application.
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const StartupScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Erreur')),
      body: const Center(child: Text('Page introuvable.')),
    ),
  );

  ref.onDispose(router.dispose);
  return router;
});
