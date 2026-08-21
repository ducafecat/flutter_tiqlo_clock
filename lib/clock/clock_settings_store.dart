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
}

class MemoryClockSettingsStore implements ClockSettingsStore {
  TimeFormat? timeFormat;
  bool showSeconds = false;
  ClockThemeId clockThemeId = ClockThemeId.minimal;
  bool showDate = false;

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
}
