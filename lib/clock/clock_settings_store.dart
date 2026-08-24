import 'digital_theme.dart';
import 'flip_palette.dart';
import 'clock_theme.dart';

enum TimeFormat { h12, h24 }

abstract class ClockSettingsStore {
  TimeFormat? loadTimeFormat();
  bool loadShowSeconds();
  ClockThemeId loadClockThemeId();
  DigitalThemeId loadDigitalThemeId();
  FlipPaletteId loadFlipPaletteId();
  bool loadShowDate();
  bool loadShowLeadingZero();
  Future<void> saveTimeFormat(TimeFormat format);
  Future<void> saveShowSeconds(bool value);
  Future<void> saveClockThemeId(ClockThemeId id);
  Future<void> saveDigitalThemeId(DigitalThemeId id);
  Future<void> saveFlipPaletteId(FlipPaletteId id);
  Future<void> saveShowDate(bool value);
  Future<void> saveShowLeadingZero(bool value);
  StoredSession? loadSession();
  Future<void> saveSession(StoredSession? session);
  List<StoredFocusComplete> loadFocusCompletes();
  Future<void> saveFocusCompletes(List<StoredFocusComplete> completes);
  bool loadSoundEnabled();
  bool loadVibrationEnabled();
  Future<void> saveSoundEnabled(bool value);
  Future<void> saveVibrationEnabled(bool value);
  bool loadNotificationAsked();
  bool loadNotificationGranted();
  Future<void> saveNotificationAsked(bool value);
  Future<void> saveNotificationGranted(bool value);
  bool loadNightMode();
  bool loadKeepAwake();
  Future<void> saveNightMode(bool value);
  Future<void> saveKeepAwake(bool value);
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
  ClockThemeId clockThemeId = ClockThemeId.flip;
  DigitalThemeId digitalThemeId = DigitalThemeId.pureDark;
  FlipPaletteId flipPaletteId = FlipPaletteId.pureDark;
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
  DigitalThemeId loadDigitalThemeId() => digitalThemeId;

  @override
  FlipPaletteId loadFlipPaletteId() => flipPaletteId;

  @override
  bool loadShowDate() => showDate;

  @override
  bool loadShowLeadingZero() => showLeadingZero;

  @override
  Future<void> saveTimeFormat(TimeFormat format) async {
    timeFormat = format;
  }

  @override
  Future<void> saveShowSeconds(bool value) async {
    showSeconds = value;
  }

  @override
  Future<void> saveClockThemeId(ClockThemeId id) async {
    clockThemeId = id;
  }

  @override
  Future<void> saveDigitalThemeId(DigitalThemeId id) async {
    digitalThemeId = id;
  }

  @override
  Future<void> saveFlipPaletteId(FlipPaletteId id) async {
    flipPaletteId = id;
  }

  @override
  Future<void> saveShowDate(bool value) async {
    showDate = value;
  }

  @override
  Future<void> saveShowLeadingZero(bool value) async {
    showLeadingZero = value;
  }

  @override
  StoredSession? loadSession() => session;

  @override
  Future<void> saveSession(StoredSession? value) async {
    session = value;
  }

  @override
  List<StoredFocusComplete> loadFocusCompletes() => List.of(completes);

  @override
  Future<void> saveFocusCompletes(List<StoredFocusComplete> value) async {
    completes = List.of(value);
  }

  @override
  bool loadSoundEnabled() => soundEnabled;

  @override
  bool loadVibrationEnabled() => vibrationEnabled;

  @override
  Future<void> saveSoundEnabled(bool value) async {
    soundEnabled = value;
  }

  @override
  Future<void> saveVibrationEnabled(bool value) async {
    vibrationEnabled = value;
  }

  @override
  bool loadNotificationAsked() => notificationAsked;

  @override
  bool loadNotificationGranted() => notificationGranted;

  @override
  Future<void> saveNotificationAsked(bool value) async {
    notificationAsked = value;
  }

  @override
  Future<void> saveNotificationGranted(bool value) async {
    notificationGranted = value;
  }

  @override
  bool loadNightMode() => nightMode;

  @override
  bool loadKeepAwake() => keepAwake;

  @override
  Future<void> saveNightMode(bool value) async {
    nightMode = value;
  }

  @override
  Future<void> saveKeepAwake(bool value) async {
    keepAwake = value;
  }
}
