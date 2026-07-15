import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Écran temporaire de démarrage indiquant que le socle est opérationnel.
class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(SamtechSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: SamtechSpacing.space12,
                color: theme.colorScheme.secondary,
                semanticLabel: 'Succès',
              ),
              const SizedBox(height: SamtechSpacing.space4),
              const Text(
                'SAMTECH CRM',
                style: SamtechTypography.title1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SamtechSpacing.space2),
              const Text(
                'Socle technique opérationnel.',
                style: SamtechTypography.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
