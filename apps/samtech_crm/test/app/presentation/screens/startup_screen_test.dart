import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samtech_crm/app/presentation/screens/startup_screen.dart';

void main() {
  testWidgets('StartupScreen displays check icon and success message', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: StartupScreen()));

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    expect(find.text('SAMTECH CRM'), findsOneWidget);
    expect(find.text('Socle technique opérationnel.'), findsOneWidget);
  });
}
