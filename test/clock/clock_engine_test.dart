import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_settings_store.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'fake_clock.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('zh');
  });

  test('snapshot shows frozen wall hour and minute', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    expect(engine.snapshot.hour, 21);
    expect(engine.snapshot.minute, 38);
    expect(engine.snapshot.timeLabel, '21:38');
    expect(engine.snapshot.showDate, isFalse);
  });

  test('snapshot date is weekday · month day in English', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, locale: const Locale('en'));

    expect(engine.snapshot.dateLabel, 'THU · AUG 20');
  });

  test('snapshot date is weekday · month day in Chinese', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, locale: const Locale('zh'));

    expect(engine.snapshot.dateLabel, '周四 · 8月20日');
  });

  test('advancing wall now updates snapshot hour and minute', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    clock.advanceWall(const Duration(minutes: 2));

    expect(engine.snapshot.hour, 21);
    expect(engine.snapshot.minute, 40);
  });

  test('untilNextWallTick is the remainder of the current minute', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38, 20));
    final engine = ClockEngine(clock: clock);

    expect(engine.untilNextWallTick, const Duration(seconds: 40));
  });

  test('12-hour snapshot timeLabel includes AM/PM', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, deviceUses24Hour: false);

    expect(engine.snapshot.timeLabel, '09:38 PM');
    expect(engine.snapshot.period, 'PM');
  });

  test('24-hour snapshot timeLabel has no AM/PM', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, deviceUses24Hour: true);

    expect(engine.snapshot.timeLabel, '21:38');
    expect(engine.snapshot.period, isNull);
  });

  test('midnight in 12-hour format is 12:00 AM', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 0, 0));
    final engine = ClockEngine(clock: clock, deviceUses24Hour: false);

    expect(engine.snapshot.timeLabel, '12:00 AM');
  });

  test('showSeconds includes seconds and ticks to the next second', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38, 20));
    final engine = ClockEngine(clock: clock, showSeconds: true);

    expect(engine.snapshot.timeLabel, '21:38:20');
    expect(engine.untilNextWallTick, const Duration(seconds: 1));
  });

  test('setTimeFormat overrides device 24-hour default', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, deviceUses24Hour: true);

    engine.setTimeFormat(TimeFormat.h12);

    expect(engine.snapshot.timeLabel, '09:38 PM');
  });

  test('reloading engine from store keeps format and seconds', () {
    final store = MemoryClockSettingsStore();
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(
      clock: clock,
      store: store,
      deviceUses24Hour: true,
    );
    engine.setTimeFormat(TimeFormat.h12);
    engine.setShowSeconds(true);
    engine.setShowDate(true);

    final reloaded = ClockEngine(
      clock: clock,
      store: store,
      deviceUses24Hour: true,
    );

    expect(reloaded.snapshot.timeLabel, '09:38:00 PM');
    expect(reloaded.showSeconds, isTrue);
    expect(reloaded.showDate, isTrue);
    expect(reloaded.snapshot.showDate, isTrue);
  });

  test('clock theme defaults to Minimal and persists across reload', () {
    final store = MemoryClockSettingsStore();
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, store: store);

    expect(engine.clockThemeId, ClockThemeId.minimal);

    engine.setClockTheme(ClockThemeId.flip);

    final reloaded = ClockEngine(clock: clock, store: store);
    expect(reloaded.clockThemeId, ClockThemeId.flip);
  });

  test('start focus replaces wall display with remaining mm:ss', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, showSeconds: false);

    engine.start(SessionKind.focus, const Duration(minutes: 25));

    final session = engine.snapshot.session;
    expect(session, isNotNull);
    expect(session!.kind, SessionKind.focus);
    expect(session.status, SessionStatus.running);
    expect(session.remainingLabel, '25:00');
    expect(engine.snapshot.timeLabel, '21:38');
  });

  test('advancing elapsed reduces remaining; advancing wall does not', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceWall(const Duration(minutes: 10));
    expect(engine.snapshot.session!.remainingLabel, '25:00');

    clock.advanceElapsed(const Duration(minutes: 3, seconds: 5));
    expect(engine.snapshot.session!.remainingLabel, '21:55');
  });

  test('pause freezes remaining; resume continues the same session', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 5));
    engine.pause();
    clock.advanceElapsed(const Duration(minutes: 10));

    expect(engine.snapshot.session!.status, SessionStatus.paused);
    expect(engine.snapshot.session!.remainingLabel, '20:00');

    engine.resume();
    clock.advanceElapsed(const Duration(minutes: 2));

    expect(engine.snapshot.session!.status, SessionStatus.running);
    expect(engine.snapshot.session!.kind, SessionKind.focus);
    expect(engine.snapshot.session!.remainingLabel, '18:00');
  });

  test('stop returns to wall time without a session', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 5));
    engine.stop();

    expect(engine.snapshot.session, isNull);
    expect(engine.snapshot.timeLabel, '21:38');
  });

  test('cannot start a second session while one is active', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 5));
    engine.start(SessionKind.focus, const Duration(minutes: 15));
    engine.start(SessionKind.timer, const Duration(minutes: 1));

    expect(engine.snapshot.session!.kind, SessionKind.focus);
    expect(engine.snapshot.session!.remainingLabel, '20:00');
  });

  test('same-boot reload restores running session from elapsed', () {
    final store = MemoryClockSettingsStore();
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, store: store);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 7, seconds: 30));

    final reloaded = ClockEngine(clock: clock, store: store);
    expect(reloaded.snapshot.session!.kind, SessionKind.focus);
    expect(reloaded.snapshot.session!.status, SessionStatus.running);
    expect(reloaded.snapshot.session!.remainingLabel, '17:30');
  });

  test('same-boot reload keeps paused remaining frozen', () {
    final store = MemoryClockSettingsStore();
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, store: store);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 4));
    engine.pause();
    clock.advanceElapsed(const Duration(minutes: 20));

    final reloaded = ClockEngine(clock: clock, store: store);
    expect(reloaded.snapshot.session!.status, SessionStatus.paused);
    expect(reloaded.snapshot.session!.remainingLabel, '21:00');
  });

  test('running session ticks every second even when showSeconds is off', () {
    final clock = FakeClock(
      wall: DateTime(2026, 8, 20, 21, 38, 20),
      monotonic: const Duration(milliseconds: 250),
    );
    final engine = ClockEngine(clock: clock);

    expect(engine.untilNextWallTick, const Duration(seconds: 40));

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    expect(engine.untilNextWallTick, const Duration(milliseconds: 750));
  });

  test('elapsed to duration enters Complete', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 25));

    expect(engine.snapshot.session!.status, SessionStatus.complete);
    expect(engine.snapshot.session!.remainingLabel, '00:00');
  });

  test('acknowledgeComplete returns to wall time', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 25));
    engine.snapshot;
    engine.acknowledgeComplete();

    expect(engine.snapshot.session, isNull);
    expect(engine.snapshot.timeLabel, '21:38');
  });

  test('focus Complete records today; Stop does not', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 25));
    expect(engine.snapshot.todayFocusCount, 1);
    expect(engine.snapshot.todayFocusMinutes, 25);

    engine.acknowledgeComplete();
    engine.start(SessionKind.focus, const Duration(minutes: 15));
    engine.stop();
    expect(engine.snapshot.todayFocusCount, 1);
    expect(engine.snapshot.todayFocusMinutes, 25);
  });

  test('pause and resume still record one Complete', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 10));
    engine.pause();
    engine.resume();
    clock.advanceElapsed(const Duration(minutes: 15));

    expect(engine.snapshot.session!.status, SessionStatus.complete);
    expect(engine.snapshot.todayFocusCount, 1);
    expect(engine.snapshot.todayFocusMinutes, 25);
  });

  test('today resets after local midnight', () {
    final store = MemoryClockSettingsStore();
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, store: store);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 25));
    expect(engine.snapshot.todayFocusCount, 1);

    clock.advanceWall(const Duration(hours: 3));
    expect(engine.snapshot.todayFocusCount, 0);
    expect(engine.snapshot.todayFocusMinutes, 0);

    final reloaded = ClockEngine(clock: clock, store: store);
    expect(reloaded.snapshot.todayFocusCount, 0);
  });

  test('timer Complete does not record today Focus', () {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock);

    engine.start(SessionKind.timer, const Duration(minutes: 5));
    clock.advanceElapsed(const Duration(minutes: 5));

    expect(engine.snapshot.session!.status, SessionStatus.complete);
    expect(engine.snapshot.todayFocusCount, 0);
    expect(engine.snapshot.todayFocusMinutes, 0);
  });

  test('sound and vibration default on and persist', () {
    final store = MemoryClockSettingsStore();
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, store: store);

    expect(engine.soundEnabled, isTrue);
    expect(engine.vibrationEnabled, isTrue);

    engine.setSoundEnabled(false);
    engine.setVibrationEnabled(false);

    final reloaded = ClockEngine(clock: clock, store: store);
    expect(reloaded.soundEnabled, isFalse);
    expect(reloaded.vibrationEnabled, isFalse);
  });

  test('reloading a completed focus does not double-count today', () {
    final store = MemoryClockSettingsStore();
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, store: store);

    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 25));
    expect(engine.snapshot.todayFocusCount, 1);

    final reloaded = ClockEngine(clock: clock, store: store);
    expect(reloaded.snapshot.session!.status, SessionStatus.complete);
    expect(reloaded.snapshot.todayFocusCount, 1);
  });
}
