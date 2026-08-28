import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/core/providers/app_appearance_provider.dart';
import 'package:flutter_tiqlo_clock/core/storage/app_appearance_storage.dart';
import 'package:flutter_tiqlo_clock/core/ui/app/app_ui_style.dart';
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_switch.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/pixel/pixel_clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/standard/standard_clock_face.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  testWidgets(
    'More switches both directions in place without changing clock state',
    (tester) async {
      final engine = ClockEngine(
        clock: FakeClock(wall: DateTime(2026, 8, 28, 21, 38, 42)),
        locale: const Locale('en'),
        clockThemeId: ClockThemeId.digital,
        digitalThemeId: DigitalThemeId.digitalBlue,
        flipPaletteId: FlipPaletteId.orange,
      );
      final storage = MemoryAppAppearanceStorage();
      final container = ProviderContainer(
        overrides: [
          clockEngineProvider.overrideWithValue(engine),
          appAppearanceStorageProvider.overrideWithValue(storage),
        ],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MyApp(showOnboarding: false, showWelcome: false),
        ),
      );

      expect(find.byType(PixelClockFace), findsOneWidget);
      final before = engine.snapshot;

      await tester.tap(find.byType(ClockPage));
      await tester.pump();
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(PixelSwitch, 'Pixel UI'), findsOneWidget);

      await tester.tap(find.widgetWithText(PixelSwitch, 'Pixel UI'));
      await tester.pumpAndSettle();

      expect(container.read(appUiStyleProvider), AppUiStyle.standard);
      expect(storage.pixelUiEnabled, isFalse);
      expect(find.byType(StandardClockFace), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNWidgets(2));
      expect(find.text('Settings'), findsOneWidget);
      _expectClockStateUnchanged(engine, before);

      await tester.tap(find.widgetWithText(SwitchListTile, 'Pixel UI'));
      await tester.pumpAndSettle();

      expect(container.read(appUiStyleProvider), AppUiStyle.pixel);
      expect(storage.pixelUiEnabled, isTrue);
      expect(find.byType(PixelClockFace), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      _expectClockStateUnchanged(engine, before);

      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
    },
  );

  testWidgets(
    'closing More while appearance persistence is pending never calls stale setState',
    (tester) async {
      final engine = ClockEngine(
        clock: FakeClock(wall: DateTime(2026, 8, 28, 21, 38, 42)),
        locale: const Locale('en'),
      );
      final storage = _DelayedAppearanceStorage();
      final container = ProviderContainer(
        overrides: [
          clockEngineProvider.overrideWithValue(engine),
          appAppearanceStorageProvider.overrideWithValue(storage),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MyApp(showOnboarding: false, showWelcome: false),
        ),
      );
      await tester.tap(find.byType(ClockPage));
      await tester.pump();
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(PixelSwitch, 'Pixel UI'));
      await tester.pump();
      expect(find.widgetWithText(SwitchListTile, 'Pixel UI'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pump();
      storage.completeSave();
      await tester.pump();

      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
    },
  );

  testWidgets('Standard Clock More closes from the blank area', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 28, 21, 38, 42)),
      locale: const Locale('en'),
    );
    final storage = MemoryAppAppearanceStorage(pixelUiEnabled: false);
    final container = ProviderContainer(
      overrides: [
        clockEngineProvider.overrideWithValue(engine),
        appAppearanceStorageProvider.overrideWithValue(storage),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(showOnboarding: false, showWelcome: false),
      ),
    );

    await tester.tap(find.byType(ClockPage));
    await tester.pump();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.tapAt(const Offset(195, 100));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}

class _DelayedAppearanceStorage implements AppAppearanceStorage {
  final _save = Completer<void>();

  @override
  bool loadPixelUiEnabled() => true;

  @override
  Future<void> savePixelUiEnabled(bool value) => _save.future;

  void completeSave() => _save.complete();
}

void _expectClockStateUnchanged(ClockEngine engine, ClockSnapshot before) {
  expect(engine.clockThemeId, ClockThemeId.digital);
  expect(engine.digitalThemeId, DigitalThemeId.digitalBlue);
  expect(engine.flipPaletteId, FlipPaletteId.orange);
  final after = engine.snapshot;
  expect(after.hour, before.hour);
  expect(after.minute, before.minute);
  expect(after.second, before.second);
  expect(after.session, before.session);
}
