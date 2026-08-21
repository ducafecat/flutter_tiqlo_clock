import 'dart:async';
import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'clock.dart';
import 'clock_engine.dart';
import 'system_clock.dart';

part 'clock_providers.g.dart';

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => SystemClock();

@Riverpod(keepAlive: true)
ClockEngine clockEngine(Ref ref) {
  return ClockEngine(
    clock: ref.watch(clockProvider),
    locale: PlatformDispatcher.instance.locale,
  );
}

@riverpod
ClockSnapshot clockSnapshot(Ref ref) {
  final engine = ref.watch(clockEngineProvider);
  final timer = Timer(engine.untilNextWallTick, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return engine.snapshot;
}
