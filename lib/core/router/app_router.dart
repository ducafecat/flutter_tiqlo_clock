import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/about/pages/about_page.dart';
import '../../features/clock/pages/clock_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../features/splash/pages/splash_page.dart';
import '../../features/welcome/pages/welcome_page.dart';
import '../providers/app_launch_provider.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const clock = '/';
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const settings = '/settings';
  static const about = '/about';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(
  Ref ref, {
  bool showOnboarding = true,
  bool showWelcome = true,
}) {
  return GoRouter(
    initialLocation: showOnboarding ? AppRoutes.splash : AppRoutes.clock,
    redirect: (_, state) {
      if (!showOnboarding) return null;
      final location = state.matchedLocation;
      if (location == AppRoutes.splash) return null;
      if (!showWelcome) {
        return location == AppRoutes.welcome ? AppRoutes.clock : null;
      }

      final hasSeenWelcome = ref.read(appLaunchStorageProvider).hasSeenWelcome;
      if (!hasSeenWelcome) {
        return location == AppRoutes.welcome ? null : AppRoutes.welcome;
      }
      if (location == AppRoutes.welcome) return AppRoutes.clock;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => SplashPage(showWelcome: showWelcome),
      ),
      GoRoute(path: AppRoutes.welcome, builder: (_, _) => const WelcomePage()),
      GoRoute(
        path: AppRoutes.clock,
        builder: (_, _) => const ClockPage(),
        routes: [
          GoRoute(path: 'settings', builder: (_, _) => const SettingsPage()),
          GoRoute(path: 'about', builder: (_, _) => const AboutPage()),
        ],
      ),
    ],
  );
}
