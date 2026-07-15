import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samtech_crm/app/router/app_router.dart';
import 'package:samtech_crm/app/presentation/screens/startup_screen.dart';

void main() {
  testWidgets('app router resolves initial route to StartupScreen', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(StartupScreen), findsOneWidget);
  });

  testWidgets('app router renders a not-found page for an unknown route', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    router.go('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('Erreur'), findsOneWidget);
    expect(find.text('Page introuvable.'), findsOneWidget);
  });
}
