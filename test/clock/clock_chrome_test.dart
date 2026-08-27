import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_ui.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  testWidgets('tap shows Theme and More without Focus or Timer', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final container = await _pumpClock(tester);

    expect(find.text('Theme'), findsNothing);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();

    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Focus'), findsNothing);
    expect(find.text('Timer'), findsNothing);
    expect(find.text('More'), findsOneWidget);
    expect(find.text('Fullscreen'), findsOneWidget);
    expect(find.byKey(const ValueKey('clock-chrome')), findsOneWidget);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    expect(find.text('Theme'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    debugDefaultTargetPlatformOverride = null;
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

  testWidgets('portrait seconds stay inside safe area and above chrome', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);

    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38, 46)),
      locale: const Locale('en'),
      showSeconds: true,
      clockThemeId: ClockThemeId.flip,
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

    final cards = find.byKey(const ValueKey('flip-card-stack'));
    expect(cards, findsNWidgets(3));
    expect(tester.getRect(cards.first).top, greaterThanOrEqualTo(59));

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));

    final toolbarTop = tester
        .getRect(find.byKey(const ValueKey('clock-chrome')))
        .top;
    expect(tester.getRect(cards.at(2)).bottom, lessThanOrEqualTo(toolbarTop));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('More opens Settings and About', (tester) async {
    final container = await _pumpClock(tester);

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();

    expect(find.byType(PixelSwitch), findsOneWidget);
    expect(find.byType(PixelActionTile), findsNWidgets(2));
    expect(find.byType(SwitchListTile), findsNothing);
    expect(find.byType(ListTile), findsNothing);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Back'));
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

  testWidgets('landscape keeps the same Clock with larger time', (
    tester,
  ) async {
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
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    Navigator.pop(tester.element(find.text('Settings')));
    await tester.pumpAndSettle();
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
  return container;
}
