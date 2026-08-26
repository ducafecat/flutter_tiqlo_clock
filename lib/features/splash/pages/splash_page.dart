import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/app_images.dart';
import '../../../core/providers/app_launch_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/pixel/pixel_tokens.dart';

/// 启动视觉与首次启动分流。
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key, required this.showWelcome});

  final bool showWelcome;

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  var _navigationStarted = false;

  @override
  void initState() {
    super.initState();
    ClockSystemUi.hide();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_navigationStarted) return;
    _navigationStarted = true;
    final tokens = PixelTokens.of(context);
    _continueToApp(tokens.motionDuration(context, tokens.splashDuration));
  }

  Future<void> _continueToApp(Duration duration) async {
    await Future<void>.delayed(duration);
    if (!mounted) return;

    final hasSeenWelcome =
        !widget.showWelcome ||
        ref.read(appLaunchStorageProvider).hasSeenWelcome;
    context.go(hasSeenWelcome ? AppRoutes.clock : AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final duration = tokens.motionDuration(context, tokens.splashDuration);
    final splash = SizedBox.expand(
      child: Image.asset(AppImages.splashPng, fit: BoxFit.cover),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: duration == Duration.zero
          ? splash
          : TweenAnimationBuilder<double>(
              duration: duration,
              tween: Tween(begin: 0, end: 1),
              builder: (context, opacity, child) =>
                  Opacity(opacity: opacity, child: child),
              child: splash,
            ),
    );
  }
}
