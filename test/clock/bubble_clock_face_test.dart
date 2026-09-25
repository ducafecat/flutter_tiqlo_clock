import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  setUpAll(() async {
    final font = FontLoader('BubbleClock')
      ..addFont(rootBundle.load('assets/fonts/bubble/Fredoka-Medium.ttf'));
    await font.load();
  });

  testWidgets('Bubble renders independent Fredoka digits and two round dots', (
    tester,
  ) async {
    await tester.pumpWidget(_clock(_snapshot));
    expect(find.bySemanticsLabel('21:38'), findsOneWidget);
    for (final digit in ['2', '1', '3', '8']) {
      final text = tester.widget<Text>(
        find.byKey(ValueKey('bubble-glyph-$digit')),
      );
      expect(text.data, digit);
      expect(text.style?.fontFamily, 'BubbleClock');
      expect(text.style?.fontWeight, FontWeight.w500);
      expect(text.style?.height, 0.84);
    }
    for (final key in ['bubble-colon-top', 'bubble-colon-bottom']) {
      final dot = find.byKey(ValueKey(key));
      final size = tester.getSize(dot);
      expect(size.width, size.height);
      expect(
        tester
            .widget<DecoratedBox>(
              find.descendant(of: dot, matching: find.byType(DecoratedBox)),
            )
            .decoration,
        isA<BoxDecoration>().having(
          (decoration) => decoration.shape,
          'shape',
          BoxShape.circle,
        ),
      );
    }
  });

  testWidgets('Bubble colon dots blend over adjacent digits', (tester) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _clock(
        const ClockSnapshot(
          hour: 23,
          minute: 9,
          dateLabel: '',
          showLeadingZero: true,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    final hourDigit = tester.getRect(
      find.byKey(const ValueKey('bubble-digit-tilt-1')),
    );
    final minuteDigit = tester.getRect(
      find.byKey(const ValueKey('bubble-digit-tilt-2')),
    );
    for (final key in ['bubble-colon-top', 'bubble-colon-bottom']) {
      final dot = find.byKey(ValueKey(key));
      final rect = tester.getRect(dot);
      expect(rect.intersect(hourDigit).width, greaterThan(0));
      expect(rect.intersect(minuteDigit).width, greaterThan(0));
      expect(tester.widget<Opacity>(dot).opacity, 0.68);
    }
  });

  testWidgets('Bubble animates only the changed digit for 280 ms', (
    tester,
  ) async {
    await tester.pumpWidget(
      _clock(const ClockSnapshot(hour: 21, minute: 38, dateLabel: '')),
    );
    await tester.pumpWidget(
      _clock(const ClockSnapshot(hour: 21, minute: 39, dateLabel: '')),
    );
    await tester.pump(const Duration(milliseconds: 140));
    expect(find.byKey(const ValueKey('bubble-glyph-8')), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-9')), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-3')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 180));
    expect(find.byKey(const ValueKey('bubble-glyph-8')), findsNothing);
    expect(find.byKey(const ValueKey('bubble-glyph-9')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bubble honors leading zero and one digit hours', (tester) async {
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

    await tester.pumpWidget(
      _clock(
        const ClockSnapshot(
          hour: 9,
          minute: 8,
          dateLabel: '',
          showLeadingZero: false,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 320));
    expect(find.bySemanticsLabel('9:08'), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-9')), findsOneWidget);
    expect(find.byKey(const ValueKey('bubble-glyph-0')), findsOneWidget);
  });

  testWidgets('Bubble updates all four digits across midnight', (tester) async {
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
  });

  testWidgets('Bubble uses night palette for digits and dots', (tester) async {
    await tester.pumpWidget(_clock(_snapshot, palette: BubblePalette.night));
    expect(find.byType(BubbleClockFace), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox &&
            widget.color == BubblePalette.night.background,
      ),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 300));
    final digit = tester.widget<Text>(
      find.byKey(const ValueKey('bubble-glyph-2')),
    );
    expect(digit.style?.color, BubblePalette.night.digit1);
    expect(_dotColor(tester, 'bubble-colon-top'), BubblePalette.night.colonTop);
    expect(
      _dotColor(tester, 'bubble-colon-bottom'),
      BubblePalette.night.colonBottom,
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
      expect(
        tester.widget<BubbleClockFace>(find.byType(BubbleClockFace)).palette,
        BubblePaletteId.greenMix.palette,
      );
    }
  });

  testWidgets('Bubble burn-in protection shifts every three minutes', (
    tester,
  ) async {
    await tester.pumpWidget(_clock(_snapshot));
    var first = true;
    for (final expected in const [
      Offset(0, 0),
      Offset(3, -1),
      Offset(1, 2),
      Offset(-3, 1),
      Offset(-1, -2),
      Offset(0, 0),
    ]) {
      if (first) {
        first = false;
      } else {
        await tester.pump(const Duration(minutes: 3));
        await tester.pump(const Duration(seconds: 8));
      }
      final transform = tester.widget<Transform>(
        find.byKey(const ValueKey('bubble-burn-in-offset')),
      );
      expect(transform.transform.getTranslation().x, expected.dx);
      expect(transform.transform.getTranslation().y, expected.dy);
    }
  });

  testWidgets('Bubble respects reduced motion', (tester) async {
    await tester.pumpWidget(_clock(_snapshot, disableAnimations: true));
    for (final switcher in tester.widgetList<AnimatedSwitcher>(
      find.byType(AnimatedSwitcher),
    )) {
      expect(switcher.duration, Duration.zero);
    }
    for (final tween in tester.widgetList<TweenAnimationBuilder<Offset>>(
      find.byType(TweenAnimationBuilder<Offset>),
    )) {
      expect(tween.duration, Duration.zero);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Bubble digits overlap and tilt left or right around their centers',
    (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        _clock(
          const ClockSnapshot(
            hour: 23,
            minute: 9,
            dateLabel: '',
            showLeadingZero: true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      final first = tester.getRect(
        find.byKey(const ValueKey('bubble-digit-tilt-0')),
      );
      final second = tester.getRect(
        find.byKey(const ValueKey('bubble-digit-tilt-1')),
      );
      expect(first.intersect(second).width / second.width, greaterThan(0.18));
      expect(first.intersect(second).width / second.width, lessThan(0.50));
      final centers = [
        for (var slot = 0; slot < 4; slot++)
          tester.getCenter(find.byKey(ValueKey('bubble-digit-tilt-$slot'))).dy,
      ];
      for (final center in centers.skip(1)) {
        expect(center, closeTo(centers.first, 1));
      }
      for (final slot in [0, 2]) {
        final transform = tester.widget<Transform>(
          find.byKey(ValueKey('bubble-digit-tilt-$slot')),
        );
        expect(transform.transform.storage[1], lessThan(-0.05));
      }
      for (final slot in [1, 3]) {
        final transform = tester.widget<Transform>(
          find.byKey(ValueKey('bubble-digit-tilt-$slot')),
        );
        expect(transform.transform.storage[1], greaterThan(0.05));
      }
      final heights = [
        for (final digit in ['2', '3', '0', '9'])
          tester.getSize(find.byKey(ValueKey('bubble-glyph-$digit'))).height,
      ];
      for (final height in heights.skip(1)) {
        expect(height, closeTo(heights.first, 0.01));
      }
      final tilt0 = tester.widget<Transform>(
        find.byKey(const ValueKey('bubble-digit-tilt-0')),
      );
      final tilt1 = tester.widget<Transform>(
        find.byKey(const ValueKey('bubble-digit-tilt-1')),
      );
      expect(tilt0.transform.storage[1], isNot(tilt1.transform.storage[1]));
    },
  );

  for (final case_ in const [
    (name: '11_11', hour: 11, minute: 11),
    (name: '20_04', hour: 20, minute: 4),
    (name: '21_14', hour: 21, minute: 14),
    (name: '23_09', hour: 23, minute: 9),
    (name: '52_22', hour: 52, minute: 22),
    (name: '58_08', hour: 58, minute: 8),
    (name: '88_88', hour: 88, minute: 88),
  ]) {
    testWidgets(
      'Bubble landscape ${case_.name} stays in bounds and matches golden',
      (tester) async {
        tester.view.physicalSize = const Size(844, 390);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          RepaintBoundary(
            key: const ValueKey('bubble-golden'),
            child: _clock(
              ClockSnapshot(
                hour: case_.hour,
                minute: case_.minute,
                dateLabel: '',
                showLeadingZero: true,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 320));
        final screen = Offset.zero & const Size(844, 390);
        for (final text in tester.widgetList<Text>(find.byType(Text))) {
          if (text.style?.fontFamily != 'BubbleClock') continue;
          final rect = tester.getRect(find.byWidget(text));
          expect(rect.top, greaterThan(screen.top + 8));
          expect(rect.bottom, lessThan(screen.bottom - 8));
          expect(rect.left, greaterThanOrEqualTo(screen.left));
          expect(rect.right, lessThanOrEqualTo(screen.right));
        }
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(const ValueKey('bubble-golden')),
          matchesGoldenFile('goldens/bubble_${case_.name}_844x390.png'),
        );
      },
    );
  }

  testWidgets('Bubble portrait fits and matches golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('bubble-portrait-golden'),
        child: _clock(const ClockSnapshot(hour: 21, minute: 14, dateLabel: '')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 320));
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('bubble-portrait-golden')),
      matchesGoldenFile('goldens/bubble_21_14_390x844.png'),
    );
  });
}

Color? _dotColor(WidgetTester tester, String key) {
  final box = tester.widget<DecoratedBox>(
    find.descendant(
      of: find.byKey(ValueKey(key)),
      matching: find.byType(DecoratedBox),
    ),
  );
  return (box.decoration as BoxDecoration).color;
}

const _snapshot = ClockSnapshot(
  hour: 21,
  minute: 38,
  dateLabel: 'FRI · AUG 28',
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
