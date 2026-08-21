import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
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
}
