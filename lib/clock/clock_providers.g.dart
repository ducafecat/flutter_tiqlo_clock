// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
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

@ProviderFor(clockSettingsStore)
final clockSettingsStoreProvider = ClockSettingsStoreProvider._();

final class ClockSettingsStoreProvider
    extends
        $FunctionalProvider<
          ClockSettingsStore,
          ClockSettingsStore,
          ClockSettingsStore
        >
    with $Provider<ClockSettingsStore> {
  ClockSettingsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockSettingsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockSettingsStoreHash();

  @$internal
  @override
  $ProviderElement<ClockSettingsStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClockSettingsStore create(Ref ref) {
    return clockSettingsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClockSettingsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClockSettingsStore>(value),
    );
  }
}

String _$clockSettingsStoreHash() =>
    r'0e278d923e2a7b76ccaf712beb856df48a311391';

@ProviderFor(clock)
final clockProvider = ClockProvider._();

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock>
    with $Provider<Clock> {
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Clock>(value),
    );
  }
}

String _$clockHash() => r'01239bba24bc35c9a69c1d3731035405a5d15d0e';

@ProviderFor(clockEngine)
final clockEngineProvider = ClockEngineProvider._();

final class ClockEngineProvider
    extends $FunctionalProvider<ClockEngine, ClockEngine, ClockEngine>
    with $Provider<ClockEngine> {
  ClockEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockEngineHash();

  @$internal
  @override
  $ProviderElement<ClockEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClockEngine create(Ref ref) {
    return clockEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClockEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClockEngine>(value),
    );
  }
}

String _$clockEngineHash() => r'eefdad16da5c94ee257256f580f7ab067274f17d';

@ProviderFor(clockSnapshot)
final clockSnapshotProvider = ClockSnapshotProvider._();

final class ClockSnapshotProvider
    extends $FunctionalProvider<ClockSnapshot, ClockSnapshot, ClockSnapshot>
    with $Provider<ClockSnapshot> {
  ClockSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockSnapshotHash();

  @$internal
  @override
  $ProviderElement<ClockSnapshot> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClockSnapshot create(Ref ref) {
    return clockSnapshot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClockSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClockSnapshot>(value),
    );
  }
}

String _$clockSnapshotHash() => r'b8f21800222b1681d41a6dcfb1ea0c32016c2e6a';
