import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samtech_ui_kit/samtech_ui_kit.dart';

import '../../../../app/router/app_router.dart';

/// Minimal Sprint 0 screen used to validate application startup and routing.
class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SAMTECH CRM')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(SamtechSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
                semanticLabel: 'Socle initialisé',
              ),
              const SizedBox(height: SamtechSpacing.space4),
              Text(
                'Le socle SAMTECH CRM est prêt.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SamtechSpacing.space2),
              const Text(
                'Sprint 0 · Flutter, Riverpod et go_router',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SamtechSpacing.space6),
              FilledButton(
                onPressed: () => context.go(AppRoutePaths.bootstrapStatus),
                child: const Text('Vérifier la navigation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
