import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/about/pages/about_page.dart';
import '../../features/clock/pages/clock_page.dart';
import '../../features/settings/pages/settings_page.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const clock = '/';
  static const settings = '/settings';
  static const about = '/about';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.clock,
    routes: [
      GoRoute(
        path: AppRoutes.clock,
        builder: (_, _) => const ClockPage(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (_, _) => const SettingsPage(),
          ),
          GoRoute(path: 'about', builder: (_, _) => const AboutPage()),
        ],
      ),
    ],
  );
}
