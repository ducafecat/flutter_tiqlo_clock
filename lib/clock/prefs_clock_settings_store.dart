import 'package:shared_preferences/shared_preferences.dart';

import 'clock_settings_store.dart';
import 'clock_theme.dart';

class PrefsClockSettingsStore implements ClockSettingsStore {
  PrefsClockSettingsStore(this._prefs);

  static const _formatKey = 'clock.time_format';
  static const _secondsKey = 'clock.show_seconds';
  static const _themeKey = 'clock.theme_id';
  static const _dateKey = 'clock.show_date';
  static const _sessionKey = 'clock.session';
  static const _completesKey = 'clock.focus_completes';
  static const _soundKey = 'clock.sound';
  static const _vibrationKey = 'clock.vibration';
  static const _notificationAskedKey = 'clock.notification_asked';
  static const _notificationGrantedKey = 'clock.notification_granted';

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
    _prefs.setString(_formatKey, format == TimeFormat.h12 ? '12' : '24');
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

  @override
  StoredSession? loadSession() {
    final raw = _prefs.getString(_sessionKey);
    if (raw == null) return null;
    final parts = raw.split(',');
    if (parts.length < 4) return null;
    return StoredSession(
      kind: parts[0],
      durationMs: int.parse(parts[1]),
      startedElapsedMs: int.parse(parts[2]),
      status: parts[3],
      frozenRemainingMs: parts.length > 4 && parts[4].isNotEmpty
          ? int.parse(parts[4])
          : null,
      recorded: parts.length > 5 && parts[5] == '1',
    );
  }

  @override
  void saveSession(StoredSession? session) {
    if (session == null) {
      _prefs.remove(_sessionKey);
      return;
    }
    _prefs.setString(
      _sessionKey,
      [
        session.kind,
        session.durationMs,
        session.startedElapsedMs,
        session.status,
        session.frozenRemainingMs ?? '',
        session.recorded ? '1' : '0',
      ].join(','),
    );
  }

  @override
  List<StoredFocusComplete> loadFocusCompletes() {
    final raw = _prefs.getString(_completesKey);
    if (raw == null || raw.isEmpty) return [];
    return [
      for (final item in raw.split(';'))
        if (item.contains(','))
          StoredFocusComplete(
            localDate: item.split(',')[0],
            minutes: int.parse(item.split(',')[1]),
          ),
    ];
  }

  @override
  void saveFocusCompletes(List<StoredFocusComplete> completes) {
    if (completes.isEmpty) {
      _prefs.remove(_completesKey);
      return;
    }
    _prefs.setString(
      _completesKey,
      completes.map((e) => '${e.localDate},${e.minutes}').join(';'),
    );
  }

  @override
  bool loadSoundEnabled() => _prefs.getBool(_soundKey) ?? true;

  @override
  bool loadVibrationEnabled() => _prefs.getBool(_vibrationKey) ?? true;

  @override
  void saveSoundEnabled(bool value) {
    _prefs.setBool(_soundKey, value);
  }

  @override
  void saveVibrationEnabled(bool value) {
    _prefs.setBool(_vibrationKey, value);
  }

  @override
  bool loadNotificationAsked() =>
      _prefs.getBool(_notificationAskedKey) ?? false;

  @override
  bool loadNotificationGranted() =>
      _prefs.getBool(_notificationGrantedKey) ?? false;

  @override
  void saveNotificationAsked(bool value) {
    _prefs.setBool(_notificationAskedKey, value);
  }

  @override
  void saveNotificationGranted(bool value) {
    _prefs.setBool(_notificationGrantedKey, value);
  }
}
