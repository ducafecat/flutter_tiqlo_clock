// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$clockEngineHash() => r'97c8dd74d6f990f0eaa015673607bbab09628326';

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
