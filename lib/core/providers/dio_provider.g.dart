// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 应用级 SharedPreferences Provider。
///
/// Riverpod 语义：
/// - `keepAlive: true`：作为基础设施依赖，生命周期跟随应用。
/// - 默认抛错：提醒调用方必须在 `runApp` 前通过 ProviderScope override 注入异步初始化结果。
///
/// ⚠️ 注意：
/// 如果忘记 override，本 Provider 被读取时会立即抛错；这能尽早暴露启动流程问题。

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// 应用级 SharedPreferences Provider。
///
/// Riverpod 语义：
/// - `keepAlive: true`：作为基础设施依赖，生命周期跟随应用。
/// - 默认抛错：提醒调用方必须在 `runApp` 前通过 ProviderScope override 注入异步初始化结果。
///
/// ⚠️ 注意：
/// 如果忘记 override，本 Provider 被读取时会立即抛错；这能尽早暴露启动流程问题。

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// 应用级 SharedPreferences Provider。
  ///
  /// Riverpod 语义：
  /// - `keepAlive: true`：作为基础设施依赖，生命周期跟随应用。
  /// - 默认抛错：提醒调用方必须在 `runApp` 前通过 ProviderScope override 注入异步初始化结果。
  ///
  /// ⚠️ 注意：
  /// 如果忘记 override，本 Provider 被读取时会立即抛错；这能尽早暴露启动流程问题。
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'386519e62271b10ae7f628d13ea90b85216f025f';

/// TokenStorage Provider。
///
/// 职责：
/// - 封装 access/refresh token 的本地读写。
/// - 给路由守卫和网络拦截器提供同一份登录态来源。

@ProviderFor(tokenStorage)
final tokenStorageProvider = TokenStorageProvider._();

/// TokenStorage Provider。
///
/// 职责：
/// - 封装 access/refresh token 的本地读写。
/// - 给路由守卫和网络拦截器提供同一份登录态来源。

final class TokenStorageProvider
    extends $FunctionalProvider<TokenStorage, TokenStorage, TokenStorage>
    with $Provider<TokenStorage> {
  /// TokenStorage Provider。
  ///
  /// 职责：
  /// - 封装 access/refresh token 的本地读写。
  /// - 给路由守卫和网络拦截器提供同一份登录态来源。
  TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $ProviderElement<TokenStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStorage create(Ref ref) {
    return tokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorage>(value),
    );
  }
}

String _$tokenStorageHash() => r'daf96a8f4aa27c29148ae46c8ade53a55656d7db';

/// 首次启动状态 Provider。
///
/// Welcome/Splash/Router 都通过它判断是否需要展示引导页。

@ProviderFor(appLaunchStorage)
final appLaunchStorageProvider = AppLaunchStorageProvider._();

/// 首次启动状态 Provider。
///
/// Welcome/Splash/Router 都通过它判断是否需要展示引导页。

final class AppLaunchStorageProvider
    extends
        $FunctionalProvider<
          AppLaunchStorage,
          AppLaunchStorage,
          AppLaunchStorage
        >
    with $Provider<AppLaunchStorage> {
  /// 首次启动状态 Provider。
  ///
  /// Welcome/Splash/Router 都通过它判断是否需要展示引导页。
  AppLaunchStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLaunchStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLaunchStorageHash();

  @$internal
  @override
  $ProviderElement<AppLaunchStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLaunchStorage create(Ref ref) {
    return appLaunchStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLaunchStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLaunchStorage>(value),
    );
  }
}

String _$appLaunchStorageHash() => r'f177522f30e3824d1f8c5795c75a3c5afc2f397c';

/// 全局 Dio Provider。
///
/// 职责：
/// - 创建统一配置的 HTTP 客户端。
/// - 复用同一套鉴权、日志与错误转换拦截器。
///
/// 扩展方式：
/// 需要统一处理 401 跳登录时，可向 `DioClient.create` 传入 `onUnauthorized` 回调。

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// 全局 Dio Provider。
///
/// 职责：
/// - 创建统一配置的 HTTP 客户端。
/// - 复用同一套鉴权、日志与错误转换拦截器。
///
/// 扩展方式：
/// 需要统一处理 401 跳登录时，可向 `DioClient.create` 传入 `onUnauthorized` 回调。

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// 全局 Dio Provider。
  ///
  /// 职责：
  /// - 创建统一配置的 HTTP 客户端。
  /// - 复用同一套鉴权、日志与错误转换拦截器。
  ///
  /// 扩展方式：
  /// 需要统一处理 401 跳登录时，可向 `DioClient.create` 传入 `onUnauthorized` 回调。
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'60a274b53845ddcf916e1aa31d796294eaeea7b2';
