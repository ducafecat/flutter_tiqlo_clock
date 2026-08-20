import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../storage/app_launch_storage.dart';
import '../storage/token_storage.dart';

part 'dio_provider.g.dart';

/// 应用级 SharedPreferences Provider。
///
/// Riverpod 语义：
/// - `keepAlive: true`：作为基础设施依赖，生命周期跟随应用。
/// - 默认抛错：提醒调用方必须在 `runApp` 前通过 ProviderScope override 注入异步初始化结果。
///
/// ⚠️ 注意：
/// 如果忘记 override，本 Provider 被读取时会立即抛错；这能尽早暴露启动流程问题。
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden before runApp.',
  );
}

/// TokenStorage Provider。
///
/// 职责：
/// - 封装 access/refresh token 的本地读写。
/// - 给路由守卫和网络拦截器提供同一份登录态来源。
@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage(ref.watch(sharedPreferencesProvider));
}

/// 首次启动状态 Provider。
///
/// Welcome/Splash/Router 都通过它判断是否需要展示引导页。
@Riverpod(keepAlive: true)
AppLaunchStorage appLaunchStorage(Ref ref) {
  return AppLaunchStorage(ref.watch(sharedPreferencesProvider));
}

/// 全局 Dio Provider。
///
/// 职责：
/// - 创建统一配置的 HTTP 客户端。
/// - 复用同一套鉴权、日志与错误转换拦截器。
///
/// 扩展方式：
/// 需要统一处理 401 跳登录时，可向 `DioClient.create` 传入 `onUnauthorized` 回调。
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return DioClient.create(tokenStorage: ref.watch(tokenStorageProvider));
}
