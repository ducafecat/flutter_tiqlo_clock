import 'package:shared_preferences/shared_preferences.dart';

abstract class AppAppearanceStorage {
  bool loadPixelUiEnabled();
  Future<void> savePixelUiEnabled(bool value);
}

class PrefsAppAppearanceStorage implements AppAppearanceStorage {
  PrefsAppAppearanceStorage(this._preferences);

  static const pixelUiEnabledKey = 'app.pixel_ui_enabled';

  final SharedPreferences _preferences;

  @override
  bool loadPixelUiEnabled() => _preferences.getBool(pixelUiEnabledKey) ?? true;

  @override
  Future<void> savePixelUiEnabled(bool value) async {
    if (!await _preferences.setBool(pixelUiEnabledKey, value)) {
      throw StateError('Failed to persist the app appearance.');
    }
  }
}

class MemoryAppAppearanceStorage implements AppAppearanceStorage {
  MemoryAppAppearanceStorage({this.pixelUiEnabled = true});

  bool pixelUiEnabled;

  @override
  bool loadPixelUiEnabled() => pixelUiEnabled;

  @override
  Future<void> savePixelUiEnabled(bool value) async {
    pixelUiEnabled = value;
  }
}
