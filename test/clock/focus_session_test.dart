import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/flip_clock_face.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  testWidgets('running chrome is Pause and Stop only', (tester) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    engine.start(SessionKind.focus, const Duration(minutes: 25));
    final container = await _pumpClock(tester, engine: engine);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();

    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Stop'), findsOneWidget);
    expect(find.text('Theme'), findsNothing);
    expect(find.text('Focus'), findsNothing);
    expect(find.text('Timer'), findsNothing);
    expect(find.text('More'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Stop returns to wall time', (tester) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    engine.start(SessionKind.focus, const Duration(minutes: 25));
    final container = await _pumpClock(tester, engine: engine);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('Stop'));
    await tester.pump();

    expect(find.byType(FlipClockFace), findsOneWidget);
    expect(find.text('21'), findsNWidgets(2));
    expect(find.text('38'), findsNWidgets(2));
    expect(find.text('FOCUS'), findsNothing);
    expect(engine.snapshot.session, isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Pause then Resume stay on the same Focus session', (
    tester,
  ) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    engine.start(SessionKind.focus, const Duration(minutes: 25));
    final container = await _pumpClock(tester, engine: engine);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('Pause'));
    await tester.pump();

    expect(find.text('Resume'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('FOCUS'), findsOneWidget);
    expect(engine.snapshot.session!.status, SessionStatus.paused);

    await tester.tap(find.text('Resume'));
    await tester.pump();

    expect(find.text('Pause'), findsOneWidget);
    expect(engine.snapshot.session!.status, SessionStatus.running);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('Complete shows this session and Done, not today stats', (
    tester,
  ) async {
    final clock = FakeClock(wall: DateTime(2026, 8, 20, 21, 38));
    final engine = ClockEngine(clock: clock, locale: const Locale('en'));
    engine.start(SessionKind.focus, const Duration(minutes: 25));
    clock.advanceElapsed(const Duration(minutes: 25));
    engine.snapshot;
    final container = await _pumpClock(tester, engine: engine);

    expect(find.text('COMPLETE'), findsOneWidget);
    expect(find.text('25 min'), findsOneWidget);
    expect(find.textContaining('Today'), findsNothing);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Pause'), findsNothing);

    await tester.tap(find.text('Done'));
    await tester.pump();
    expect(find.byType(FlipClockFace), findsOneWidget);
    expect(find.text('21'), findsNWidgets(2));
    expect(find.text('38'), findsNWidgets(2));
    expect(find.text('COMPLETE'), findsNothing);

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
