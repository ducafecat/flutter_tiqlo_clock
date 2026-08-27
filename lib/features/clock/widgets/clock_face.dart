import 'package:flutter/material.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/digital_theme.dart';
import '../../../clock/flip_palette.dart';
import '../../../clock/clock_theme.dart';
import 'flip_clock_face.dart';

class ClockFace extends StatelessWidget {
  const ClockFace({
    super.key,
    required this.themeId,
    required this.digitalTheme,
    required this.flipPalette,
    required this.snapshot,
    required this.landscape,
  });

  final ClockThemeId themeId;
  final DigitalTheme digitalTheme;
  final FlipPalette flipPalette;
  final ClockSnapshot snapshot;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    final session = snapshot.session;
    if (session != null) {
      return _SessionFace(
        session: session,
        landscape: landscape,
        themeId: themeId,
        digitalTheme: digitalTheme,
        flipPalette: flipPalette,
      );
    }
    return switch (themeId) {
      ClockThemeId.flip => FlipClockFace(
        snapshot: snapshot,
        landscape: landscape,
        palette: flipPalette,
      ),
      ClockThemeId.digital => DigitalClockFace(
        snapshot: snapshot,
        landscape: landscape,
        theme: digitalTheme,
      ),
    };
  }
}

class _SessionFace extends StatelessWidget {
  const _SessionFace({
    required this.session,
    required this.landscape,
    required this.themeId,
    required this.digitalTheme,
    required this.flipPalette,
  });

  final SessionSnapshot session;
  final bool landscape;
  final ClockThemeId themeId;
  final DigitalTheme digitalTheme;
  final FlipPalette flipPalette;

  @override
  Widget build(BuildContext context) {
    final digitColor = themeId == ClockThemeId.flip
        ? flipPalette.digit
        : digitalTheme.digit;
    final secondaryColor = themeId == ClockThemeId.flip
        ? flipPalette.digit.withValues(alpha: 0.7)
        : digitalTheme.secondary;
    final timeSize = switch (themeId) {
      ClockThemeId.digital => landscape ? 136.0 : 88.0,
      ClockThemeId.flip => landscape ? 120.0 : 72.0,
    };
    final complete = session.status == SessionStatus.complete;
    final paused = session.status == SessionStatus.paused;
    final primaryLabel = complete ? 'COMPLETE' : session.remainingLabel;
    final semanticLabel = [
      primaryLabel,
      session.kindLabel,
      if (paused) 'PAUSED',
      if (complete) '${session.duration.inMinutes} min',
    ].join(', ');

    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    primaryLabel,
                    style: TextStyle(
                      color: digitColor,
                      fontFamily: themeId == ClockThemeId.digital
                          ? 'Handjet'
                          : 'Jersey25',
                      fontSize: timeSize,
                      fontWeight: themeId == ClockThemeId.digital
                          ? FontWeight.w700
                          : FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                  if (complete) ...[
                    const SizedBox(height: 16),
                    Text(
                      '${session.duration.inMinutes} min',
                      style: TextStyle(
                        color: secondaryColor,
                        fontFamily: 'PixelifySans',
                        fontSize: 18,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Text(
                        session.kindLabel,
                        style: TextStyle(
                          color: secondaryColor,
                          fontFamily: 'Tiny5',
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                      if (paused)
                        Text(
                          'PAUSED',
                          style: TextStyle(
                            color: secondaryColor,
                            fontFamily: 'Tiny5',
                            fontSize: 18,
                            letterSpacing: 2,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DigitalClockFace extends StatelessWidget {
  const DigitalClockFace({
    super.key,
    required this.snapshot,
    required this.landscape,
    required this.theme,
  });

  final ClockSnapshot snapshot;
  final bool landscape;
  final DigitalTheme theme;

  @override
  Widget build(BuildContext context) {
    final time = [
      snapshot.displayHour,
      snapshot.displayMinute,
      if (snapshot.showSeconds) snapshot.displaySecond,
    ].join(':');
    final fontSize = landscape ? 180.0 : 132.0;

    return Semantics(
      container: true,
      label: snapshot.timeLabel,
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    key: const ValueKey('digital-time-optical-offset'),
                    offset: snapshot.showSeconds
                        ? Offset.zero
                        : _digitalOpticalOffset(time, fontSize),
                    child: Text(
                      time,
                      key: const ValueKey('digital-time'),
                      style: TextStyle(
                        color: theme.digit,
                        fontFamily: 'Handjet',
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  if (snapshot.period != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      snapshot.period!,
                      style: TextStyle(
                        color: theme.secondary,
                        fontFamily: 'Tiny5',
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                  if (snapshot.showDate) ...[
                    const SizedBox(height: 16),
                    Text(
                      snapshot.dateLabel,
                      style: TextStyle(
                        color: theme.secondary,
                        fontFamily: 'PixelifySans',
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Offset _digitalOpticalOffset(String time, double fontSize) {
  const oneCompensation = 0.28;
  final leading = time.startsWith('1') ? -oneCompensation : 0.0;
  final trailing = time.endsWith('1') ? oneCompensation : 0.0;
  return Offset((leading + trailing) * fontSize, 0);
}
