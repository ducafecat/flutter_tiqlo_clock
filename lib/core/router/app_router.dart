import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/splash/pages/splash_page.dart';
import '../../features/welcome/pages/welcome_page.dart';
import '../providers/dio_provider.dart';

part 'app_router.g.dart';

/// 路由常量表。
///
/// 集中定义路径可以减少页面跳转时的字符串拼写错误，也方便后续统一改路由层级。
abstract final class AppRoutes {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const login = '/login';
  static const home = '/home';
}

/// 应用路由 Provider。
///
/// Riverpod 语义：
/// - `keepAlive: true`：GoRouter 是应用级对象，应与 App 生命周期保持一致。
///
/// 分流规则：
/// 1. Splash 页面允许先展示启动过渡。
/// 2. 未看过 Welcome 时强制进入 Welcome。
/// 3. 已看过 Welcome 但未登录时进入 Login。
/// 4. 已登录时进入 Home，并避免停留在 Login。
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.matchedLocation;
      // 使用 matchedLocation 而不是原始 uri，可避免 query 参数影响基础路由判断。
      final onSplash = location == AppRoutes.splash;
      final onWelcome = location == AppRoutes.welcome;
      final onLogin = location == AppRoutes.login;
      final hasSeenWelcome = ref.read(appLaunchStorageProvider).hasSeenWelcome;
      final isLoggedIn = ref.read(tokenStorageProvider).hasToken;

      // Splash 自己负责延迟和首屏跳转，router 不在这里抢先改向。
      if (onSplash) return null;

      if (!hasSeenWelcome) {
        return onWelcome ? null : AppRoutes.welcome;
      }

      if (onWelcome) {
        return isLoggedIn ? AppRoutes.home : AppRoutes.login;
      }

      if (!isLoggedIn) {
        return onLogin ? null : AppRoutes.login;
      }

      if (onLogin) return AppRoutes.home;

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: AppRoutes.welcome, builder: (_, _) => const WelcomePage()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
    ],
  );
}
