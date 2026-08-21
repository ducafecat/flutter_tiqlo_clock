import 'dart:ui';

import 'package:intl/intl.dart';

import 'clock.dart';

class ClockSnapshot {
  const ClockSnapshot({
    required this.hour,
    required this.minute,
    required this.dateLabel,
  });

  final int hour;
  final int minute;
  final String dateLabel;

  String get timeLabel =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

class ClockEngine {
  ClockEngine({required this.clock, this.locale = const Locale('en')});

  final Clock clock;
  final Locale locale;

  ClockSnapshot get snapshot {
    final now = clock.wallNow();
    return ClockSnapshot(
      hour: now.hour,
      minute: now.minute,
      dateLabel: _dateLabel(now),
    );
  }

  Duration get untilNextWallTick {
    final now = clock.wallNow();
    final nextMinute = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    ).add(const Duration(minutes: 1));
    return nextMinute.difference(now);
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
