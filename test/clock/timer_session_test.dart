import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  testWidgets('Timer sheet lists presets and Custom', (tester) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('Timer'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);
    expect(find.textContaining('Today'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('starting Timer shows remaining mm:ss and TIMER', (tester) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('Timer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('01:00'), findsOneWidget);
    expect(find.text('TIMER'), findsOneWidget);
    expect(find.byType(ClockPage), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Pause Resume Stop behave like Focus', (tester) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    engine.start(SessionKind.timer, const Duration(minutes: 5));
    final container = await _pumpClock(tester, engine: engine);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Stop'), findsOneWidget);
    expect(find.text('Focus'), findsNothing);
    expect(find.text('Timer'), findsNothing);

    await tester.tap(find.text('Pause'));
    await tester.pump();
    expect(find.text('Resume'), findsOneWidget);
    expect(engine.snapshot.session!.status, SessionStatus.paused);
    expect(engine.snapshot.session!.kind, SessionKind.timer);

    await tester.tap(find.text('Resume'));
    await tester.pump();
    expect(find.text('Pause'), findsOneWidget);
    expect(engine.snapshot.session!.status, SessionStatus.running);

    await tester.tap(find.text('Stop'));
    await tester.pump();
    expect(find.text('21:38'), findsOneWidget);
    expect(find.text('TIMER'), findsNothing);
    expect(engine.snapshot.session, isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Timer Complete does not count today Focus', (
    tester,
  ) async {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, locale: const Locale('en'));
    engine.start(SessionKind.timer, const Duration(minutes: 5));
    clock.advanceElapsed(const Duration(minutes: 5));
    engine.snapshot;
    final container = await _pumpClock(tester, engine: engine);

    expect(find.text('COMPLETE'), findsOneWidget);
    expect(find.text('5 min'), findsOneWidget);
    expect(find.text('TIMER'), findsOneWidget);
    expect(engine.snapshot.todayFocusCount, 0);
    expect(engine.snapshot.todayFocusMinutes, 0);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('Done'));
    await tester.pump();
    expect(find.text('21:38'), findsOneWidget);
    expect(engine.snapshot.todayFocusCount, 0);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('running Focus cannot open Timer', (tester) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    engine.start(SessionKind.focus, const Duration(minutes: 25));
    final container = await _pumpClock(tester, engine: engine);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    expect(find.text('Timer'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('running Timer cannot open Focus', (tester) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    engine.start(SessionKind.timer, const Duration(minutes: 5));
    final container = await _pumpClock(tester, engine: engine);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    expect(find.text('Focus'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Custom Timer is 1 to 180 minutes in steps of 1', (tester) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('Timer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.min, 1);
    expect(slider.max, 180);
    expect(slider.divisions, 179);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}

Future<ProviderContainer> _pumpClock(
  WidgetTester tester, {
  ClockEngine? engine,
}) async {
  final clockEngine =
      engine ??
      ClockEngine(
        clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
        locale: const Locale('en'),
      );
  final container = ProviderContainer(
    overrides: [clockEngineProvider.overrideWithValue(clockEngine)],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const MyApp()),
  );
  return container;
}
