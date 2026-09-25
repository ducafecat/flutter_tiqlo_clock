import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/bubble_palette.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/core/ui/app/app_ui_style.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/bubble/bubble_clock_face.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('all ten SVG digits load and paint without errors', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 240);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColoredBox(
            color: BubblePaletteId.blue.palette.background,
            child: RepaintBoundary(
              key: const ValueKey('bubble-glyphs-golden'),
              child: Row(
                children: [
                  for (var digit = 0; digit < 10; digit++)
                    SizedBox(
                      width: 100,
                      height: 160,
                      child: SvgPicture.asset(
                        'assets/bubble/$digit.svg',
                        width: 100,
                        height: 160,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          BubblePaletteId.blue.palette.digit4,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(SvgPicture), findsNWidgets(10));
    await expectLater(
      find.byKey(const ValueKey('bubble-glyphs-golden')),
      matchesGoldenFile('goldens/bubble_glyphs_0_9_1200x240.png'),
    );
  });

  testWidgets('Bubble displays HH:mm and animates only changed digits', (
    tester,
  ) async {
    const initial = ClockSnapshot(
      hour: 21,
      minute: 38,
      second: 41,
      dateLabel: 'FRI · AUG 28',
      period: 'PM',
      is24Hour: false,
      showSeconds: true,
      showDate: true,
    );

    await tester.pumpWidget(_clock(initial));

    expect(find.bySemanticsLabel('9:38 PM'), findsOneWidget);
    expect(find.byType(Text), findsNothing);
    expect(find.byKey(const ValueKey('bubble-glyph-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-8')), findsOneWidget);

    const updated = ClockSnapshot(
      hour: 21,
      minute: 39,
      second: 2,
      dateLabel: 'FRI · AUG 28',
      period: 'PM',
      is24Hour: false,
      showSeconds: true,
      showDate: true,
    );
    await tester.pumpWidget(_clock(updated));
    await tester.pump(const Duration(milliseconds: 140));

    expect(find.byKey(const ValueKey('bubble-glyph-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-8')), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-9')), findsNWidgets(2));

    await tester.pump(const Duration(milliseconds: 180));
    expect(find.byKey(const ValueKey('bubble-glyph-8')), findsNothing);
    expect(find.byKey(const ValueKey('bubble-glyph-9')), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bubble respects the existing leading zero setting', (
    tester,
  ) async {
    await tester.pumpWidget(
      _clock(
        const ClockSnapshot(
          hour: 9,
          minute: 8,
          dateLabel: '',
          showLeadingZero: true,
        ),
      ),
    );

    expect(find.bySemanticsLabel('09:08'), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-0')), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bubble updates all four SVG digits across midnight', (
    tester,
  ) async {
    await tester.pumpWidget(
      _clock(
        const ClockSnapshot(
          hour: 23,
          minute: 59,
          dateLabel: '',
          showLeadingZero: true,
        ),
      ),
    );
    expect(find.bySemanticsLabel('23:59'), findsOneWidget);

    await tester.pumpWidget(
      _clock(
        const ClockSnapshot(
          hour: 0,
          minute: 0,
          dateLabel: '',
          showLeadingZero: true,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 320));

    expect(find.bySemanticsLabel('00:00'), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-0')), findsNWidgets(4));
    expect(find.byKey(const ValueKey('bubble-glyph-2')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bubble fits portrait and landscape constraints', (tester) async {
    for (final size in [const Size(390, 844), const Size(844, 390)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(_clock(_snapshot));
      await tester.pump(const Duration(milliseconds: 1));

      expect(find.byType(BubbleClockFace), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const ValueKey('bubble-content-viewport'))),
        size,
      );
      expect(tester.takeException(), isNull);
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('Bubble uses its low brightness night palette', (tester) async {
    await tester.pumpWidget(_clock(_snapshot, palette: BubblePalette.night));

    final background = tester.widget<ColoredBox>(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox &&
            widget.color == BubblePalette.night.background,
      ),
    );
    expect(background.color, const Color(0xFF020000));
    final digit = tester.widget<SvgPicture>(
      find.descendant(
        of: find.byKey(const ValueKey('bubble-glyph-2')),
        matching: find.byType(SvgPicture),
      ),
    );
    expect(
      digit.colorFilter,
      const ColorFilter.mode(Color(0xFF8F1717), BlendMode.srcIn),
    );
  });

  testWidgets('Pixel and Standard adapters share the Bubble face', (
    tester,
  ) async {
    for (final style in [AppUiStyle.pixel, AppUiStyle.standard]) {
      await tester.pumpWidget(
        MaterialApp(
          home: ClockFace(
            style: style,
            themeId: ClockThemeId.bubble,
            digitalThemeId: DigitalThemeId.digitalRed,
            flipPaletteId: FlipPaletteId.purple,
            bubblePaletteId: BubblePaletteId.greenMix,
            snapshot: _snapshot,
            landscape: true,
          ),
        ),
      );

      expect(find.byType(BubbleClockFace), findsOneWidget);
      final face = tester.widget<BubbleClockFace>(find.byType(BubbleClockFace));
      expect(face.palette, BubblePaletteId.greenMix.palette);
    }
  });

  testWidgets('Bubble burn-in protection shifts slowly every three minutes', (
    tester,
  ) async {
    await tester.pumpWidget(_clock(_snapshot));

    var offsetTransform = tester.widget<Transform>(
      find.byKey(const ValueKey('bubble-burn-in-offset')),
    );
    expect(offsetTransform.transform.getTranslation().x, 0);
    expect(offsetTransform.transform.getTranslation().y, 0);

    await tester.pump(const Duration(minutes: 3));
    await tester.pump(const Duration(seconds: 8));
    offsetTransform = tester.widget<Transform>(
      find.byKey(const ValueKey('bubble-burn-in-offset')),
    );
    expect(offsetTransform.transform.getTranslation().x, 3);
    expect(offsetTransform.transform.getTranslation().y, -1);

    for (final expectedOffset in const [
      Offset(1, 2),
      Offset(-3, 1),
      Offset(-1, -2),
      Offset(0, 0),
    ]) {
      await tester.pump(const Duration(minutes: 3));
      await tester.pump(const Duration(seconds: 8));
      offsetTransform = tester.widget<Transform>(
        find.byKey(const ValueKey('bubble-burn-in-offset')),
      );
      final actualOffset = offsetTransform.transform.getTranslation();
      expect(actualOffset.x, expectedOffset.dx);
      expect(actualOffset.y, expectedOffset.dy);
    }
  });

  testWidgets('Bubble transitions respect reduced motion', (tester) async {
    await tester.pumpWidget(_clock(_snapshot, disableAnimations: true));

    for (final switcher in tester.widgetList<AnimatedSwitcher>(
      find.byType(AnimatedSwitcher),
    )) {
      expect(switcher.duration, Duration.zero);
    }
    final offsetAnimation = tester.widget<TweenAnimationBuilder<Offset>>(
      find.byWidgetPredicate(
        (widget) => widget is TweenAnimationBuilder<Offset>,
      ),
    );
    expect(offsetAnimation.duration, Duration.zero);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bubble glyphs overlap and blend with translucency', (
    tester,
  ) async {
    await tester.pumpWidget(_clock(_snapshot));
    await tester.pump(const Duration(milliseconds: 300));

    final firstHourDigit = tester.getRect(
      find.byKey(const ValueKey('bubble-glyph-2')),
    );
    final secondHourDigit = tester.getRect(
      find.byKey(const ValueKey('bubble-glyph-1')),
    );
    final firstMinuteDigit = tester.getRect(
      find.byKey(const ValueKey('bubble-glyph-3')),
    );
    final secondMinuteDigit = tester.getRect(
      find.byKey(const ValueKey('bubble-glyph-8')),
    );
    final colon = tester.getRect(find.byKey(const ValueKey('bubble-colon')));
    expect(firstHourDigit.overlaps(secondHourDigit), isTrue);
    expect(firstMinuteDigit.overlaps(secondMinuteDigit), isTrue);
    expect(
      firstHourDigit.intersect(secondHourDigit).width / secondHourDigit.width,
      greaterThan(0.25),
    );
    expect(
      firstMinuteDigit.intersect(secondMinuteDigit).width /
          secondMinuteDigit.width,
      greaterThan(0.25),
    );
    expect(colon.overlaps(secondHourDigit), isTrue);
    expect(colon.overlaps(firstMinuteDigit), isTrue);

    final digit = tester.widget<Opacity>(
      find.byKey(const ValueKey('bubble-glyph-2')),
    );
    expect(digit.opacity, 0.86);
    final colonSvg = tester.widget<SvgPicture>(
      find.descendant(
        of: find.byKey(const ValueKey('bubble-colon')),
        matching: find.byType(SvgPicture),
      ),
    );
    expect(
      (colonSvg.bytesLoader as SvgAssetLoader).assetName,
      'assets/bubble/colon.svg',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bubble landscape glyphs match their visual baseline', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RepaintBoundary(
            key: const ValueKey('bubble-clock-landscape-golden'),
            child: BubbleClockFace(
              snapshot: _referenceSnapshot,
              palette: BubblePaletteId.blue.palette,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 180));
    await tester.pump();

    for (final digit in [1, 2, 0, 3]) {
      expect(find.byKey(ValueKey('bubble-glyph-$digit')), findsOneWidget);
      expect(
        tester.getSize(find.byKey(ValueKey('bubble-glyph-$digit'))).height,
        160,
      );
    }
    expect(
      tester.getSize(find.byKey(const ValueKey('bubble-glyph-1'))).width,
      lessThan(
        tester.getSize(find.byKey(const ValueKey('bubble-glyph-2'))).width,
      ),
    );
    final firstDigit = tester.getRect(
      find.byKey(const ValueKey('bubble-glyph-1')),
    );
    final secondDigit = tester.getRect(
      find.byKey(const ValueKey('bubble-glyph-2')),
    );
    final viewport = tester.getRect(
      find.byKey(const ValueKey('bubble-content-viewport')),
    );
    expect(firstDigit.height, lessThan(315));
    expect(firstDigit.top, greaterThan(viewport.top));
    expect(firstDigit.bottom, lessThan(viewport.bottom));
    expect(firstDigit.top, isNot(secondDigit.top));
    final firstTilt = tester.widget<Transform>(
      find.byKey(const ValueKey('bubble-digit-tilt-0')),
    );
    final secondTilt = tester.widget<Transform>(
      find.byKey(const ValueKey('bubble-digit-tilt-1')),
    );
    expect(firstTilt.transform.storage[1], isNot(0));
    expect(
      firstTilt.transform.storage[1],
      isNot(secondTilt.transform.storage[1]),
    );

    await expectLater(
      find.byKey(const ValueKey('bubble-clock-landscape-golden')),
      matchesGoldenFile('goldens/bubble_clock_landscape_844x390.png'),
    );
  });

  testWidgets('Bubble 22:22 keeps the curved tops of all four twos', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('bubble-four-twos-golden'),
        child: _clock(const ClockSnapshot(hour: 22, minute: 22, dateLabel: '')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(find.byKey(const ValueKey('bubble-glyph-2')), findsNWidgets(4));
    await expectLater(
      find.byKey(const ValueKey('bubble-four-twos-golden')),
      matchesGoldenFile('goldens/bubble_clock_four_twos_844x390.png'),
    );
  });
}

const _snapshot = ClockSnapshot(
  hour: 21,
  minute: 38,
  dateLabel: 'FRI · AUG 28',
);

const _referenceSnapshot = ClockSnapshot(
  hour: 12,
  minute: 3,
  dateLabel: '',
  showLeadingZero: true,
);

Widget _clock(
  ClockSnapshot snapshot, {
  BubblePalette? palette,
  bool disableAnimations = false,
}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Scaffold(
    body: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: BubbleClockFace(
        snapshot: snapshot,
        palette: palette ?? BubblePaletteId.blue.palette,
      ),
    ),
  ),
);
