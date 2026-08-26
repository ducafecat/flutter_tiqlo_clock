import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/session_alerts.dart';
import 'package:flutter_tiqlo_clock/features/clock/services/clock_platform_coordinator.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => initializeDateFormatting('en'));

  test('coordinates lifecycle notifications and platform display effects', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(
      clock: clock,
      keepAwake: true,
      nightMode: true,
      soundEnabled: true,
      vibrationEnabled: true,
    );
    final alerts = _RecordingAlerts();
    final effects = _RecordingEffects();
    var refreshes = 0;
    final coordinator = ClockPlatformCoordinator(
      readEngine: () => engine,
      readAlerts: () => alerts,
      refreshSnapshot: () => refreshes++,
      effects: effects,
    );

    engine.start(SessionKind.timer, const Duration(minutes: 5));
    coordinator.didChangeAppLifecycleState(AppLifecycleState.paused);
    expect(alerts.scheduledRemaining, const Duration(minutes: 5));
    expect(alerts.scheduledKind, SessionKind.timer);

    coordinator.didChangeAppLifecycleState(AppLifecycleState.resumed);
    expect(alerts.cancelCount, 1);
    expect(effects.wakeValues, [true]);
    expect(effects.nightValues, [true]);
    expect(refreshes, 1);

    final previous = engine.snapshot;
    clock.advanceElapsed(const Duration(minutes: 5));
    final next = engine.snapshot;
    coordinator.handleSnapshotChange(previous, next);
    expect(effects.alertCount, 1);
    expect(effects.vibrationCount, 1);
  });
}

class _RecordingAlerts implements SessionAlerts {
  Duration? scheduledRemaining;
  SessionKind? scheduledKind;
  var cancelCount = 0;

  @override
  Future<void> cancel() async {
    cancelCount++;
  }

  @override
  Future<void> requestPermissionOnFirstStart() async {}

  @override
  Future<void> schedule(Duration remaining, SessionKind kind) async {
    scheduledRemaining = remaining;
    scheduledKind = kind;
  }
}

class _RecordingEffects implements ClockPlatformEffects {
  final wakeValues = <bool>[];
  final nightValues = <bool>[];
  var alertCount = 0;
  var vibrationCount = 0;

  @override
  Future<void> hideSystemUi() async {}

  @override
  Future<void> playAlert() async {
    alertCount++;
  }

  @override
  Future<void> setNightBrightnessEnabled(bool enabled) async {
    nightValues.add(enabled);
  }

  @override
  Future<void> setWakeEnabled(bool enabled) async {
    wakeValues.add(enabled);
  }

  @override
  Future<void> vibrate() async {
    vibrationCount++;
  }
}
