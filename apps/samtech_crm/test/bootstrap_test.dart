import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samtech_crm/app/app.dart';
import 'package:samtech_crm/bootstrap.dart';

void main() {
  testWidgets('bootstrap initializes bindings before mounting the app', (
    tester,
  ) async {
    var initializationRan = false;

    await bootstrap(
      beforeRunApp: () {
        initializationRan = true;
        expect(WidgetsBinding.instance, isNotNull);
      },
    );
    await tester.pump();

    expect(initializationRan, isTrue);
    expect(find.byType(ProviderScope), findsOneWidget);
    expect(find.byType(SamtechApp), findsOneWidget);
  });
}
