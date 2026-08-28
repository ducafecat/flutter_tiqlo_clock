import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clock/clock_providers.dart';
import 'clock/system_clock.dart';
import 'core/config/app_config.dart';
import 'core/providers/app_appearance_provider.dart';
import 'core/router/app_router.dart';
import 'core/ui/clock_full_screen.dart';
import 'core/ui/clock_system_ui.dart';
import 'core/ui/ui.dart';

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
  const MyApp({super.key, this.showOnboarding, this.showWelcome});

  /// 默认为仅在 iOS、Android 显示 Splash，测试可显式覆盖。
  final bool? showOnboarding;

  /// 默认为仅在 iOS、Android 显示，测试可显式覆盖。
  final bool? showWelcome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    final onboardingEnabled = showOnboarding ?? isMobile;
    final welcomeEnabled = showWelcome ?? isMobile;
    final router = ref.watch(
      appRouterProvider(
        showOnboarding: onboardingEnabled,
        showWelcome: welcomeEnabled,
      ),
    );
    final uiStyle = ref.watch(appUiStyleProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: switch (uiStyle) {
        AppUiStyle.pixel => PixelTheme.darkTheme,
        AppUiStyle.standard => StandardTheme.darkTheme,
      },
      builder: (context, child) =>
          AppUiScope(style: uiStyle, child: child ?? const SizedBox.shrink()),
      routerConfig: router,
    );
  }
}
