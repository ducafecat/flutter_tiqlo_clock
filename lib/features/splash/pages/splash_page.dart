import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/dio_provider.dart';
import '../../../core/router/app_router.dart';

/// 启动页。
///
/// 职责：
/// - 展示短暂启动过渡。
/// - 读取本地启动状态与登录态，决定首屏去向。
///
/// 为什么使用 ConsumerStatefulWidget：
/// `_start` 需要在 initState 触发一次异步流程，同时又要读取 Riverpod Provider。
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    // 启动分流只执行一次，不放进 build，避免重建时重复导航。
    _start();
  }

  /// 启动分流流程：
  /// 1. 等待极短时间，让首帧和启动动画有机会展示。
  /// 2. 读取 Welcome 与 Token 状态。
  /// 3. 按 Welcome → Home/Login 的优先级跳转。
  Future<void> _start() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    // 异步等待后 Widget 可能已经销毁，导航前必须检查 mounted。
    if (!mounted) return;

    final hasSeenWelcome = ref.read(appLaunchStorageProvider).hasSeenWelcome;
    final hasToken = ref.read(tokenStorageProvider).hasToken;

    if (!hasSeenWelcome) {
      context.go(AppRoutes.welcome);
    } else if (hasToken) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
