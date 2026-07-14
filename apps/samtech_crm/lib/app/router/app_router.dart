import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/startup/presentation/routes/startup_routes.dart';
import '../../features/startup/presentation/screens/bootstrap_status_screen.dart';
import '../../features/startup/presentation/screens/startup_screen.dart';
import 'route_not_found_screen.dart';

/// Declarative router composed at the application boundary.
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: StartupRoutePaths.startup,
    errorBuilder: (context, state) => const RouteNotFoundScreen(),
    routes: [
      GoRoute(
        path: StartupRoutePaths.startup,
        builder: (context, state) => const StartupScreen(),
      ),
      GoRoute(
        path: StartupRoutePaths.bootstrapStatus,
        builder: (context, state) => const BootstrapStatusScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
