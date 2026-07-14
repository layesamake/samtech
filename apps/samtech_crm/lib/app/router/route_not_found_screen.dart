import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samtech_ui_kit/samtech_ui_kit.dart';

import '../../features/startup/presentation/routes/startup_routes.dart';

/// Safe fallback that never renders route internals or user-provided values.
class RouteNotFoundScreen extends StatelessWidget {
  const RouteNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(SamtechSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Page introuvable',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SamtechSpacing.space2),
              const Text('Cette destination n’est pas disponible.'),
              const SizedBox(height: SamtechSpacing.space4),
              FilledButton(
                onPressed: () => context.go(StartupRoutePaths.startup),
                child: const Text('Revenir au démarrage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
