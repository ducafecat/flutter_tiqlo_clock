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

  testWidgets('tap shows Theme Focus Timer More', (tester) async {
    final container = await _pumpClock(tester);

    expect(find.text('Theme'), findsNothing);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();

    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Focus'), findsOneWidget);
    expect(find.text('Timer'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    expect(find.text('Theme'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('chrome hides after 3 seconds then tap shows again', (
    tester,
  ) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    expect(find.text('Theme'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Theme'), findsNothing);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    expect(find.text('Theme'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('More opens Settings and About', (tester) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();

    if (find.text('More').evaluate().isEmpty) {
      await tester.tap(find.byType(ClockPage));
      await tester.pump();
    }
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('About'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('landscape keeps the same Clock with larger time', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await _pumpClock(tester);
    final portraitSize = tester
        .widget<Text>(find.text('21:38'))
        .style!
        .fontSize!;

    tester.view.physicalSize = const Size(800, 400);
    await tester.pump();

    expect(find.byType(ClockPage), findsOneWidget);
    expect(find.text('21:38'), findsOneWidget);
    final landscapeSize = tester
        .widget<Text>(find.text('21:38'))
        .style!
        .fontSize!;
    expect(landscapeSize, greaterThan(portraitSize));

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('chrome interaction restarts the 3 second hide', (tester) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('Focus'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Theme'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Theme'), findsNothing);

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
