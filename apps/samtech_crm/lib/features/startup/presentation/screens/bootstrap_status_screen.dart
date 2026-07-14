import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samtech_ui_kit/samtech_ui_kit.dart';

import '../routes/startup_routes.dart';

/// Confirms that navigation is operational without exposing a business module.
class BootstrapStatusScreen extends StatelessWidget {
  const BootstrapStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('État du socle')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Navigation opérationnelle'),
            const SizedBox(height: SamtechSpacing.space4),
            OutlinedButton(
              onPressed: () => context.go(StartupRoutePaths.startup),
              child: const Text('Retour au démarrage'),
            ),
          ],
        ),
      ),
    );
  }
}
