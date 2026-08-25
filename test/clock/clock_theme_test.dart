import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/clock/prefs_clock_settings_store.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/flip_clock_face.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
    final flipFont = FontLoader('FlipClock')
      ..addFont(rootBundle.load('fonts/RobotoCondensed-Bold.ttf'));
    await flipFont.load();
  });

  test(
    'Clock style defaults to Flip and keeps a saved Digital choice',
    () async {
      SharedPreferences.setMockInitialValues({});
      var prefs = await SharedPreferences.getInstance();
      var store = PrefsClockSettingsStore(prefs);
      expect(store.loadClockThemeId(), ClockThemeId.flip);

      SharedPreferences.setMockInitialValues({'clock.theme_id': 'digital'});
      prefs = await SharedPreferences.getInstance();
      store = PrefsClockSettingsStore(prefs);
      expect(store.loadClockThemeId(), ClockThemeId.digital);
    },
  );

  testWidgets('Digital and Flip keep independent theme selections', (
    tester,
  ) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
      clockThemeId: ClockThemeId.digital,
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
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    expect(find.text('Flip'), findsOneWidget);
    expect(find.text('Digital'), findsNWidgets(2));
    expect(find.text('Clock Style'), findsOneWidget);
    expect(find.text('Color Theme'), findsOneWidget);
    for (final id in DigitalThemeId.values) {
      expect(find.byKey(ValueKey('digital-theme-${id.name}')), findsOneWidget);
    }
    for (final id in FlipPaletteId.values) {
      expect(find.byKey(ValueKey('palette-${id.name}')), findsNothing);
    }

    await tester.tap(find.byKey(const ValueKey('digital-theme-digitalRed')));
    await tester.pump();
    expect(engine.digitalThemeId, DigitalThemeId.digitalRed);
    expect(
      tester
          .widget<Scaffold>(find.byKey(const ValueKey('clock-scaffold')))
          .backgroundColor,
      DigitalThemeId.digitalRed.theme.background,
    );
    final digitalTime = tester.widget<Text>(
      find.byKey(const ValueKey('digital-time')),
    );
    expect(digitalTime.style!.color, DigitalThemeId.digitalRed.theme.digit);
    expect(digitalTime.style!.shadows, isNull);

    await tester.tap(find.widgetWithText(ListTile, 'Flip'));
    await tester.pump();

    expect(engine.clockThemeId, ClockThemeId.flip);
    expect(engine.digitalThemeId, DigitalThemeId.digitalRed);
    expect(find.byType(ClockPage), findsOneWidget);
    expect(identical(container.read(clockEngineProvider), engine), isTrue);
    expect(find.byType(FlipClockFace), findsOneWidget);
    expect(find.text('Color Theme'), findsOneWidget);
    for (final id in FlipPaletteId.values) {
      expect(find.byKey(ValueKey('palette-${id.name}')), findsOneWidget);
    }
    for (final id in DigitalThemeId.values) {
      expect(find.byKey(ValueKey('digital-theme-${id.name}')), findsNothing);
    }

    await tester.tap(find.byKey(const ValueKey('palette-purple')));
    await tester.pump();
    expect(engine.flipPaletteId, FlipPaletteId.purple);
    expect(
      tester
          .widget<Scaffold>(find.byKey(const ValueKey('clock-scaffold')))
          .backgroundColor,
      FlipPaletteId.purple.palette.background,
    );

    await tester.tap(find.widgetWithText(ListTile, 'Digital'));
    await tester.pump();
    expect(engine.clockThemeId, ClockThemeId.digital);
    expect(engine.flipPaletteId, FlipPaletteId.purple);
    expect(engine.digitalThemeId, DigitalThemeId.digitalRed);
    expect(find.text('Color Theme'), findsOneWidget);
    expect(find.text('Purple'), findsNothing);
    expect(find.byType(ClockPage), findsOneWidget);
    expect(find.byType(DigitalClockFace), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('21:38')).style!.fontFamily,
      'DSEG7Classic',
    );
    expect(
      tester
          .widget<Scaffold>(find.byKey(const ValueKey('clock-scaffold')))
          .backgroundColor,
      DigitalThemeId.digitalRed.theme.background,
    );
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('digital-time')))
          .style!
          .color,
      DigitalThemeId.digitalRed.theme.digit,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Digital clock optically centers a leading one', (tester) async {
    const snapshot = ClockSnapshot(
      hour: 10,
      minute: 50,
      dateLabel: 'THU · AUG 20',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: DigitalClockFace(
          snapshot: snapshot,
          landscape: true,
          theme: DigitalTheme(
            background: Colors.black,
            digit: Colors.white,
            secondary: Colors.white70,
          ),
        ),
      ),
    );

    final transform = tester.widget<Transform>(
      find.byKey(const ValueKey('digital-time-optical-offset')),
    );
    expect(transform.transform.getTranslation().x, closeTo(-50.4, 0.001));
    expect(transform.transform.getTranslation().y, 0);
  });

  testWidgets('Digital clock expands to the available screen width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1280);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const snapshot = ClockSnapshot(
      hour: 22,
      minute: 48,
      second: 51,
      dateLabel: 'MON · AUG 24',
      showSeconds: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DigitalClockFace(
            snapshot: snapshot,
            landscape: true,
            theme: DigitalThemeId.pureDark.theme,
          ),
        ),
      ),
    );

    final timeFinder = find.byKey(const ValueKey('digital-time'));
    final layoutSize = tester.getSize(timeFinder);
    final paintedRect = tester.getRect(timeFinder);
    final transform = tester.widget<Transform>(
      find.byKey(const ValueKey('digital-time-optical-offset')),
    );

    expect(paintedRect.width, closeTo(1600 - 48, 0.1));
    expect(paintedRect.left, greaterThanOrEqualTo(24));
    expect(paintedRect.right, lessThanOrEqualTo(1600 - 24));
    expect(transform.transform.getTranslation().x, 0);
  });

  testWidgets('Digital theme colors time, period, and date independently', (
    tester,
  ) async {
    const snapshot = ClockSnapshot(
      hour: 10,
      minute: 50,
      dateLabel: 'THU · AUG 20',
      period: 'AM',
      is24Hour: false,
      showDate: true,
    );
    final theme = DigitalThemeId.digitalBlue.theme;

    await tester.pumpWidget(
      MaterialApp(
        home: DigitalClockFace(
          snapshot: snapshot,
          landscape: true,
          theme: theme,
        ),
      ),
    );

    final time = tester.widget<Text>(
      find.byKey(const ValueKey('digital-time')),
    );
    expect(time.style!.color, theme.digit);
    expect(time.style!.shadows, isNull);
    expect(tester.widget<Text>(find.text('AM')).style!.color, theme.secondary);
    expect(tester.widget<Text>(find.text('AM')).style!.fontSize, 24);
    expect(
      tester.widget<Text>(find.text('AM')).style!.fontWeight,
      FontWeight.w900,
    );
    expect(
      tester.widget<Text>(find.text('THU · AUG 20')).style!.color,
      theme.secondary,
    );
    expect(tester.widget<Text>(find.text('AM')).style!.shadows, isNull);
  });

  testWidgets('ClockTheme sheet does not overflow in landscape', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(516, 250);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Flip'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Digital'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Flip face animates when the displayed minute changes', (
    tester,
  ) async {
    ClockSnapshot snap(int minute) =>
        ClockSnapshot(hour: 21, minute: minute, dateLabel: 'THU · AUG 20');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlipClockFace(
            snapshot: snap(38),
            landscape: false,
            palette: FlipPaletteId.pureDark.palette,
          ),
        ),
      ),
    );
    expect(find.text('38'), findsNWidgets(2));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlipClockFace(
            snapshot: snap(39),
            landscape: false,
            palette: FlipPaletteId.pureDark.palette,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpAndSettle();
    expect(find.text('39'), findsNWidgets(2));
    expect(find.text('38'), findsNothing);
  });

  testWidgets('Flip divider stays fixed above the animated flap', (
    tester,
  ) async {
    ClockSnapshot snap(int minute) =>
        ClockSnapshot(hour: 21, minute: minute, dateLabel: 'THU · AUG 20');

    Widget face(int minute) => MaterialApp(
      home: Scaffold(
        body: FlipClockFace(
          snapshot: snap(minute),
          landscape: true,
          palette: FlipPaletteId.pureDark.palette,
        ),
      ),
    );

    await tester.pumpWidget(face(38));
    final divider = find.byKey(const ValueKey('flip-divider')).at(1);
    final initialSize = tester.getSize(divider);
    final initialCenter = tester.getCenter(divider);

    await tester.pumpWidget(face(39));
    await tester.pump(const Duration(milliseconds: 1));
    expect(tester.getSize(divider), initialSize);
    expect(tester.getCenter(divider), initialCenter);

    var cardStack = tester.widget<Stack>(
      find.byKey(const ValueKey('flip-card-stack')).at(1),
    );
    final flapIndex = cardStack.children.indexWhere(
      (child) => child.key == const ValueKey('flip-flap'),
    );
    final dividerIndex = cardStack.children.indexWhere(
      (child) =>
          child is Center && child.child?.key == const ValueKey('flip-divider'),
    );
    expect(flapIndex, greaterThanOrEqualTo(0));
    expect(dividerIndex, greaterThan(flapIndex));

    await tester.pump(const Duration(milliseconds: 349));
    expect(tester.getSize(divider), initialSize);
    expect(tester.getCenter(divider), initialCenter);

    cardStack = tester.widget<Stack>(
      find.byKey(const ValueKey('flip-card-stack')).at(1),
    );
    expect(
      cardStack.children.indexWhere(
        (child) =>
            child is Center &&
            child.child?.key == const ValueKey('flip-divider'),
      ),
      greaterThan(
        cardStack.children.indexWhere(
          (child) => child.key == const ValueKey('flip-flap'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.getSize(divider), initialSize);
    expect(tester.getCenter(divider), initialCenter);
  });

  testWidgets('Flip flap keeps a continuous speed through the midpoint', (
    tester,
  ) async {
    ClockSnapshot snap(int minute) =>
        ClockSnapshot(hour: 21, minute: minute, dateLabel: 'THU · AUG 20');

    Widget face(int minute) => MaterialApp(
      home: Scaffold(
        body: FlipClockFace(
          snapshot: snap(minute),
          landscape: true,
          palette: FlipPaletteId.pureDark.palette,
        ),
      ),
    );

    double flapAngle() {
      final flap = find.byKey(const ValueKey('flip-flap'));
      final transform = tester.widget<Transform>(
        find.descendant(of: flap, matching: find.byType(Transform)),
      );
      return math
          .atan2(
            transform.transform.entry(2, 1),
            transform.transform.entry(1, 1),
          )
          .abs();
    }

    await tester.pumpWidget(face(38));
    await tester.pumpWidget(face(39));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 340));
    final distanceBeforeMidpoint = math.pi / 2 - flapAngle();

    await tester.pump(const Duration(milliseconds: 20));
    final distanceAfterMidpoint = math.pi / 2 - flapAngle();

    expect(
      (distanceBeforeMidpoint - distanceAfterMidpoint).abs(),
      lessThan(0.01),
    );
  });

  testWidgets('Flip face groups hour and minute into two cards', (
    tester,
  ) async {
    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 0,
      dateLabel: 'THU · AUG 20',
      period: 'AM',
      is24Hour: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlipClockFace(
            snapshot: snapshot,
            landscape: true,
            palette: FlipPaletteId.pureDark.palette,
          ),
        ),
      ),
    );

    expect(find.text('9'), findsNWidgets(2));
    expect(find.text('00'), findsNWidgets(2));
    expect(find.text('AM'), findsOneWidget);
    final period = tester.widget<Text>(find.text('AM'));
    expect(period.key, const ValueKey('flip-period'));
    expect(period.style!.fontSize, 260 * 0.12);
    expect(period.style!.fontWeight, FontWeight.w900);
    final periodRect = tester.getRect(find.text('AM'));
    final hourCardRect = tester.getRect(
      find.byKey(const ValueKey('flip-card-stack')).first,
    );
    expect(periodRect.left, greaterThan(hourCardRect.left));
    expect(periodRect.top, greaterThan(hourCardRect.top));
    expect(periodRect.right, lessThan(hourCardRect.right));
    expect(periodRect.bottom, lessThan(hourCardRect.bottom));
    expect(
      find.ancestor(
        of: find.text('AM'),
        matching: find.byKey(const ValueKey('flip-card-stack')),
      ),
      findsOneWidget,
    );
    expect(find.text(':'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Flip face stacks hour above minute in portrait', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 0,
      dateLabel: 'THU · AUG 20',
      period: 'AM',
      is24Hour: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlipClockFace(
            snapshot: snapshot,
            landscape: false,
            palette: FlipPaletteId.pureDark.palette,
          ),
        ),
      ),
    );

    final hourCenter = tester.getCenter(find.text('9').first);
    final minuteCenter = tester.getCenter(find.text('00').first);
    final cardFinder = find.byKey(const ValueKey('flip-card-stack')).first;
    final cardLayoutSize = tester.getSize(cardFinder);
    final cardPaintedRect = tester.getRect(cardFinder);
    expect(hourCenter.dx, closeTo(minuteCenter.dx, 0.1));
    expect(hourCenter.dy, lessThan(minuteCenter.dy));
    expect(cardPaintedRect.width, greaterThan(cardLayoutSize.width));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Flip face consumes card, digit, and divider palette colors', (
    tester,
  ) async {
    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 0,
      dateLabel: 'THU · AUG 20',
    );
    final palette = FlipPaletteId.yellow.palette;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlipClockFace(
            snapshot: snapshot,
            landscape: true,
            palette: palette,
          ),
        ),
      ),
    );

    final top = tester.widget<Container>(
      find.byKey(const ValueKey('flip-card-top')).first,
    );
    final bottom = tester.widget<Container>(
      find.byKey(const ValueKey('flip-card-bottom')).first,
    );
    final divider = tester.widget<Container>(
      find.byKey(const ValueKey('flip-divider')).first,
    );

    final topGradient = (top.decoration! as BoxDecoration).gradient!;
    final bottomGradient = (bottom.decoration! as BoxDecoration).gradient!;
    final dividerGradient =
        (divider.decoration! as BoxDecoration).gradient! as LinearGradient;
    expect((topGradient as LinearGradient).colors, contains(palette.cardTop));
    expect(
      (bottomGradient as LinearGradient).colors,
      contains(palette.cardBottom),
    );
    expect(
      dividerGradient.colors,
      contains(Color.lerp(Colors.transparent, palette.divider, 0.72)),
    );
    expect(
      tester.widget<Text>(find.text('9').first).style!.color,
      palette.digit,
    );
  });

  testWidgets('Flip face fits seconds and date in a compact portrait', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 5,
      second: 7,
      dateLabel: 'THU · AUG 20',
      showSeconds: true,
      showDate: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlipClockFace(
            snapshot: snapshot,
            landscape: false,
            palette: FlipPaletteId.blue.palette,
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('flip-card-stack')), findsNWidgets(3));
    expect(find.text('THU · AUG 20'), findsOneWidget);
    final cards = find.byKey(const ValueKey('flip-card-stack'));
    final centers = [
      tester.getCenter(cards.at(0)),
      tester.getCenter(cards.at(1)),
      tester.getCenter(cards.at(2)),
    ];
    expect(centers[0].dy, lessThan(centers[1].dy));
    expect(centers[1].dy, lessThan(centers[2].dy));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Flip face matches the portrait visual baseline', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 25,
      dateLabel: 'THU · AUG 20',
      period: 'AM',
      is24Hour: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: FlipPaletteId.pureDark.palette.background,
          body: RepaintBoundary(
            key: const ValueKey('flip-golden-surface'),
            child: FlipClockFace(
              snapshot: snapshot,
              landscape: false,
              palette: FlipPaletteId.pureDark.palette,
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byKey(const ValueKey('flip-golden-surface')),
      matchesGoldenFile('goldens/flip_clock_pure_dark_portrait.png'),
    );
  });

  testWidgets('Flip face matches the landscape visual baseline', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 25,
      dateLabel: 'THU · AUG 20',
      period: 'AM',
      is24Hour: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: FlipPaletteId.pureDark.palette.background,
          body: RepaintBoundary(
            key: const ValueKey('flip-golden-surface'),
            child: FlipClockFace(
              snapshot: snapshot,
              landscape: true,
              palette: FlipPaletteId.pureDark.palette,
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byKey(const ValueKey('flip-golden-surface')),
      matchesGoldenFile('goldens/flip_clock_pure_dark_landscape.png'),
    );
  });

  testWidgets('session face uses Flip colors only for the Flip style', (
    tester,
  ) async {
    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 0,
      dateLabel: 'THU · AUG 20',
      session: SessionSnapshot(
        kind: SessionKind.focus,
        remaining: Duration(minutes: 5),
        status: SessionStatus.running,
        duration: Duration(minutes: 25),
      ),
    );
    final lightPalette = FlipPaletteId.light.palette;

    await tester.pumpWidget(
      MaterialApp(
        home: ClockFace(
          themeId: ClockThemeId.digital,
          digitalTheme: DigitalThemeId.digitalAmber.theme,
          flipPalette: lightPalette,
          snapshot: snapshot,
          landscape: false,
        ),
      ),
    );
    final digitalSession = tester.widget<Text>(find.text('05:00'));
    expect(
      digitalSession.style!.color,
      DigitalThemeId.digitalAmber.theme.digit,
    );
    expect(digitalSession.style!.shadows, isNull);

    await tester.pumpWidget(
      MaterialApp(
        home: ClockFace(
          themeId: ClockThemeId.flip,
          digitalTheme: DigitalThemeId.digitalAmber.theme,
          flipPalette: lightPalette,
          snapshot: snapshot,
          landscape: false,
        ),
      ),
    );
    expect(
      tester.widget<Text>(find.text('05:00')).style!.color,
      lightPalette.digit,
    );
  });
}
