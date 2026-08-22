import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/prefs_clock_settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all nine Digital themes match the product tokens', () {
    const expectedLabels = [
      'Digital',
      'Digital-Blue',
      'Digital-Red',
      'Digital-Amber',
      'Digital-Orange',
      'Pure Dark',
      'Dark',
      'Light',
      'Classic',
    ];
    const expectedColors = {
      DigitalThemeId.digital: [0xFF000000, 0xFF39FF14, 0xFF168B12],
      DigitalThemeId.digitalBlue: [0xFF000000, 0xFF00BFFF, 0xFF087FA8],
      DigitalThemeId.digitalRed: [0xFF000000, 0xFFFF3030, 0xFFA81919],
      DigitalThemeId.digitalAmber: [0xFF000000, 0xFFFFBF00, 0xFF9D7600],
      DigitalThemeId.digitalOrange: [0xFF000000, 0xFFFF7A00, 0xFFA54F00],
      DigitalThemeId.pureDark: [0xFF000000, 0xFFF5F5F5, 0xFF737373],
      DigitalThemeId.dark: [0xFF171717, 0xFFF5F5F5, 0xFF737373],
      DigitalThemeId.light: [0xFFF5F5F5, 0xFF171717, 0xFF737373],
      DigitalThemeId.classic: [0xFF000000, 0xFFFFFFFF, 0xFF666666],
    };

    expect(DigitalThemeId.values, hasLength(9));
    expect(
      DigitalThemeId.values.map((id) => id.label),
      orderedEquals(expectedLabels),
    );
    for (final entry in expectedColors.entries) {
      final theme = entry.key.theme;
      expect(
        [
          theme.background.toARGB32(),
          theme.digit.toARGB32(),
          theme.secondary.toARGB32(),
        ],
        entry.value,
        reason: entry.key.label,
      );
    }

    for (final id in DigitalThemeId.values.take(5)) {
      final glow = id.theme.glow;
      expect(glow, hasLength(2));
      expect(glow[0].blurRadius, 4);
      expect(glow[0].color.a, closeTo(0.8, 0.01));
      expect(glow[1].blurRadius, 14);
      expect(glow[1].color.a, closeTo(0.35, 0.01));
    }
    expect(DigitalThemeId.pureDark.theme.glow, isEmpty);
    expect(DigitalThemeId.dark.theme.glow, isEmpty);
    expect(DigitalThemeId.light.theme.glow, isEmpty);
    expect(DigitalThemeId.classic.theme.glow, hasLength(1));
    expect(DigitalThemeId.classic.theme.glow.single.blurRadius, 3);
  });

  test(
    'Digital theme preference defaults, persists, and rejects invalid IDs',
    () async {
      SharedPreferences.setMockInitialValues({});
      var prefs = await SharedPreferences.getInstance();
      var store = PrefsClockSettingsStore(prefs);

      expect(store.loadDigitalThemeId(), DigitalThemeId.pureDark);
      store.saveDigitalThemeId(DigitalThemeId.digitalBlue);
      expect(store.loadDigitalThemeId(), DigitalThemeId.digitalBlue);
      expect(prefs.getString('clock.digital_theme_id'), 'digitalBlue');

      SharedPreferences.setMockInitialValues({
        'clock.digital_theme_id': 'not-a-theme',
      });
      prefs = await SharedPreferences.getInstance();
      store = PrefsClockSettingsStore(prefs);
      expect(store.loadDigitalThemeId(), DigitalThemeId.pureDark);
    },
  );
}
