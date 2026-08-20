// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 应用路由 Provider。
///
/// Riverpod 语义：
/// - `keepAlive: true`：GoRouter 是应用级对象，应与 App 生命周期保持一致。
///
/// 分流规则：
/// 1. Splash 页面允许先展示启动过渡。
/// 2. 未看过 Welcome 时强制进入 Welcome。
/// 3. 已看过 Welcome 但未登录时进入 Login。
/// 4. 已登录时进入 Home，并避免停留在 Login。

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// 应用路由 Provider。
///
/// Riverpod 语义：
/// - `keepAlive: true`：GoRouter 是应用级对象，应与 App 生命周期保持一致。
///
/// 分流规则：
/// 1. Splash 页面允许先展示启动过渡。
/// 2. 未看过 Welcome 时强制进入 Welcome。
/// 3. 已看过 Welcome 但未登录时进入 Login。
/// 4. 已登录时进入 Home，并避免停留在 Login。

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// 应用路由 Provider。
  ///
  /// Riverpod 语义：
  /// - `keepAlive: true`：GoRouter 是应用级对象，应与 App 生命周期保持一致。
  ///
  /// 分流规则：
  /// 1. Splash 页面允许先展示启动过渡。
  /// 2. 未看过 Welcome 时强制进入 Welcome。
  /// 3. 已看过 Welcome 但未登录时进入 Login。
  /// 4. 已登录时进入 Home，并避免停留在 Login。
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'8c500bec58fb264d5b20c2cd53992e528d879204';
