import 'clock_theme.dart';

enum TimeFormat { h12, h24 }

abstract class ClockSettingsStore {
  TimeFormat? loadTimeFormat();
  bool loadShowSeconds();
  ClockThemeId loadClockThemeId();
  void saveTimeFormat(TimeFormat format);
  void saveShowSeconds(bool value);
  void saveClockThemeId(ClockThemeId id);
}

class MemoryClockSettingsStore implements ClockSettingsStore {
  TimeFormat? timeFormat;
  bool showSeconds = false;
  ClockThemeId clockThemeId = ClockThemeId.minimal;

  @override
  TimeFormat? loadTimeFormat() => timeFormat;

  @override
  bool loadShowSeconds() => showSeconds;

  @override
  ClockThemeId loadClockThemeId() => clockThemeId;

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
}
