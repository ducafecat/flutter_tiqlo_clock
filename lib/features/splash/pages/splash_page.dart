import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/app_images.dart';
import '../../../core/providers/app_launch_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_system_ui.dart';

/// 启动视觉与首次启动分流。
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key, required this.showWelcome});

  final bool showWelcome;

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    ClockSystemUi.hide();
    _continueToApp();
  }

  Future<void> _continueToApp() async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    final hasSeenWelcome =
        !widget.showWelcome ||
        ref.read(appLaunchStorageProvider).hasSeenWelcome;
    context.go(hasSeenWelcome ? AppRoutes.clock : AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0.88, end: 1),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: ((scale - 0.88) / 0.12).clamp(0, 1).toDouble(),
              child: child,
            ),
          );
        },
        child: SizedBox.expand(
          child: Image.asset(AppImages.splashPng, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
