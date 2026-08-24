import 'package:shared_preferences/shared_preferences.dart';

import 'digital_theme.dart';
import 'flip_palette.dart';
import 'clock_settings_store.dart';
import 'clock_theme.dart';

class PrefsClockSettingsStore implements ClockSettingsStore {
  PrefsClockSettingsStore(this._prefs);

  static const _formatKey = 'clock.time_format';
  static const _secondsKey = 'clock.show_seconds';
  static const _themeKey = 'clock.theme_id';
  static const _digitalThemeKey = 'clock.digital_theme_id';
  static const _flipPaletteKey = 'clock.flip_palette_id';
  static const _legacyPaletteKey = 'clock.color_theme_id';
  static const _dateKey = 'clock.show_date';
  static const _leadingZeroKey = 'clock.show_leading_zero';
  static const _sessionKey = 'clock.session';
  static const _completesKey = 'clock.focus_completes';
  static const _soundKey = 'clock.sound';
  static const _vibrationKey = 'clock.vibration';
  static const _notificationAskedKey = 'clock.notification_asked';
  static const _notificationGrantedKey = 'clock.notification_granted';
  static const _nightModeKey = 'clock.night_mode';
  static const _keepAwakeKey = 'clock.keep_awake';

  final SharedPreferences _prefs;
  Future<void> _pendingWrite = Future<void>.value();

  Future<void> _enqueue(Future<bool> Function() write) {
    final operation = _pendingWrite.then((_) async {
      if (!await write()) {
        throw StateError('Failed to persist clock settings.');
      }
    });
    _pendingWrite = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return operation;
  }

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
  Future<void> saveTimeFormat(TimeFormat format) {
    return _enqueue(
      () =>
          _prefs.setString(_formatKey, format == TimeFormat.h12 ? '12' : '24'),
    );
  }

  @override
  Future<void> saveShowSeconds(bool value) {
    return _enqueue(() => _prefs.setBool(_secondsKey, value));
  }

  @override
  ClockThemeId loadClockThemeId() {
    return switch (_prefs.getString(_themeKey)) {
      'flip' => ClockThemeId.flip,
      'digital' => ClockThemeId.digital,
      _ => ClockThemeId.flip,
    };
  }

  @override
  Future<void> saveClockThemeId(ClockThemeId id) {
    return _enqueue(() => _prefs.setString(_themeKey, id.name));
  }

  @override
  DigitalThemeId loadDigitalThemeId() {
    final stored = _prefs.getString(_digitalThemeKey);
    return DigitalThemeId.values.firstWhere(
      (id) => id.name == stored,
      orElse: () => DigitalThemeId.pureDark,
    );
  }

  @override
  Future<void> saveDigitalThemeId(DigitalThemeId id) {
    return _enqueue(() => _prefs.setString(_digitalThemeKey, id.name));
  }

  @override
  FlipPaletteId loadFlipPaletteId() {
    final stored =
        _prefs.getString(_flipPaletteKey) ??
        _prefs.getString(_legacyPaletteKey);
    return FlipPaletteId.values.firstWhere(
      (id) => id.name == stored,
      orElse: () => FlipPaletteId.pureDark,
    );
  }

  @override
  Future<void> saveFlipPaletteId(FlipPaletteId id) {
    return _enqueue(() => _prefs.setString(_flipPaletteKey, id.name));
  }

  @override
  bool loadShowDate() => _prefs.getBool(_dateKey) ?? false;

  @override
  Future<void> saveShowDate(bool value) {
    return _enqueue(() => _prefs.setBool(_dateKey, value));
  }

  @override
  bool loadShowLeadingZero() => _prefs.getBool(_leadingZeroKey) ?? false;

  @override
  Future<void> saveShowLeadingZero(bool value) {
    return _enqueue(() => _prefs.setBool(_leadingZeroKey, value));
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
  Future<void> saveSession(StoredSession? session) {
    if (session == null) {
      return _enqueue(() => _prefs.remove(_sessionKey));
    }
    return _enqueue(
      () => _prefs.setString(
        _sessionKey,
        [
          session.kind,
          session.durationMs,
          session.startedElapsedMs,
          session.status,
          session.frozenRemainingMs ?? '',
          session.recorded ? '1' : '0',
        ].join(','),
      ),
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
  Future<void> saveFocusCompletes(List<StoredFocusComplete> completes) {
    if (completes.isEmpty) {
      return _enqueue(() => _prefs.remove(_completesKey));
    }
    return _enqueue(
      () => _prefs.setString(
        _completesKey,
        completes.map((e) => '${e.localDate},${e.minutes}').join(';'),
      ),
    );
  }

  @override
  bool loadSoundEnabled() => _prefs.getBool(_soundKey) ?? true;

  @override
  bool loadVibrationEnabled() => _prefs.getBool(_vibrationKey) ?? true;

  @override
  Future<void> saveSoundEnabled(bool value) {
    return _enqueue(() => _prefs.setBool(_soundKey, value));
  }

  @override
  Future<void> saveVibrationEnabled(bool value) {
    return _enqueue(() => _prefs.setBool(_vibrationKey, value));
  }

  @override
  bool loadNotificationAsked() =>
      _prefs.getBool(_notificationAskedKey) ?? false;

  @override
  bool loadNotificationGranted() =>
      _prefs.getBool(_notificationGrantedKey) ?? false;

  @override
  Future<void> saveNotificationAsked(bool value) {
    return _enqueue(() => _prefs.setBool(_notificationAskedKey, value));
  }

  @override
  Future<void> saveNotificationGranted(bool value) {
    return _enqueue(() => _prefs.setBool(_notificationGrantedKey, value));
  }

  @override
  bool loadNightMode() => _prefs.getBool(_nightModeKey) ?? false;

  @override
  bool loadKeepAwake() => _prefs.getBool(_keepAwakeKey) ?? true;

  @override
  Future<void> saveNightMode(bool value) {
    return _enqueue(() => _prefs.setBool(_nightModeKey, value));
  }

  @override
  Future<void> saveKeepAwake(bool value) {
    return _enqueue(() => _prefs.setBool(_keepAwakeKey, value));
  }
}
