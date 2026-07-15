import 'app/app_config.dart';
import 'bootstrap.dart';

void main() {
  const config = AppConfig(environment: Environment.development);

  bootstrap(config);
}
