import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_ui.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_theme_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final bodyFont = FontLoader('PixelifySans')
      ..addFont(rootBundle.load('fonts/PixelifySans-Regular.ttf'));
    await bodyFont.load();
  });

  testWidgets('Theme matches the Android visual baseline', (tester) async {
    _configureView(tester, const Size(360, 640), 1);
    await tester.pumpWidget(
      _goldenApp(
        key: const ValueKey('theme-golden'),
        child: const Align(
          alignment: Alignment.bottomCenter,
          child: PixelSheet(
            layout: PixelSheetLayout.theme,
            child: ClockThemeSheet(
              clockThemeId: ClockThemeId.flip,
              flipPaletteId: FlipPaletteId.pureDark,
              digitalThemeId: DigitalThemeId.digital,
              onClockThemeSelected: _ignoreClockTheme,
              onFlipPaletteSelected: _ignoreFlipPalette,
              onDigitalThemeSelected: _ignoreDigitalTheme,
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

  testWidgets('Theme sheet matches the 470dp reference crop', (tester) async {
    _configureView(tester, const Size(470.5, 836), 2);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: PixelTheme.darkTheme,
        home: const Scaffold(
          backgroundColor: Colors.black,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: RepaintBoundary(
              key: ValueKey('theme-sheet-reference-golden'),
              child: PixelSheet(
                layout: PixelSheetLayout.theme,
                child: ClockThemeSheet(
                  clockThemeId: ClockThemeId.flip,
                  flipPaletteId: FlipPaletteId.pureDark,
                  digitalThemeId: DigitalThemeId.digital,
                  onClockThemeSelected: _ignoreClockTheme,
                  onFlipPaletteSelected: _ignoreFlipPalette,
                  onDigitalThemeSelected: _ignoreDigitalTheme,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('theme-sheet-reference-golden')),
      matchesGoldenFile('goldens/theme_reference_470x836_2x.png'),
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
  double devicePixelRatio,
) {
  tester.view.devicePixelRatio = devicePixelRatio;
  tester.view.physicalSize = logicalSize * devicePixelRatio;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

void _ignoreClockTheme(ClockThemeId _) {}

void _ignoreFlipPalette(FlipPaletteId _) {}

void _ignoreDigitalTheme(DigitalThemeId _) {}
