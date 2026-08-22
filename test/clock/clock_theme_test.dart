import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/flip_clock_face.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  testWidgets('ClockTheme sheet lists Flip and Digital faces', (tester) async {
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
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    expect(find.text('Flip'), findsOneWidget);
    expect(find.text('Digital'), findsOneWidget);

    await tester.tap(find.text('Flip'));
    await tester.pump();

    expect(engine.clockThemeId, ClockThemeId.flip);
    expect(find.byType(ClockPage), findsOneWidget);
    expect(identical(container.read(clockEngineProvider), engine), isTrue);
    expect(find.byType(FlipClockFace), findsOneWidget);

    await tester.tap(find.text('Digital'));
    await tester.pump();
    expect(engine.clockThemeId, ClockThemeId.digital);
    expect(find.byType(ClockPage), findsOneWidget);
    expect(find.byType(DigitalClockFace), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('21:38')).style!.fontFamily,
      'DSEG7Classic',
    );

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
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
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Flip'), findsOneWidget);
    expect(find.text('Digital'), findsOneWidget);

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
          body: FlipClockFace(snapshot: snap(38), landscape: false),
        ),
      ),
    );
    expect(find.text('38'), findsNWidgets(2));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlipClockFace(snapshot: snap(39), landscape: false),
        ),
      ),
    );
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpAndSettle();
    expect(find.text('39'), findsNWidgets(2));
    expect(find.text('38'), findsNothing);
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
      const MaterialApp(
        home: Scaffold(
          body: FlipClockFace(snapshot: snapshot, landscape: true),
        ),
      ),
    );

    expect(find.text('9'), findsNWidgets(2));
    expect(find.text('00'), findsNWidgets(2));
    expect(find.text('AM'), findsOneWidget);
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
      const MaterialApp(
        home: Scaffold(
          body: FlipClockFace(snapshot: snapshot, landscape: false),
        ),
      ),
    );

    final hourCenter = tester.getCenter(find.text('9').first);
    final minuteCenter = tester.getCenter(find.text('00').first);
    expect(hourCenter.dx, closeTo(minuteCenter.dx, 0.1));
    expect(hourCenter.dy, lessThan(minuteCenter.dy));
    expect(tester.takeException(), isNull);
  });
}
