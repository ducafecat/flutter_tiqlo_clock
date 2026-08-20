import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/dio_provider.dart';
import '../../../core/router/app_router.dart';

/// 首页。
///
/// 职责：
/// - 证明脚手架已经完成主题、路由、Provider 和本地登录态串联。
/// - 提供主题切换与退出登录两个基础动作。
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () {
              // AdaptiveTheme 会持久化用户选择，下次启动由 main.dart 读取。
              AdaptiveTheme.of(context).toggleThemeMode();
            },
            icon: const Icon(Icons.brightness_6_outlined),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(tokenStorageProvider).clear();
              // 清掉 token 后主动跳登录；router 也会在后续守卫中保持一致。
              if (context.mounted) context.go(AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('Flutter Riverpod scaffold is running.')),
    );
  }
}
