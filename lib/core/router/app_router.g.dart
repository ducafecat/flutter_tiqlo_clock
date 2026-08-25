// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appRouter)
final appRouterProvider = AppRouterFamily._();

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  AppRouterProvider._({
    required AppRouterFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'appRouterProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @override
  String toString() {
    return r'appRouterProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    final argument = this.argument as bool;
    return appRouter(ref, showOnboarding: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppRouterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appRouterHash() => r'd582fb1a0d9980e46c027f2fe3de7c78238c812d';

final class AppRouterFamily extends $Family
    with $FunctionalFamilyOverride<GoRouter, bool> {
  AppRouterFamily._()
    : super(
        retry: null,
        name: r'appRouterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  AppRouterProvider call({bool showOnboarding = true}) =>
      AppRouterProvider._(argument: showOnboarding, from: this);

  @override
  String toString() => r'appRouterProvider';
}
