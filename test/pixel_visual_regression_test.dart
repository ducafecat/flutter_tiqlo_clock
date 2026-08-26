import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_ui.dart';
import 'package:flutter_tiqlo_clock/features/about/pages/about_page.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_more_sheet.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_theme_sheet.dart';
import 'package:flutter_tiqlo_clock/features/settings/pages/settings_page.dart';
import 'package:flutter_tiqlo_clock/features/welcome/pages/welcome_page.dart';

import 'clock/fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Digital matches the Android visual baseline', (tester) async {
    _configureView(tester, const Size(360, 640), 1);
    await tester.pumpWidget(
      _goldenApp(
        key: const ValueKey('digital-golden'),
        child: ClockFace(
          themeId: ClockThemeId.digital,
          digitalTheme: DigitalThemeId.digital.theme,
          flipPalette: FlipPaletteId.pureDark.palette,
          snapshot: const ClockSnapshot(
            hour: 21,
            minute: 38,
            dateLabel: 'THU · AUG 20',
            showDate: true,
          ),
          landscape: false,
        ),
      ),
    );

    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('digital-golden')),
      matchesGoldenFile('goldens/digital_android_360x640.png'),
    );
  });

  testWidgets('Theme matches the Android visual baseline', (tester) async {
    _configureView(tester, const Size(360, 640), 1);
    await tester.pumpWidget(
      _goldenApp(
        key: const ValueKey('theme-golden'),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: PixelSheet(
            layout: PixelSheetLayout.theme,
            child: ClockThemeSheet(
              clockThemeId: ClockThemeId.flip,
              flipPaletteId: FlipPaletteId.pureDark,
              digitalThemeId: DigitalThemeId.digital,
              onClockThemeSelected: (_) {},
              onFlipPaletteSelected: (_) {},
              onDigitalThemeSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('theme-golden')),
      matchesGoldenFile('goldens/theme_android_360x640.png'),
    );
  });

  testWidgets('More matches the Android visual baseline', (tester) async {
    _configureView(tester, const Size(360, 640), 1);
    await tester.pumpWidget(
      _goldenApp(
        key: const ValueKey('more-golden'),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: PixelSheet(
            child: ClockMoreSheet(
              nightMode: false,
              onNightModeChanged: (_) {},
              onSettings: () {},
              onAbout: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('more-golden')),
      matchesGoldenFile('goldens/more_android_360x640.png'),
    );
  });

  testWidgets('Settings matches the 426 by 923 reference baseline', (
    tester,
  ) async {
    _configureView(tester, const Size(426, 923), 1);
    final container = ProviderContainer(
      overrides: [
        clockEngineProvider.overrideWithValue(
          ClockEngine(clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38))),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _goldenApp(
          key: const ValueKey('settings-golden'),
          child: const SettingsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('settings-golden')),
      matchesGoldenFile('goldens/settings_reference_426x923.png'),
    );
  });

  testWidgets('Welcome matches the Android visual baseline', (tester) async {
    _configureView(tester, const Size(360, 640), 1);
    await tester.pumpWidget(
      ProviderScope(
        child: _goldenApp(
          key: const ValueKey('welcome-golden'),
          child: const WelcomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('welcome-golden')),
      matchesGoldenFile('goldens/welcome_android_360x640.png'),
    );
  });

  testWidgets('About matches the Web visual baseline', (tester) async {
    _configureView(tester, const Size(1440, 900), 2);
    await tester.pumpWidget(
      _goldenApp(key: const ValueKey('about-golden'), child: const AboutPage()),
    );

    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('about-golden')),
      matchesGoldenFile('goldens/about_web_1440x900_2x.png'),
    );
  });
}

Widget _goldenApp({required Key key, required Widget child}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: PixelTheme.darkTheme,
    home: RepaintBoundary(key: key, child: child),
  );
}

void _configureView(
  WidgetTester tester,
  Size logicalSize,
  double devicePixelRatio, {
  double textScale = 1,
}) {
  tester.view.devicePixelRatio = devicePixelRatio;
  tester.view.physicalSize = logicalSize * devicePixelRatio;
  tester.binding.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.binding.platformDispatcher.clearTextScaleFactorTestValue);
}
