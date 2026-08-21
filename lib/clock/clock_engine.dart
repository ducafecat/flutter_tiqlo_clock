import 'dart:ui';

import 'package:intl/intl.dart';

import 'clock.dart';
import 'clock_settings_store.dart';
import 'clock_theme.dart';

enum SessionKind { focus, timer }

enum SessionStatus { running, paused, complete }

class SessionSnapshot {
  const SessionSnapshot({
    required this.kind,
    required this.remaining,
    required this.status,
  });

  final SessionKind kind;
  final Duration remaining;
  final SessionStatus status;

  String get remainingLabel {
    final total = remaining.inSeconds;
    final minutes = total ~/ 60;
    final seconds = total % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get kindLabel => switch (kind) {
    SessionKind.focus => 'FOCUS',
    SessionKind.timer => 'TIMER',
  };
}

class ClockSnapshot {
  const ClockSnapshot({
    required this.hour,
    required this.minute,
    required this.dateLabel,
    this.second,
    this.period,
    this.showSeconds = false,
    this.is24Hour = true,
    this.showDate = false,
    this.session,
  });

  final int hour;
  final int minute;
  final int? second;
  final String dateLabel;
  final String? period;
  final bool showSeconds;
  final bool is24Hour;
  final bool showDate;
  final SessionSnapshot? session;

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
    bool showDate = false,
    TimeFormat? timeFormat,
    ClockThemeId? clockThemeId,
    ClockSettingsStore? store,
  }) : _store = store,
       _timeFormat = timeFormat ?? store?.loadTimeFormat(),
       showSeconds = store?.loadShowSeconds() ?? showSeconds,
       showDate = store?.loadShowDate() ?? showDate,
       clockThemeId =
           store?.loadClockThemeId() ?? clockThemeId ?? ClockThemeId.minimal,
       _session = _restoreSession(store?.loadSession());

  final Clock clock;
  final Locale locale;
  final bool deviceUses24Hour;
  final ClockSettingsStore? _store;
  bool showSeconds;
  bool showDate;
  ClockThemeId clockThemeId;
  TimeFormat? _timeFormat;
  _LiveSession? _session;

  bool get is24Hour {
    final format =
        _timeFormat ?? (deviceUses24Hour ? TimeFormat.h24 : TimeFormat.h12);
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
      showDate: showDate,
      is24Hour: twentyFour,
      session: _sessionSnapshot(),
    );
  }

  Duration get untilNextWallTick {
    if (_session?.status == SessionStatus.running) {
      final micros = clock.elapsed().inMicroseconds;
      final rem = micros % 1000000;
      if (rem == 0) return const Duration(seconds: 1);
      return Duration(microseconds: 1000000 - rem);
    }
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

  void setShowDate(bool value) {
    showDate = value;
    _store?.saveShowDate(value);
  }

  void setClockTheme(ClockThemeId id) {
    clockThemeId = id;
    _store?.saveClockThemeId(id);
  }

  void start(SessionKind kind, Duration duration) {
    if (_session != null) return;
    _session = _LiveSession(
      kind: kind,
      duration: duration,
      startedElapsed: clock.elapsed(),
      status: SessionStatus.running,
    );
    _persistSession();
  }

  void pause() {
    final session = _session;
    if (session == null || session.status != SessionStatus.running) return;
    session.frozenRemaining = session.remainingAt(clock.elapsed());
    session.status = SessionStatus.paused;
    _persistSession();
  }

  void resume() {
    final session = _session;
    if (session == null || session.status != SessionStatus.paused) return;
    final remaining = session.frozenRemaining ?? Duration.zero;
    session.startedElapsed = clock.elapsed() - (session.duration - remaining);
    session.status = SessionStatus.running;
    session.frozenRemaining = null;
    _persistSession();
  }

  void stop() {
    _session = null;
    _persistSession();
  }

  SessionSnapshot? _sessionSnapshot() {
    final session = _session;
    if (session == null) return null;
    return SessionSnapshot(
      kind: session.kind,
      remaining: session.remainingAt(clock.elapsed()),
      status: session.status,
    );
  }

  void _persistSession() {
    final session = _session;
    if (session == null) {
      _store?.saveSession(null);
      return;
    }
    _store?.saveSession(
      StoredSession(
        kind: session.kind.name,
        durationMs: session.duration.inMilliseconds,
        startedElapsedMs: session.startedElapsed.inMilliseconds,
        status: session.status.name,
        frozenRemainingMs: session.frozenRemaining?.inMilliseconds,
      ),
    );
  }

  static _LiveSession? _restoreSession(StoredSession? stored) {
    if (stored == null) return null;
    final kind = SessionKind.values.asNameMap()[stored.kind];
    final status = SessionStatus.values.asNameMap()[stored.status];
    if (kind == null || status == null) return null;
    return _LiveSession(
      kind: kind,
      duration: Duration(milliseconds: stored.durationMs),
      startedElapsed: Duration(milliseconds: stored.startedElapsedMs),
      status: status,
      frozenRemaining: stored.frozenRemainingMs == null
          ? null
          : Duration(milliseconds: stored.frozenRemainingMs!),
    );
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

class _LiveSession {
  _LiveSession({
    required this.kind,
    required this.duration,
    required this.startedElapsed,
    required this.status,
    this.frozenRemaining,
  });

  final SessionKind kind;
  final Duration duration;
  Duration startedElapsed;
  SessionStatus status;
  Duration? frozenRemaining;

  Duration remainingAt(Duration elapsed) {
    if (status == SessionStatus.paused) {
      return frozenRemaining ?? Duration.zero;
    }
    if (status == SessionStatus.complete) return Duration.zero;
    final spent = elapsed - startedElapsed;
    final left = duration - spent;
    if (left <= Duration.zero) return Duration.zero;
    return left;
  }
}
