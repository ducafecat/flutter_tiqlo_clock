import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clock/clock_providers.dart';
import 'clock/system_clock.dart';
import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/ui/app_theme.dart';
import 'core/ui/clock_full_screen.dart';
import 'core/ui/clock_system_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ClockFullScreen.ensureInitialized();
  await initializeDateFormatting();
  await ClockSystemUi.hide();
  final prefs = await SharedPreferences.getInstance();
  var bootElapsed = Duration.zero;
  try {
    final ms = await const MethodChannel(
      'tiqlo/clock',
    ).invokeMethod<int>('elapsedRealtime');
    if (ms != null) bootElapsed = Duration(milliseconds: ms);
  } catch (_) {}

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        clockProvider.overrideWithValue(SystemClock(bootElapsed: bootElapsed)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, this.showOnboarding = true});

  /// 页面级测试可关闭启动流程，直接验证时钟功能。
  final bool showOnboarding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider(showOnboarding: showOnboarding));

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
