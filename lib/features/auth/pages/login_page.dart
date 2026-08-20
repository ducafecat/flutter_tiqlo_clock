import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/dio_provider.dart';
import '../../../core/router/app_router.dart';

/// 登录页。
///
/// 职责：
/// - 提供最小可运行的 mock 登录入口。
/// - 演示如何通过 TokenStorage 写入登录态并进入首页。
///
/// ⚠️ 注意：
/// 真实项目应在这里调用 Auth API，并把服务端返回的 token 写入 TokenStorage。
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: FilledButton(
          onPressed: () async {
            await ref
                .read(tokenStorageProvider)
                .save(
                  accessToken: 'dev-access-token',
                  refreshToken: 'dev-refresh-token',
                );
            if (context.mounted) context.go(AppRoutes.home);
          },
          child: const Text('Mock login'),
        ),
      ),
    );
  }
}
