import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samtech_crm/app/app_config.dart';

void main() {
  test('AppConfig exposes its environment', () {
    const config = AppConfig(environment: Environment.development);

    expect(config.environment, equals(Environment.development));
  });

  test('appConfigProvider throws without a bootstrap override', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      () => container.read(appConfigProvider),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('UnimplementedError: appConfigProvider doit être surchargé'),
        ),
      ),
    );
  });

  test('appConfigProvider returns its override', () {
    const config = AppConfig(environment: Environment.development);
    final container = ProviderContainer(
      overrides: [appConfigProvider.overrideWithValue(config)],
    );
    addTearDown(container.dispose);

    final resolvedConfig = container.read(appConfigProvider);
    expect(resolvedConfig, same(config));
  });
}
