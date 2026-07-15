import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samtech_crm/app/app.dart';
import 'package:samtech_crm/app/app_config.dart';
import 'package:samtech_crm/bootstrap.dart';

void main() {
  testWidgets('bootstrap mounts the app with its configuration override', (
    tester,
  ) async {
    const config = AppConfig(environment: Environment.development);

    bootstrap(config);
    await tester.pumpAndSettle();

    expect(find.byType(SamtechApp), findsOneWidget);

    final context = tester.element(find.byType(SamtechApp));
    final container = ProviderScope.containerOf(context, listen: false);
    expect(container.read(appConfigProvider), same(config));
  });
}
