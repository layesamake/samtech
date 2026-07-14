import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/startup/presentation/screens/bootstrap_status_screen.dart';
import '../../features/startup/presentation/screens/startup_screen.dart';

abstract final class AppRoutePaths {
  static const startup = '/';
  static const bootstrapStatus = '/bootstrap-status';
}

/// Declarative router composed at the application boundary.
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutePaths.startup,
    routes: [
      GoRoute(
        path: AppRoutePaths.startup,
        builder: (context, state) => const StartupScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.bootstrapStatus,
        builder: (context, state) => const BootstrapStatusScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
