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
    final glow = themeId == ClockThemeId.digital
        ? digitalTheme.glow
        : const <Shadow>[];
    final timeSize = switch (themeId) {
      ClockThemeId.digital => landscape ? 136.0 : 88.0,
      ClockThemeId.flip => landscape ? 120.0 : 72.0,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                session.status == SessionStatus.complete
                    ? 'COMPLETE'
                    : session.remainingLabel,
                style: TextStyle(
                  color: digitColor,
                  shadows: glow,
                  fontSize: timeSize,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              if (session.status == SessionStatus.complete) ...[
                const SizedBox(height: 16),
                Text(
                  '${session.duration.inMinutes} min',
                  style: TextStyle(color: secondaryColor, fontSize: 18),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                session.kindLabel,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
            ],
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Semantics(
            label: snapshot.timeLabel,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  key: const ValueKey('digital-time-optical-offset'),
                  offset: _digitalOpticalOffset(time, fontSize),
                  child: Text(
                    time,
                    key: const ValueKey('digital-time'),
                    style: TextStyle(
                      color: theme.digit,
                      fontFamily: 'DSEG7Classic',
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      shadows: theme.glow,
                    ),
                  ),
                ),
                if (snapshot.period != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    snapshot.period!,
                    style: TextStyle(
                      color: theme.secondary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
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
    );
  }
}

Offset _digitalOpticalOffset(String time, double fontSize) {
  const oneCompensation = 0.28;
  final leading = time.startsWith('1') ? -oneCompensation : 0.0;
  final trailing = time.endsWith('1') ? oneCompensation : 0.0;
  return Offset((leading + trailing) * fontSize, 0);
}
