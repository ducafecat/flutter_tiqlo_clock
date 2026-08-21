import 'dart:ui';

import 'package:intl/intl.dart';

import 'clock.dart';
import 'clock_settings_store.dart';
import 'clock_theme.dart';

class ClockSnapshot {
  const ClockSnapshot({
    required this.hour,
    required this.minute,
    required this.dateLabel,
    this.second,
    this.period,
    this.showSeconds = false,
    this.is24Hour = true,
  });

  final int hour;
  final int minute;
  final int? second;
  final String dateLabel;
  final String? period;
  final bool showSeconds;
  final bool is24Hour;

  String get timeLabel {
    final h = is24Hour ? hour : _hour12(hour);
    final hh = h.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    final time = showSeconds
        ? '$hh:$mm:${(second ?? 0).toString().padLeft(2, '0')}'
        : '$hh:$mm';
    if (is24Hour) return time;
    return '$time $period';
  }

  String get displayHour {
    final h = is24Hour ? hour : _hour12(hour);
    return h.toString().padLeft(2, '0');
  }

  String get displayMinute => minute.toString().padLeft(2, '0');

  String get displaySecond => (second ?? 0).toString().padLeft(2, '0');

  static int _hour12(int hour24) {
    final mod = hour24 % 12;
    return mod == 0 ? 12 : mod;
  }
}

class ClockEngine {
  ClockEngine({
    required this.clock,
    this.locale = const Locale('en'),
    this.deviceUses24Hour = true,
    bool showSeconds = false,
    TimeFormat? timeFormat,
    ClockThemeId? clockThemeId,
    ClockSettingsStore? store,
  }) : _store = store,
       _timeFormat = timeFormat ?? store?.loadTimeFormat(),
       showSeconds = store?.loadShowSeconds() ?? showSeconds,
       clockThemeId =
           store?.loadClockThemeId() ?? clockThemeId ?? ClockThemeId.minimal;

  final Clock clock;
  final Locale locale;
  final bool deviceUses24Hour;
  final ClockSettingsStore? _store;
  bool showSeconds;
  ClockThemeId clockThemeId;
  TimeFormat? _timeFormat;

  bool get is24Hour {
    final format = _timeFormat ??
        (deviceUses24Hour ? TimeFormat.h24 : TimeFormat.h12);
    return format == TimeFormat.h24;
  }

  ClockSnapshot get snapshot {
    final now = clock.wallNow();
    final twentyFour = is24Hour;
    return ClockSnapshot(
      hour: now.hour,
      minute: now.minute,
      second: now.second,
      dateLabel: _dateLabel(now),
      period: twentyFour ? null : (now.hour < 12 ? 'AM' : 'PM'),
      showSeconds: showSeconds,
      is24Hour: twentyFour,
    );
  }

  Duration get untilNextWallTick {
    final now = clock.wallNow();
    if (showSeconds || clockThemeId == ClockThemeId.flip) {
      final nextSecond = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second,
      ).add(const Duration(seconds: 1));
      return nextSecond.difference(now);
    }
    final nextMinute = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    ).add(const Duration(minutes: 1));
    return nextMinute.difference(now);
  }

  void setTimeFormat(TimeFormat format) {
    _timeFormat = format;
    _store?.saveTimeFormat(format);
  }

  void setShowSeconds(bool value) {
    showSeconds = value;
    _store?.saveShowSeconds(value);
  }

  void setClockTheme(ClockThemeId id) {
    clockThemeId = id;
    _store?.saveClockThemeId(id);
  }

  String _dateLabel(DateTime now) {
    final language = locale.languageCode;
    final weekday = DateFormat('EEE', language).format(now).toUpperCase();
    if (language == 'zh') {
      return '$weekday · ${DateFormat('M月d日', language).format(now)}';
    }
    final monthDay = DateFormat('MMM d', language).format(now).toUpperCase();
    return '$weekday · $monthDay';
  }
}
