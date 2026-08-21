import 'clock_theme.dart';

enum TimeFormat { h12, h24 }

abstract class ClockSettingsStore {
  TimeFormat? loadTimeFormat();
  bool loadShowSeconds();
  ClockThemeId loadClockThemeId();
  bool loadShowDate();
  void saveTimeFormat(TimeFormat format);
  void saveShowSeconds(bool value);
  void saveClockThemeId(ClockThemeId id);
  void saveShowDate(bool value);
  StoredSession? loadSession();
  void saveSession(StoredSession? session);
}

class StoredSession {
  const StoredSession({
    required this.kind,
    required this.durationMs,
    required this.startedElapsedMs,
    required this.status,
    this.frozenRemainingMs,
  });

  final String kind;
  final int durationMs;
  final int startedElapsedMs;
  final String status;
  final int? frozenRemainingMs;
}

class MemoryClockSettingsStore implements ClockSettingsStore {
  TimeFormat? timeFormat;
  bool showSeconds = false;
  ClockThemeId clockThemeId = ClockThemeId.minimal;
  bool showDate = false;
  StoredSession? session;

  @override
  TimeFormat? loadTimeFormat() => timeFormat;

  @override
  bool loadShowSeconds() => showSeconds;

  @override
  ClockThemeId loadClockThemeId() => clockThemeId;

  @override
  bool loadShowDate() => showDate;

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
  StoredSession? loadSession() => session;

  @override
  void saveSession(StoredSession? value) {
    session = value;
  }
}
