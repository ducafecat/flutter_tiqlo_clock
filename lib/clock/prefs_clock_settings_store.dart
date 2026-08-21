import 'package:shared_preferences/shared_preferences.dart';

import 'clock_settings_store.dart';
import 'clock_theme.dart';

class PrefsClockSettingsStore implements ClockSettingsStore {
  PrefsClockSettingsStore(this._prefs);

  static const _formatKey = 'clock.time_format';
  static const _secondsKey = 'clock.show_seconds';
  static const _themeKey = 'clock.theme_id';
  static const _dateKey = 'clock.show_date';

  final SharedPreferences _prefs;

  @override
  TimeFormat? loadTimeFormat() {
    return switch (_prefs.getString(_formatKey)) {
      '12' => TimeFormat.h12,
      '24' => TimeFormat.h24,
      _ => null,
    };
  }

  @override
  bool loadShowSeconds() => _prefs.getBool(_secondsKey) ?? false;

  @override
  void saveTimeFormat(TimeFormat format) {
    _prefs.setString(
      _formatKey,
      format == TimeFormat.h12 ? '12' : '24',
    );
  }

  @override
  void saveShowSeconds(bool value) {
    _prefs.setBool(_secondsKey, value);
  }

  @override
  ClockThemeId loadClockThemeId() {
    return switch (_prefs.getString(_themeKey)) {
      'flip' => ClockThemeId.flip,
      'oled' => ClockThemeId.oled,
      'retro' => ClockThemeId.retro,
      _ => ClockThemeId.minimal,
    };
  }

  @override
  void saveClockThemeId(ClockThemeId id) {
    _prefs.setString(_themeKey, id.name);
  }

  @override
  bool loadShowDate() => _prefs.getBool(_dateKey) ?? false;

  @override
  void saveShowDate(bool value) {
    _prefs.setBool(_dateKey, value);
  }
}
