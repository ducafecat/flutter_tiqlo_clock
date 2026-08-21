import 'package:shared_preferences/shared_preferences.dart';

import 'clock_settings_store.dart';

class PrefsClockSettingsStore implements ClockSettingsStore {
  PrefsClockSettingsStore(this._prefs);

  static const _formatKey = 'clock.time_format';
  static const _secondsKey = 'clock.show_seconds';

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
}
