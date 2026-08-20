import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_config.dart';
import 'core/providers/dio_provider.dart';
import 'core/router/app_router.dart';
import 'core/ui/app_theme.dart';

/// 应用入口。
///
/// 启动流程：
/// 1. 绑定 Flutter 引擎，确保插件和 SystemChrome 可用。
/// 2. 初始化本地存储与主题模式。
/// 3. 用 ProviderContainer 注入异步依赖。
/// 4. 交给 UncontrolledProviderScope 承载整个应用。
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // SharedPreferences 与 AdaptiveTheme 都是异步依赖，提前初始化可让 Provider 保持同步读取。
  final prefs = await SharedPreferences.getInstance();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  // 使用 ProviderContainer 是为了把启动期拿到的 prefs override 到 Riverpod 依赖图里。
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

/// 根组件。
///
/// 职责：
/// - 监听 appRouterProvider 获取全局路由。
/// - 配置亮暗主题与 MaterialApp.router。
class MyApp extends ConsumerWidget {
  const MyApp({super.key, this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) {
        return MaterialApp.router(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          routerConfig: router,
        );
      },
    );
  }
}
