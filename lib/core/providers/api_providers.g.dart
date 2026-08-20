// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ApiClient Provider。
///
/// feature 层可 `ref.watch(apiClientProvider)` 复用全局 Dio 配置。

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

/// ApiClient Provider。
///
/// feature 层可 `ref.watch(apiClientProvider)` 复用全局 Dio 配置。

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  /// ApiClient Provider。
  ///
  /// feature 层可 `ref.watch(apiClientProvider)` 复用全局 Dio 配置。
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'a3597fcc7ac8dab57ea70e7625b549e06e8c4fbb';
