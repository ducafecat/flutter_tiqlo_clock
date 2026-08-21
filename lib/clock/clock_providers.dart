import 'dart:async';
import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clock.dart';
import 'clock_engine.dart';
import 'clock_settings_store.dart';
import 'prefs_clock_settings_store.dart';
import 'system_clock.dart';

part 'clock_providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden before runApp.',
  );
}

@Riverpod(keepAlive: true)
ClockSettingsStore clockSettingsStore(Ref ref) {
  return PrefsClockSettingsStore(ref.watch(sharedPreferencesProvider));
}

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => SystemClock();

@Riverpod(keepAlive: true)
ClockEngine clockEngine(Ref ref) {
  return ClockEngine(
    clock: ref.watch(clockProvider),
    locale: PlatformDispatcher.instance.locale,
    store: ref.watch(clockSettingsStoreProvider),
    deviceUses24Hour: PlatformDispatcher.instance.alwaysUse24HourFormat,
  );
}

@riverpod
ClockSnapshot clockSnapshot(Ref ref) {
  final engine = ref.watch(clockEngineProvider);
  final timer = Timer(engine.untilNextWallTick, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return engine.snapshot;
}
