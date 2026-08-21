import 'package:flutter/widgets.dart';
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

    expect(find.text('09:38 PM'), findsOneWidget);

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

    expect(find.text('21:38:00'), findsOneWidget);

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
