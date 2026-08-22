import 'clock_theme.dart';

enum TimeFormat { h12, h24 }

abstract class ClockSettingsStore {
  TimeFormat? loadTimeFormat();
  bool loadShowSeconds();
  ClockThemeId loadClockThemeId();
  bool loadShowDate();
  bool loadShowLeadingZero();
  void saveTimeFormat(TimeFormat format);
  void saveShowSeconds(bool value);
  void saveClockThemeId(ClockThemeId id);
  void saveShowDate(bool value);
  void saveShowLeadingZero(bool value);
  StoredSession? loadSession();
  void saveSession(StoredSession? session);
  List<StoredFocusComplete> loadFocusCompletes();
  void saveFocusCompletes(List<StoredFocusComplete> completes);
  bool loadSoundEnabled();
  bool loadVibrationEnabled();
  void saveSoundEnabled(bool value);
  void saveVibrationEnabled(bool value);
  bool loadNotificationAsked();
  bool loadNotificationGranted();
  void saveNotificationAsked(bool value);
  void saveNotificationGranted(bool value);
  bool loadNightMode();
  bool loadKeepAwake();
  void saveNightMode(bool value);
  void saveKeepAwake(bool value);
}

class StoredSession {
  const StoredSession({
    required this.kind,
    required this.durationMs,
    required this.startedElapsedMs,
    required this.status,
    this.frozenRemainingMs,
    this.recorded = false,
  });

  final String kind;
  final int durationMs;
  final int startedElapsedMs;
  final String status;
  final int? frozenRemainingMs;
  final bool recorded;
}

class StoredFocusComplete {
  const StoredFocusComplete({required this.localDate, required this.minutes});

  final String localDate;
  final int minutes;
}

class MemoryClockSettingsStore implements ClockSettingsStore {
  TimeFormat? timeFormat;
  bool showSeconds = false;
  ClockThemeId clockThemeId = ClockThemeId.minimal;
  bool showDate = false;
  bool showLeadingZero = false;
  StoredSession? session;
  List<StoredFocusComplete> completes = [];
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool notificationAsked = false;
  bool notificationGranted = false;
  bool nightMode = false;
  bool keepAwake = true;

  @override
  TimeFormat? loadTimeFormat() => timeFormat;

  @override
  bool loadShowSeconds() => showSeconds;

  @override
  ClockThemeId loadClockThemeId() => clockThemeId;

  @override
  bool loadShowDate() => showDate;

  @override
  bool loadShowLeadingZero() => showLeadingZero;

  @override
  void saveTimeFormat(TimeFormat format) {
    timeFormat = format;
  }

  @override
  void saveShowSeconds(bool value) {
    showSeconds = value;
  }

  @override
  void saveClockThemeId(ClockThemeId id) {
    clockThemeId = id;
  }

  @override
  void saveShowDate(bool value) {
    showDate = value;
  }

  @override
  void saveShowLeadingZero(bool value) {
    showLeadingZero = value;
  }

  @override
  StoredSession? loadSession() => session;

  @override
  void saveSession(StoredSession? value) {
    session = value;
  }

  @override
  List<StoredFocusComplete> loadFocusCompletes() => List.of(completes);

  @override
  void saveFocusCompletes(List<StoredFocusComplete> value) {
    completes = List.of(value);
  }

  @override
  bool loadSoundEnabled() => soundEnabled;

  @override
  bool loadVibrationEnabled() => vibrationEnabled;

  @override
  void saveSoundEnabled(bool value) {
    soundEnabled = value;
  }

  @override
  void saveVibrationEnabled(bool value) {
    vibrationEnabled = value;
  }

  @override
  bool loadNotificationAsked() => notificationAsked;

  @override
  bool loadNotificationGranted() => notificationGranted;

  @override
  void saveNotificationAsked(bool value) {
    notificationAsked = value;
  }

  @override
  void saveNotificationGranted(bool value) {
    notificationGranted = value;
  }

  @override
  bool loadNightMode() => nightMode;

  @override
  bool loadKeepAwake() => keepAwake;

  @override
  void saveNightMode(bool value) {
    nightMode = value;
  }

  @override
  void saveKeepAwake(bool value) {
    keepAwake = value;
  }
}
