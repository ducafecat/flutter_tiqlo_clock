import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  testWidgets('turning off 24 Hour shows AM/PM on Clock', (tester) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('24 Hour'));
    await tester.pump();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(container.read(clockEngineProvider).snapshot.timeLabel, '09:38 PM');

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Show Seconds adds seconds on Clock', (tester) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show Seconds'));
    await tester.pump();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(container.read(clockEngineProvider).snapshot.timeLabel, '21:38:00');

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Show Leading Zero controls the Flip display in 24-hour time', (
    tester,
  ) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 9, 38)),
      locale: const Locale('en'),
      deviceUses24Hour: true,
    );
    engine.setClockTheme(ClockThemeId.flip);
    final container = ProviderContainer(
      overrides: [clockEngineProvider.overrideWithValue(engine)],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );

    expect(find.text('9'), findsNWidgets(2));

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show Leading Zero'));
    await tester.pump();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(engine.showLeadingZero, isTrue);
    expect(find.text('09'), findsNWidgets(2));

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Date & Weekday shows weekday and date on Clock', (tester) async {
    final container = await _pumpClock(tester);

    expect(find.text('THU · AUG 20'), findsNothing);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Date & Weekday'));
    await tester.pump();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('THU · AUG 20'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('About shows version', (tester) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('Version 1.0.0'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Night Mode from More hides date and keeps ClockTheme', (
    tester,
  ) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    engine.setShowDate(true);
    engine.setClockTheme(ClockThemeId.flip);
    engine.setDigitalTheme(DigitalThemeId.digitalBlue);
    engine.setFlipPalette(FlipPaletteId.orange);
    final container = ProviderContainer(
      overrides: [clockEngineProvider.overrideWithValue(engine)],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );

    expect(find.text('THU · AUG 20'), findsOneWidget);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Night Mode'));
    await tester.pumpAndSettle();

    expect(engine.nightMode, isTrue);
    expect(engine.clockThemeId, ClockThemeId.flip);
    expect(engine.digitalThemeId, DigitalThemeId.digitalBlue);
    expect(engine.flipPaletteId, FlipPaletteId.orange);
    expect(find.text('THU · AUG 20'), findsNothing);
    expect(find.byType(ClockPage), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Settings Keep Screen Awake defaults on and can turn off', (
    tester,
  ) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    final container = ProviderContainer(
      overrides: [clockEngineProvider.overrideWithValue(engine)],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    final tile = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, 'Keep Screen Awake'),
    );
    expect(tile.value, isTrue);

    await tester.tap(find.text('Keep Screen Awake'));
    await tester.pump();
    expect(engine.keepAwake, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Settings can turn off Sound and Vibration', (tester) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    final container = ProviderContainer(
      overrides: [clockEngineProvider.overrideWithValue(engine)],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sound'));
    await tester.pump();
    await tester.tap(find.text('Vibration'));
    await tester.pump();

    expect(engine.soundEnabled, isFalse);
    expect(engine.vibrationEnabled, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}

Future<ProviderContainer> _pumpClock(WidgetTester tester) async {
  final engine = ClockEngine(
    clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
    locale: const Locale('en'),
  );
  final container = ProviderContainer(
    overrides: [clockEngineProvider.overrideWithValue(engine)],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const MyApp()),
  );
  return container;
}
