import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_ui.dart';
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
    await tester.tap(find.bySemanticsLabel('Back'));
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
    await tester.tap(find.bySemanticsLabel('Back'));
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
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(showOnboarding: false),
      ),
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
    await tester.tap(find.bySemanticsLabel('Back'));
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
    await tester.tap(find.bySemanticsLabel('Back'));
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
    expect(find.text('Build 1'), findsOneWidget);
    expect(find.text('ducafecat'), findsOneWidget);
    expect(find.text('https://ducafecat.com'), findsOneWidget);
    expect(find.text('https://tiqlo.link'), findsOneWidget);
    expect(
      find.text('https://github.com/ducafecat/flutter_tiqlo_clock'),
      findsOneWidget,
    );
    expect(find.byType(PixelPanel), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(ClockPage), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('About uses the full landscape content width', (tester) async {
    tester.view.physicalSize = const Size(2000, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    final panel = tester.getRect(find.byType(PixelPanel).first);
    expect(panel.left, lessThan(30));
    expect(panel.right, greaterThan(1970));

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
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(showOnboarding: false),
      ),
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
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(showOnboarding: false),
      ),
    );

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    final switchFinder = find.ancestor(
      of: find.text('Keep Screen Awake'),
      matching: find.byType(PixelSwitch),
    );
    expect(switchFinder, findsOneWidget);
    expect(
      tester.getSemantics(switchFinder),
      matchesSemantics(
        label: 'Keep Screen Awake',
        hasEnabledState: true,
        isEnabled: true,
        hasCheckedState: true,
        isChecked: true,
        hasTapAction: true,
      ),
    );

    await tester.tap(find.text('Keep Screen Awake'));
    await tester.pump();
    expect(engine.keepAwake, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Settings options are arranged into semantic groups', (
    tester,
  ) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('TIME & DATE'), findsOneWidget);
    expect(find.text('DISPLAY'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('ALERTS'),
      200,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('ALERTS'), findsOneWidget);
    expect(find.byType(PixelSection), findsNWidgets(3));

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Settings tiles sections across the available landscape width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2000, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    final sections = find.byType(PixelSection);
    expect(sections, findsNWidgets(3));
    final time = tester.getTopLeft(sections.at(0));
    final display = tester.getTopLeft(sections.at(1));
    final alerts = tester.getTopLeft(sections.at(2));
    expect(time.dx, lessThan(30));
    expect(display.dx, greaterThan(time.dx));
    expect(alerts.dx, greaterThan(display.dx));

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
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(showOnboarding: false),
      ),
    );

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Sound'),
      200,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sound'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Vibration'),
      200,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vibration'));
    await tester.pump();

    expect(engine.soundEnabled, isFalse);
    expect(engine.vibrationEnabled, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Settings keeps Vibration reachable at 360dp and 2x text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(
      tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
    );
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Vibration'),
      240,
      scrollable: find.byType(Scrollable),
    );

    expect(find.text('Vibration'), findsOneWidget);
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
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(showOnboarding: false),
    ),
  );
  return container;
}
