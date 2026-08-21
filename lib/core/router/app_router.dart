import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/clock/pages/clock_page.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const clock = '/';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.clock,
    routes: [
      GoRoute(path: AppRoutes.clock, builder: (_, _) => const ClockPage()),
    ],
  );
}
