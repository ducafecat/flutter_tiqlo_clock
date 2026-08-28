import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../clock/clock_providers.dart';
import '../storage/app_appearance_storage.dart';
import '../ui/app/app_ui_style.dart';

final appAppearanceStorageProvider = Provider<AppAppearanceStorage>((ref) {
  try {
    return PrefsAppAppearanceStorage(ref.watch(sharedPreferencesProvider));
  } catch (_) {
    // Widget tests that inject ClockEngine directly do not need persistence.
    return MemoryAppAppearanceStorage();
  }
});

final appUiStyleProvider = NotifierProvider<AppUiStyleController, AppUiStyle>(
  AppUiStyleController.new,
);

class AppUiStyleController extends Notifier<AppUiStyle> {
  @override
  AppUiStyle build() {
    final enabled = ref.watch(
      appAppearanceStorageProvider.select(
        (storage) => storage.loadPixelUiEnabled(),
      ),
    );
    return enabled ? AppUiStyle.pixel : AppUiStyle.standard;
  }

  bool get pixelUiEnabled => state == AppUiStyle.pixel;

  Future<void> setPixelUiEnabled(bool value) async {
    final next = value ? AppUiStyle.pixel : AppUiStyle.standard;
    if (next == state) return;

    final previous = state;
    state = next;
    try {
      await ref.read(appAppearanceStorageProvider).savePixelUiEnabled(value);
    } catch (_) {
      state = previous;
      rethrow;
    }
  }
}
