import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/dio_provider.dart';
import '../../../core/router/app_router.dart';

/// 欢迎页。
///
/// 职责：
/// - 作为首次启动引导占位页面。
/// - 用户点击开始后标记 Welcome 已完成，再进入登录流程。
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: FilledButton(
          onPressed: () async {
            await ref.read(appLaunchStorageProvider).markWelcomeSeen();
            // 异步写入后再导航，确保下一次启动不会重复进入 Welcome。
            if (context.mounted) context.go(AppRoutes.login);
          },
          child: const Text('Get started'),
        ),
      ),
    );
  }
}
