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

    final reloaded = ClockEngine(
      clock: clock,
      store: store,
      deviceUses24Hour: true,
    );

    expect(reloaded.snapshot.timeLabel, '09:38:00 PM');
    expect(reloaded.showSeconds, isTrue);
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
}
