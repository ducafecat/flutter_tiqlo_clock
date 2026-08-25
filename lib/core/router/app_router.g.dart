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
    required ({bool showOnboarding, bool showWelcome}) super.argument,
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
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    final argument = this.argument as ({bool showOnboarding, bool showWelcome});
    return appRouter(
      ref,
      showOnboarding: argument.showOnboarding,
      showWelcome: argument.showWelcome,
    );
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

String _$appRouterHash() => r'a21d6ca71a6fe434627a4718ce20e58bcc67f85c';

final class AppRouterFamily extends $Family
    with
        $FunctionalFamilyOverride<
          GoRouter,
          ({bool showOnboarding, bool showWelcome})
        > {
  AppRouterFamily._()
    : super(
        retry: null,
        name: r'appRouterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  AppRouterProvider call({
    bool showOnboarding = true,
    bool showWelcome = true,
  }) => AppRouterProvider._(
    argument: (showOnboarding: showOnboarding, showWelcome: showWelcome),
    from: this,
  );

  @override
  String toString() => r'appRouterProvider';
}
