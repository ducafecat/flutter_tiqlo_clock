import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/session_alerts.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/clock_wake.dart';

abstract interface class ClockPlatformEffects {
  Future<void> hideSystemUi();
  Future<void> setWakeEnabled(bool enabled);
  Future<void> setNightBrightnessEnabled(bool enabled);
  Future<void> playAlert();
  Future<void> vibrate();
}

class SystemClockPlatformEffects implements ClockPlatformEffects {
  const SystemClockPlatformEffects();

  @override
  Future<void> hideSystemUi() => ClockSystemUi.hide();

  @override
  Future<void> setWakeEnabled(bool enabled) => ClockWake.setEnabled(enabled);

  @override
  Future<void> setNightBrightnessEnabled(bool enabled) {
    return NightBrightness.setEnabled(enabled);
  }

  @override
  Future<void> playAlert() => SystemSound.play(SystemSoundType.alert);

  @override
  Future<void> vibrate() => HapticFeedback.vibrate();
}

class ClockPlatformCoordinator with WidgetsBindingObserver {
  ClockPlatformCoordinator({
    required this.readEngine,
    required this.readAlerts,
    required this.refreshSnapshot,
    this.effects = const SystemClockPlatformEffects(),
  });

  final ClockEngine Function() readEngine;
  final SessionAlerts Function() readAlerts;
  final VoidCallback refreshSnapshot;
  final ClockPlatformEffects effects;
  var _started = false;

  void start() {
    if (_started) return;
    _started = true;
    unawaited(effects.hideSystemUi());
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_started) _syncPlatformState(cancelInactiveAlert: true);
    });
  }

  void dispose() {
    if (!_started) return;
    _started = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final engine = readEngine();
    final alerts = readAlerts();
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      final session = engine.snapshot.session;
      if (session != null && session.status == SessionStatus.running) {
        unawaited(alerts.schedule(session.remaining, session.kind));
      }
      return;
    }
    if (state == AppLifecycleState.resumed) {
      final session = engine.snapshot.session;
      if (session != null && session.status != SessionStatus.complete) {
        unawaited(alerts.cancel());
      }
      _syncPlatformState();
      refreshSnapshot();
    }
  }

  void handleSnapshotChange(ClockSnapshot? previous, ClockSnapshot next) {
    if (previous?.nightMode != next.nightMode) {
      unawaited(effects.setNightBrightnessEnabled(next.nightMode));
    }
    if (next.session?.status == SessionStatus.complete &&
        previous?.session?.status != SessionStatus.complete) {
      final engine = readEngine();
      if (engine.soundEnabled) unawaited(effects.playAlert());
      if (engine.vibrationEnabled) unawaited(effects.vibrate());
    }
  }

  void _syncPlatformState({bool cancelInactiveAlert = false}) {
    final engine = readEngine();
    if (cancelInactiveAlert) {
      final session = engine.snapshot.session;
      if (session == null || session.status != SessionStatus.running) {
        unawaited(readAlerts().cancel());
      }
    }
    unawaited(effects.setWakeEnabled(engine.keepAwake));
    unawaited(effects.setNightBrightnessEnabled(engine.nightMode));
  }
}
