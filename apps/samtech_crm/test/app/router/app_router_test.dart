import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
