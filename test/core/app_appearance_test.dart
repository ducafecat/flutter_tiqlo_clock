import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/core/providers/app_appearance_provider.dart';
import 'package:flutter_tiqlo_clock/core/storage/app_appearance_storage.dart';
import 'package:flutter_tiqlo_clock/core/ui/app/app_ui_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Pixel UI defaults to enabled and uses the documented preference key',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final storage = PrefsAppAppearanceStorage(preferences);

      expect(storage.loadPixelUiEnabled(), isTrue);

      await storage.savePixelUiEnabled(false);

      expect(
        preferences.getBool(PrefsAppAppearanceStorage.pixelUiEnabledKey),
        isFalse,
      );
      expect(storage.loadPixelUiEnabled(), isFalse);
    },
  );

  test('AppUiStyle restores and persists both appearance directions', () async {
    final storage = MemoryAppAppearanceStorage(pixelUiEnabled: false);
    final container = ProviderContainer(
      overrides: [appAppearanceStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    expect(container.read(appUiStyleProvider), AppUiStyle.standard);

    await container.read(appUiStyleProvider.notifier).setPixelUiEnabled(true);
    expect(container.read(appUiStyleProvider), AppUiStyle.pixel);
    expect(storage.pixelUiEnabled, isTrue);

    await container.read(appUiStyleProvider.notifier).setPixelUiEnabled(false);
    expect(container.read(appUiStyleProvider), AppUiStyle.standard);
    expect(storage.pixelUiEnabled, isFalse);
  });
}
