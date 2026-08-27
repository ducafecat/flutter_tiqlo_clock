import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/clock/prefs_clock_settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all ten Flip palettes match the product tokens', () {
    const expected = {
      FlipPaletteId.pureDark: [
        0xFF000000,
        0xFF181818,
        0xFF151515,
        0xFFF5F5F5,
        0xFF000000,
      ],
      FlipPaletteId.dark: [
        0xFF121212,
        0xFF292929,
        0xFF222222,
        0xFFF5F5F5,
        0xFF111111,
      ],
      FlipPaletteId.light: [
        0xFFEEEEEE,
        0xFFFFFFFF,
        0xFFF4F4F4,
        0xFF111111,
        0xFFD0D0D0,
      ],
      FlipPaletteId.green: [
        0xFF07140D,
        0xFF18864A,
        0xFF14713E,
        0xFFFFFFFF,
        0x4D000000,
      ],
      FlipPaletteId.blue: [
        0xFF07111F,
        0xFF2563EB,
        0xFF1D4ED8,
        0xFFFFFFFF,
        0x4D000000,
      ],
      FlipPaletteId.red: [
        0xFF190707,
        0xFFDC2626,
        0xFFB91C1C,
        0xFFFFFFFF,
        0x4D000000,
      ],
      FlipPaletteId.orange: [
        0xFF1A0C05,
        0xFFEA580C,
        0xFFC2410C,
        0xFFFFFFFF,
        0x4D000000,
      ],
      FlipPaletteId.yellow: [
        0xFF171305,
        0xFFFACC15,
        0xFFEAB308,
        0xFF111111,
        0x40000000,
      ],
      FlipPaletteId.purple: [
        0xFF10091A,
        0xFF7C3AED,
        0xFF6D28D9,
        0xFFFFFFFF,
        0x4D000000,
      ],
      FlipPaletteId.pink: [
        0xFF190A11,
        0xFFDB2777,
        0xFFBE185D,
        0xFFFFFFFF,
        0x4D000000,
      ],
    };

    expect(FlipPaletteId.values, hasLength(10));
    for (final entry in expected.entries) {
      final palette = entry.key.palette;
      expect(
        [
          palette.background.toARGB32(),
          palette.cardTop.toARGB32(),
          palette.cardBottom.toARGB32(),
          palette.digit.toARGB32(),
          palette.divider.toARGB32(),
        ],
        entry.value,
        reason: entry.key.label,
      );
    }
  });

  test(
    'Flip palette preference defaults and persists to the new key',
    () async {
      SharedPreferences.setMockInitialValues({});
      var prefs = await SharedPreferences.getInstance();
      var store = PrefsClockSettingsStore(prefs);

      expect(store.loadFlipPaletteId(), FlipPaletteId.pureDark);

      await store.saveFlipPaletteId(FlipPaletteId.blue);
      expect(store.loadFlipPaletteId(), FlipPaletteId.blue);
      expect(prefs.getString('clock.flip_palette_id'), 'blue');
    },
  );

  test('new Flip palette key wins over the legacy key', () async {
    SharedPreferences.setMockInitialValues({
      'clock.flip_palette_id': 'pink',
      'clock.color_theme_id': 'blue',
    });
    final prefs = await SharedPreferences.getInstance();
    final store = PrefsClockSettingsStore(prefs);

    expect(store.loadFlipPaletteId(), FlipPaletteId.pink);
  });

  test('legacy palette key migrates on the next save', () async {
    SharedPreferences.setMockInitialValues({'clock.color_theme_id': 'blue'});
    final prefs = await SharedPreferences.getInstance();
    final store = PrefsClockSettingsStore(prefs);

    expect(store.loadFlipPaletteId(), FlipPaletteId.blue);
    await store.saveFlipPaletteId(FlipPaletteId.purple);
    expect(prefs.getString('clock.flip_palette_id'), 'purple');
  });

  test('invalid Flip palette value falls back to Pure Dark', () async {
    SharedPreferences.setMockInitialValues({
      'clock.flip_palette_id': 'not-a-theme',
      'clock.color_theme_id': 'blue',
    });
    final prefs = await SharedPreferences.getInstance();
    final store = PrefsClockSettingsStore(prefs);

    expect(store.loadFlipPaletteId(), FlipPaletteId.pureDark);
  });
}
