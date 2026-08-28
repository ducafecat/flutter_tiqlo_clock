import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/pixel/pixel_flip_clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/standard/standard_flip_clock_face.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final font = FontLoader('FlipClock')
      ..addFont(rootBundle.load('fonts/standard/RobotoCondensed-Bold.ttf'));
    await font.load();
  });

  testWidgets('Standard Flip portrait includes seconds, AM/PM, and date', (
    tester,
  ) async {
    _configureView(tester, const Size(390, 844));
    await tester.pumpWidget(
      _golden(
        const StandardFlipClockFace(
          snapshot: ClockSnapshot(
            hour: 9,
            minute: 41,
            second: 12,
            period: 'AM',
            dateLabel: 'FRI · AUG 28',
            showSeconds: true,
            is24Hour: false,
            showDate: true,
          ),
          landscape: false,
          palette: FlipPalette(
            background: Color(0xFF000000),
            cardTop: Color(0xFF101010),
            cardBottom: Color(0xFF0B0B0B),
            digit: Color(0xFFF5F5F5),
            divider: Color(0xFF000000),
          ),
        ),
      ),
    );

    expect(find.byType(StandardFlipClockFace), findsOneWidget);
    expect(find.byType(PixelFlipClockFace), findsNothing);
    expect(find.byKey(const ValueKey('flip-card-stack')), findsNWidgets(3));
    expect(
      tester.getSemantics(find.byType(StandardFlipClockFace)),
      matchesSemantics(label: '09:41:12 AM'),
    );
    await expectLater(
      find.byKey(const ValueKey('standard-flip-golden')),
      matchesGoldenFile('goldens/standard_flip_portrait.png'),
    );
  });

  testWidgets('Standard Flip landscape captures the 1-second midpoint', (
    tester,
  ) async {
    _configureView(tester, const Size(900, 500));
    Widget face(int minute, int second) => StandardFlipClockFace(
      snapshot: ClockSnapshot(
        hour: 21,
        minute: minute,
        second: second,
        dateLabel: 'FRI · AUG 28',
        showSeconds: true,
        showDate: true,
      ),
      landscape: true,
      palette: FlipPaletteId.orange.palette,
    );

    await tester.pumpWidget(_golden(face(41, 12)));
    await tester.pumpWidget(_golden(face(42, 13)));
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byKey(const ValueKey('standard-flip-golden')),
      matchesGoldenFile('goldens/standard_flip_landscape_midpoint.png'),
    );
  });

  testWidgets('Standard Flip replaces values when animations are disabled', (
    tester,
  ) async {
    Widget face(int minute) => MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: StandardFlipClockFace(
        snapshot: ClockSnapshot(hour: 21, minute: minute, dateLabel: ''),
        landscape: true,
        palette: FlipPaletteId.pureDark.palette,
      ),
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: face(41))));
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: face(42))));
    await tester.pump();

    expect(find.byKey(const ValueKey('flip-flap')), findsNothing);
    expect(find.text('42'), findsNWidgets(2));
    expect(find.text('41'), findsNothing);
  });
}

Widget _golden(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'FlipClock'),
    home: Scaffold(
      backgroundColor: Colors.black,
      body: RepaintBoundary(
        key: const ValueKey('standard-flip-golden'),
        child: child,
      ),
    ),
  );
}

void _configureView(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}
