import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/bubble_palette.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/clock/clock_settings_store.dart';
import 'package:flutter_tiqlo_clock/clock/prefs_clock_settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('empty preferences use the product defaults', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = PrefsClockSettingsStore(prefs);

    expect(store.loadTimeFormat(), TimeFormat.h12);
    expect(store.loadShowLeadingZero(), isFalse);
    expect(store.loadShowSeconds(), isFalse);
    expect(store.loadShowDate(), isFalse);
    expect(store.loadKeepAwake(), isTrue);
    expect(store.loadNightMode(), isFalse);
    expect(store.loadSoundEnabled(), isTrue);
    expect(store.loadVibrationEnabled(), isTrue);
  });

  test('Bubble clock style and palette persist independently', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = PrefsClockSettingsStore(prefs);

    await store.saveClockThemeId(ClockThemeId.bubble);
    await store.saveBubblePaletteId(BubblePaletteId.greenMix);
    await store.saveFlipPaletteId(FlipPaletteId.purple);
    await store.saveDigitalThemeId(DigitalThemeId.digitalRed);

    final restored = PrefsClockSettingsStore(prefs);
    expect(restored.loadClockThemeId(), ClockThemeId.bubble);
    expect(restored.loadBubblePaletteId(), BubblePaletteId.greenMix);
    expect(restored.loadFlipPaletteId(), FlipPaletteId.purple);
    expect(restored.loadDigitalThemeId(), DigitalThemeId.digitalRed);
  });
}
