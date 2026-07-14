import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:samtech_crm/app/app.dart';

void main() {
  testWidgets('navigates from startup to bootstrap status and back', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SamtechApp()));
    await tester.pumpAndSettle();

    expect(find.text('Le socle SAMTECH CRM est prêt.'), findsOneWidget);

    await tester.tap(
      find.widgetWithText(FilledButton, 'Vérifier la navigation'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Navigation opérationnelle'), findsOneWidget);

    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Retour au démarrage'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Le socle SAMTECH CRM est prêt.'), findsOneWidget);
  });

  testWidgets('unknown routes display a safe fallback', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SamtechApp()));
    await tester.pumpAndSettle();

    final context = tester.element(find.text('SAMTECH CRM'));
    GoRouter.of(context).go('/route-with-sensitive-value');
    await tester.pumpAndSettle();

    expect(find.text('Page introuvable'), findsOneWidget);
    expect(find.textContaining('route-with-sensitive-value'), findsNothing);
    expect(find.textContaining('no routes for location'), findsNothing);
  });
}
