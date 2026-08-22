import 'dart:ui';

import 'package:intl/intl.dart';

import 'clock.dart';
import 'digital_theme.dart';
import 'flip_palette.dart';
import 'clock_settings_store.dart';
import 'clock_theme.dart';

enum SessionKind { focus, timer }

enum SessionStatus { running, paused, complete }

class SessionSnapshot {
  const SessionSnapshot({
    required this.kind,
    required this.remaining,
    required this.status,
    required this.duration,
  });

  final SessionKind kind;
  final Duration remaining;
  final SessionStatus status;
  final Duration duration;

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
    this.showLeadingZero = false,
    this.nightMode = false,
    this.session,
    this.todayFocusCount = 0,
    this.todayFocusMinutes = 0,
  });

  final int hour;
  final int minute;
  final int? second;
  final String dateLabel;
  final String? period;
  final bool showSeconds;
  final bool is24Hour;
  final bool showDate;
  final bool showLeadingZero;
  final bool nightMode;
  final SessionSnapshot? session;
  final int todayFocusCount;
  final int todayFocusMinutes;

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
    return showLeadingZero ? h.toString().padLeft(2, '0') : h.toString();
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
    bool showLeadingZero = false,
    TimeFormat? timeFormat,
    ClockThemeId? clockThemeId,
    DigitalThemeId? digitalThemeId,
    FlipPaletteId? flipPaletteId,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
    bool nightMode = false,
    bool keepAwake = true,
    ClockSettingsStore? store,
  }) : _store = store,
       _timeFormat = timeFormat ?? store?.loadTimeFormat(),
       showSeconds = store?.loadShowSeconds() ?? showSeconds,
       showDate = store?.loadShowDate() ?? showDate,
       showLeadingZero = store?.loadShowLeadingZero() ?? showLeadingZero,
       clockThemeId =
           store?.loadClockThemeId() ?? clockThemeId ?? ClockThemeId.digital,
       digitalThemeId =
           store?.loadDigitalThemeId() ??
           digitalThemeId ??
           DigitalThemeId.pureDark,
       flipPaletteId =
           store?.loadFlipPaletteId() ??
           flipPaletteId ??
           FlipPaletteId.pureDark,
       soundEnabled = store?.loadSoundEnabled() ?? soundEnabled,
       vibrationEnabled = store?.loadVibrationEnabled() ?? vibrationEnabled,
       nightMode = store?.loadNightMode() ?? nightMode,
       keepAwake = store?.loadKeepAwake() ?? keepAwake,
       _completes = List.of(store?.loadFocusCompletes() ?? const []) {
    _session = _restoreSession(store?.loadSession());
    _pauseIfRebooted();
  }

  final Clock clock;
  final Locale locale;
  final bool deviceUses24Hour;
  final ClockSettingsStore? _store;
  bool showSeconds;
  bool showDate;
  bool showLeadingZero;
  ClockThemeId clockThemeId;
  DigitalThemeId digitalThemeId;
  FlipPaletteId flipPaletteId;
  bool soundEnabled;
  bool vibrationEnabled;
  bool nightMode;
  bool keepAwake;
  TimeFormat? _timeFormat;
  _LiveSession? _session;
  final List<StoredFocusComplete> _completes;

  bool get is24Hour {
    final format =
        _timeFormat ?? (deviceUses24Hour ? TimeFormat.h24 : TimeFormat.h12);
    return format == TimeFormat.h24;
  }

  ClockSnapshot get snapshot {
    final now = clock.wallNow();
    final twentyFour = is24Hour;
    final session = _sessionSnapshot();
    final today = _todayStats(now);
    final night = nightMode;
    return ClockSnapshot(
      hour: now.hour,
      minute: now.minute,
      second: now.second,
      dateLabel: _dateLabel(now),
      period: twentyFour ? null : (now.hour < 12 ? 'AM' : 'PM'),
      showSeconds: showSeconds && !night,
      showDate: showDate && !night,
      showLeadingZero: showLeadingZero,
      nightMode: night,
      is24Hour: twentyFour,
      session: session,
      todayFocusCount: today.count,
      todayFocusMinutes: today.minutes,
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
    if (showSeconds && !nightMode) {
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

  void setShowLeadingZero(bool value) {
    showLeadingZero = value;
    _store?.saveShowLeadingZero(value);
  }

  void setClockTheme(ClockThemeId id) {
    clockThemeId = id;
    _store?.saveClockThemeId(id);
  }

  void setDigitalTheme(DigitalThemeId id) {
    digitalThemeId = id;
    _store?.saveDigitalThemeId(id);
  }

  void setFlipPalette(FlipPaletteId id) {
    flipPaletteId = id;
    _store?.saveFlipPaletteId(id);
  }

  void setSoundEnabled(bool value) {
    soundEnabled = value;
    _store?.saveSoundEnabled(value);
  }

  void setVibrationEnabled(bool value) {
    vibrationEnabled = value;
    _store?.saveVibrationEnabled(value);
  }

  void setNightMode(bool value) {
    nightMode = value;
    _store?.saveNightMode(value);
  }

  void setKeepAwake(bool value) {
    keepAwake = value;
    _store?.saveKeepAwake(value);
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

  void acknowledgeComplete() {
    if (_session?.status != SessionStatus.complete) return;
    _session = null;
    _persistSession();
  }

  SessionSnapshot? _sessionSnapshot() {
    final session = _session;
    if (session == null) return null;
    _completeIfDue();
    if (_session?.status == SessionStatus.running) {
      _persistSession();
    }
    return SessionSnapshot(
      kind: session.kind,
      remaining: session.remainingAt(clock.elapsed()),
      status: session.status,
      duration: session.duration,
    );
  }

  void _pauseIfRebooted() {
    final session = _session;
    if (session == null || session.status != SessionStatus.running) return;
    if (clock.elapsed() >= session.startedElapsed) return;
    session.status = SessionStatus.paused;
    session.frozenRemaining ??= session.duration;
    _persistSession();
  }

  void _completeIfDue() {
    final session = _session;
    if (session == null || session.status != SessionStatus.running) return;
    if (session.remainingAt(clock.elapsed()) > Duration.zero) return;
    session.status = SessionStatus.complete;
    if (session.kind == SessionKind.focus && !session.recorded) {
      session.recorded = true;
      _completes.add(
        StoredFocusComplete(
          localDate: _localDate(clock.wallNow()),
          minutes: session.duration.inMinutes,
        ),
      );
      _store?.saveFocusCompletes(_completes);
    }
    _persistSession();
  }

  ({int count, int minutes}) _todayStats(DateTime now) {
    final date = _localDate(now);
    var count = 0;
    var minutes = 0;
    for (final item in _completes) {
      if (item.localDate != date) continue;
      count += 1;
      minutes += item.minutes;
    }
    return (count: count, minutes: minutes);
  }

  static String _localDate(DateTime now) {
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
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
        frozenRemainingMs:
            (session.frozenRemaining ?? session.remainingAt(clock.elapsed()))
                .inMilliseconds,
        recorded: session.recorded,
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
      recorded: stored.recorded,
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
    this.recorded = false,
  });

  final SessionKind kind;
  final Duration duration;
  Duration startedElapsed;
  SessionStatus status;
  Duration? frozenRemaining;
  bool recorded;

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
