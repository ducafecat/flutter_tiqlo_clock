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
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_ui.dart';
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_theme_sheet_style.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_theme_sheet.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/flip_clock_face.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
    final jerseyFont = FontLoader('Jersey25')
      ..addFont(rootBundle.load('fonts/Jersey25-Regular.ttf'));
    await jerseyFont.load();
    final hudFont = FontLoader('Tiny5')
      ..addFont(rootBundle.load('fonts/Tiny5-Regular.ttf'));
    await hudFont.load();
    final bodyFont = FontLoader('PixelifySans')
      ..addFont(rootBundle.load('fonts/PixelifySans-Regular.ttf'));
    await bodyFont.load();
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

  testWidgets('Theme sheet opens with Flip and Pure Dark selected by default', (
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
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    final flip = tester.widget<PixelSelectionTile>(
      find.byKey(const ValueKey('clock-style-flip')),
    );
    final digital = tester.widget<PixelSelectionTile>(
      find.byKey(const ValueKey('clock-style-digital')),
    );
    final pureDark = tester.widget<PixelColorOption>(
      find.byKey(const ValueKey('palette-pureDark')),
    );

    expect(flip.selected, isTrue);
    expect(digital.selected, isFalse);
    expect(pureDark.selected, isTrue);
    expect(
      tester
          .widgetList<PixelColorOption>(find.byType(PixelColorOption))
          .where((option) => option.selected),
      hasLength(1),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

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

    expect(find.byType(PixelSelectionTile), findsNWidgets(2));
    expect(find.text('Clock Style'), findsOneWidget);
    expect(find.text('Color Theme'), findsOneWidget);
    expect(
      find.byType(PixelColorOption),
      findsNWidgets(DigitalThemeId.values.length),
    );
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

    await tester.tap(find.byKey(const ValueKey('clock-style-flip')));
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

    await tester.tap(find.byKey(const ValueKey('clock-style-digital')));
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
      'Handjet',
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
      FontWeight.w400,
    );
    expect(tester.widget<Text>(find.text('AM')).style!.fontFamily, 'Tiny5');
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
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

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
    expect(find.byKey(const ValueKey('clock-style-digital')), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('palette-pink')),
      120,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey('pixel-sheet-scroll')),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.byKey(const ValueKey('palette-pink')), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Digital theme scroll viewport fits wide landscape', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1311, 603);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: const Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: PixelSheet(
              layout: PixelSheetLayout.theme,
              child: ClockThemeSheet(
                clockThemeId: ClockThemeId.digital,
                flipPaletteId: FlipPaletteId.pureDark,
                digitalThemeId: DigitalThemeId.digital,
                onClockThemeSelected: _ignoreClockTheme,
                onFlipPaletteSelected: _ignoreFlipPalette,
                onDigitalThemeSelected: _ignoreDigitalTheme,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final frameRect = tester.getRect(find.byType(PixelThemeSheetFrame));
    expect(frameRect.height, lessThanOrEqualTo(603 * 0.68));

    final scrollable = find.descendant(
      of: find.byKey(const ValueKey('pixel-sheet-scroll')),
      matching: find.byType(Scrollable),
    );
    final scrollState = tester.state<ScrollableState>(scrollable);
    expect(scrollState.position.maxScrollExtent, greaterThan(0));
    scrollState.position.jumpTo(scrollState.position.maxScrollExtent);
    await tester.pump();

    final classicRect = tester.getRect(
      find.byKey(const ValueKey('digital-theme-classic')),
    );
    final scrollRect = tester.getRect(scrollable);
    expect(
      frameRect.bottom - scrollRect.bottom,
      greaterThanOrEqualTo(PixelThemeSheetStyle.themeScrollViewportBottomInset),
    );
    expect(
      scrollRect.bottom - classicRect.bottom,
      greaterThanOrEqualTo(PixelThemeSheetStyle.themeBottomInset),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Theme sheet matches the reference geometry at 470dp', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(941, 1672);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: const Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: PixelSheet(
              layout: PixelSheetLayout.theme,
              child: ClockThemeSheet(
                clockThemeId: ClockThemeId.flip,
                flipPaletteId: FlipPaletteId.pureDark,
                digitalThemeId: DigitalThemeId.digital,
                onClockThemeSelected: _ignoreClockTheme,
                onFlipPaletteSelected: _ignoreFlipPalette,
                onDigitalThemeSelected: _ignoreDigitalTheme,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('pixel-theme-drag-handle'))),
      const Size(44, 8),
    );

    final flipRect = tester.getRect(
      find.byKey(const ValueKey('clock-style-flip')),
    );
    final digitalRect = tester.getRect(
      find.byKey(const ValueKey('clock-style-digital')),
    );
    expect(flipRect.left, 28);
    expect(flipRect.right, 442.5);
    expect(flipRect.height, 48);
    expect(digitalRect.height, 48);
    expect(digitalRect.top - flipRect.bottom, 8);

    final pureDark = tester.getRect(
      find.byKey(const ValueKey('palette-pureDark')),
    );
    final dark = tester.getRect(find.byKey(const ValueKey('palette-dark')));
    final light = tester.getRect(find.byKey(const ValueKey('palette-light')));
    final green = tester.getRect(find.byKey(const ValueKey('palette-green')));
    final blue = tester.getRect(find.byKey(const ValueKey('palette-blue')));
    final red = tester.getRect(find.byKey(const ValueKey('palette-red')));
    final orange = tester.getRect(find.byKey(const ValueKey('palette-orange')));
    final yellow = tester.getRect(find.byKey(const ValueKey('palette-yellow')));
    final purple = tester.getRect(find.byKey(const ValueKey('palette-purple')));
    final pink = tester.getRect(find.byKey(const ValueKey('palette-pink')));

    expect(pureDark.top, dark.top);
    expect(dark.top, light.top);
    expect(green.top, blue.top);
    expect(blue.top, red.top);
    expect(orange.top, yellow.top);
    expect(yellow.top, purple.top);
    expect(green.top, greaterThan(pureDark.bottom));
    expect(orange.top, greaterThan(green.bottom));
    expect(pink.top, greaterThan(orange.bottom));
    expect(pink.left, pureDark.left);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Flip face completes its animation in 700ms', (tester) async {
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

    final duration = const PixelTokens.dark().flipDuration;
    expect(duration, const Duration(milliseconds: 700));
    await tester.pump(duration - const Duration(milliseconds: 1));
    expect(tester.hasRunningAnimations, isTrue);
    final settledBottom = tester.widget<Transform>(
      find.byKey(const ValueKey('flip-bottom-transform')),
    );
    expect(settledBottom.filterQuality, FilterQuality.none);
    expect(settledBottom.transform.entry(1, 1), closeTo(1, 0.0001));
    final settledShade = tester.widget<ColoredBox>(
      find.byKey(const ValueKey('flip-bottom-shade')),
    );
    final settledEdge = tester.widget<ColoredBox>(
      find.byKey(const ValueKey('flip-bottom-edge')),
    );
    expect(settledShade.color.a, 0);
    expect(settledEdge.color.a, 0);

    await tester.pump(const Duration(milliseconds: 2));
    expect(find.byKey(const ValueKey('flip-flap')), findsNothing);
    await tester.pump();
    expect(tester.hasRunningAnimations, isFalse);
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

    await tester.pump(const Duration(milliseconds: 499));
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

  testWidgets('Flip replaces digits immediately when animations are disabled', (
    tester,
  ) async {
    ClockSnapshot snap(int minute) =>
        ClockSnapshot(hour: 21, minute: minute, dateLabel: 'THU · AUG 20');

    Widget face(int minute) => MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Scaffold(
          body: FlipClockFace(
            snapshot: snap(minute),
            landscape: true,
            palette: FlipPaletteId.pureDark.palette,
          ),
        ),
      ),
    );

    await tester.pumpWidget(face(38));
    await tester.pumpWidget(face(39));
    await tester.pump();

    expect(find.text('39'), findsNWidgets(2));
    expect(find.text('38'), findsNothing);
    expect(find.byKey(const ValueKey('flip-flap')), findsNothing);
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
      final transforms = [
        tester.widget<Transform>(
          find.descendant(
            of: flap,
            matching: find.byKey(const ValueKey('flip-top-transform')),
          ),
        ),
        tester.widget<Transform>(
          find.descendant(
            of: flap,
            matching: find.byKey(const ValueKey('flip-bottom-transform')),
          ),
        ),
      ];
      return transforms
          .map(
            (transform) => math
                .atan2(
                  transform.transform.entry(2, 1),
                  transform.transform.entry(1, 1),
                )
                .abs(),
          )
          .reduce(math.min);
    }

    await tester.pumpWidget(face(38));
    await tester.pumpWidget(face(39));
    await tester.pump();
    final topTransform = tester.widget<Transform>(
      find.descendant(
        of: find.byKey(const ValueKey('flip-flap')),
        matching: find.byKey(const ValueKey('flip-top-transform')),
      ),
    );
    expect(topTransform.filterQuality, FilterQuality.none);
    await tester.pump(const Duration(milliseconds: 10));
    final movingTopTransform = tester.widget<Transform>(
      find.descendant(
        of: find.byKey(const ValueKey('flip-flap')),
        matching: find.byKey(const ValueKey('flip-top-transform')),
      ),
    );
    expect(movingTopTransform.filterQuality, FilterQuality.low);
    final duration = const PixelTokens.dark().flipDuration;
    final midpoint = Duration(microseconds: duration.inMicroseconds ~/ 2);
    await tester.pump(midpoint - const Duration(milliseconds: 20));
    final distanceBeforeMidpoint = math.pi / 2 - flapAngle();

    await tester.pump(const Duration(milliseconds: 20));
    final distanceAfterMidpoint = math.pi / 2 - flapAngle();

    expect(
      (distanceBeforeMidpoint - distanceAfterMidpoint).abs(),
      lessThan(0.01),
    );
  });

  testWidgets('Flip keeps both rasterized halves across the midpoint', (
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
    await tester.pumpWidget(face(39));
    await tester.pump();

    final topCache = find.byKey(const ValueKey('flip-top-cache'));
    final bottomCache = find.byKey(const ValueKey('flip-bottom-cache'));
    final topRenderObject = tester.renderObject(topCache);
    final bottomRenderObject = tester.renderObject(bottomCache);

    final duration = const PixelTokens.dark().flipDuration;
    final midpoint = Duration(microseconds: duration.inMicroseconds ~/ 2);
    await tester.pump(midpoint - const Duration(milliseconds: 1));
    expect(tester.renderObject(topCache), same(topRenderObject));
    expect(tester.renderObject(bottomCache), same(bottomRenderObject));

    await tester.pump(const Duration(milliseconds: 2));
    expect(tester.renderObject(topCache), same(topRenderObject));
    expect(tester.renderObject(bottomCache), same(bottomRenderObject));
  });

  testWidgets('Flip rotates and shades the complete card surface', (
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
    await tester.pumpWidget(face(39));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 175));

    final topTransform = find.byKey(const ValueKey('flip-top-transform'));
    expect(
      find.descendant(
        of: topTransform,
        matching: find.byKey(const ValueKey('flip-card-top')),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: topTransform,
        matching: find.byKey(const ValueKey('flip-top-edge')),
      ),
      findsOneWidget,
    );
    final shade = tester.widget<ColoredBox>(
      find.descendant(
        of: topTransform,
        matching: find.byKey(const ValueKey('flip-top-shade')),
      ),
    );
    expect(shade.color.a, greaterThan(0));
  });

  testWidgets('Flip card corners stay capped on a large viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const snapshot = ClockSnapshot(
      hour: 3,
      minute: 39,
      second: 18,
      dateLabel: 'THU · AUG 20',
      showSeconds: true,
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

    final frame = tester.widget<CustomPaint>(
      find.byKey(const ValueKey('flip-frame')).first,
    );
    final painter = frame.painter as dynamic;
    expect(painter.cut * painter.renderScale, lessThanOrEqualTo(32.0));
    expect(tester.takeException(), isNull);
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
    expect(period.style!.fontSize, 281 * 0.083);
    expect(period.style!.fontFamily, 'Tiny5');
    expect(period.style!.fontWeight, FontWeight.w400);
    expect(period.style!.shadows, hasLength(4));
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

  testWidgets('Flip landscape cards keep identical dimensions', (tester) async {
    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 19,
      second: 46,
      dateLabel: 'THU · AUG 20',
      period: 'PM',
      is24Hour: false,
      showSeconds: true,
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

    final cards = find.byKey(const ValueKey('flip-card-stack'));
    expect(cards, findsNWidgets(3));
    final firstSize = tester.getSize(cards.first);
    expect(firstSize.width, closeTo(firstSize.height, 0.01));
    expect(tester.getSize(cards.at(1)), firstSize);
    expect(tester.getSize(cards.at(2)), firstSize);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Flip exposes the complete wall time as one semantic node', (
    tester,
  ) async {
    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 5,
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

    final time = find.bySemanticsLabel(snapshot.timeLabel);
    expect(time, findsOneWidget);
    expect(tester.getSemantics(time), matchesSemantics(label: '09:05 AM'));
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
    expect(hourCenter.dx, closeTo(minuteCenter.dx, 1));
    expect(hourCenter.dy, lessThan(minuteCenter.dy));
    expect(cardPaintedRect.width, lessThan(cardLayoutSize.width));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Flip face consumes flat card, digit, and divider palette colors',
    (tester) async {
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

      expect(top.color, palette.cardTop);
      expect(bottom.color, palette.cardBottom);
      expect(divider.color, palette.divider);
      expect(
        tester.widget<Text>(find.text('9').first).style!.color,
        palette.digit,
      );
    },
  );

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
    final firstSize = tester.getSize(cards.first);
    expect(firstSize.width, closeTo(firstSize.height, 0.01));
    expect(tester.getSize(cards.at(1)), firstSize);
    expect(tester.getSize(cards.at(2)), firstSize);
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
      minute: 33,
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

    final doubleThree = tester.widgetList<Text>(find.text('33'));
    expect(doubleThree, hasLength(2));
    for (final digit in doubleThree) {
      expect(digit.maxLines, 1);
      expect(digit.softWrap, isFalse);
      expect(digit.overflow, TextOverflow.visible);
    }

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

  testWidgets('Flip face matches the 768 by 1522 reference baseline', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(768, 1522);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const snapshot = ClockSnapshot(
      hour: 21,
      minute: 31,
      dateLabel: 'THU · AUG 20',
      period: 'PM',
      is24Hour: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: FlipPaletteId.pureDark.palette.background,
          body: RepaintBoundary(
            key: const ValueKey('flip-reference-surface'),
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
      find.byKey(const ValueKey('flip-reference-surface')),
      matchesGoldenFile('goldens/flip_clock_reference_768x1522.png'),
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

void _ignoreClockTheme(ClockThemeId _) {}

void _ignoreFlipPalette(FlipPaletteId _) {}

void _ignoreDigitalTheme(DigitalThemeId _) {}
