enum TimeFormat { h12, h24 }

abstract class ClockSettingsStore {
  TimeFormat? loadTimeFormat();
  bool loadShowSeconds();
  void saveTimeFormat(TimeFormat format);
  void saveShowSeconds(bool value);
}

class MemoryClockSettingsStore implements ClockSettingsStore {
  TimeFormat? timeFormat;
  bool showSeconds = false;

  @override
  TimeFormat? loadTimeFormat() => timeFormat;

  @override
  bool loadShowSeconds() => showSeconds;

  @override
  void saveTimeFormat(TimeFormat format) {
    timeFormat = format;
  }

  @override
  void saveShowSeconds(bool value) {
    showSeconds = value;
  }
}
