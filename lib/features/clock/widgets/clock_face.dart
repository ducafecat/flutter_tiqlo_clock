import 'package:flutter/material.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/clock_theme.dart';
import 'flip_clock_face.dart';

class ClockFace extends StatelessWidget {
  const ClockFace({
    super.key,
    required this.themeId,
    required this.snapshot,
    required this.landscape,
  });

  final ClockThemeId themeId;
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
      );
    }
    return switch (themeId) {
      ClockThemeId.minimal => MinimalClockFace(
        snapshot: snapshot,
        landscape: landscape,
      ),
      ClockThemeId.flip => FlipClockFace(
        snapshot: snapshot,
        landscape: landscape,
      ),
      ClockThemeId.oled => OledClockFace(
        snapshot: snapshot,
        landscape: landscape,
      ),
      ClockThemeId.retro => RetroClockFace(
        snapshot: snapshot,
        landscape: landscape,
      ),
    };
  }
}

class _SessionFace extends StatelessWidget {
  const _SessionFace({
    required this.session,
    required this.landscape,
    required this.themeId,
  });

  final SessionSnapshot session;
  final bool landscape;
  final ClockThemeId themeId;

  @override
  Widget build(BuildContext context) {
    final timeSize = switch (themeId) {
      ClockThemeId.oled => landscape ? 160.0 : 96.0,
      ClockThemeId.retro => landscape ? 112.0 : 68.0,
      _ => landscape ? 120.0 : 72.0,
    };
    final labelSize = landscape ? 24.0 : 18.0;
    final timeColor = switch (themeId) {
      ClockThemeId.oled => const Color(0xFFB0B0B0),
      ClockThemeId.retro => const Color(0xFF39FF14),
      _ => Colors.white,
    };
    final labelColor = switch (themeId) {
      ClockThemeId.oled => const Color(0xFF5A5A5A),
      ClockThemeId.retro => const Color(0xFF1F8A0E),
      _ => Colors.white70,
    };
    final fontWeight = switch (themeId) {
      ClockThemeId.oled => FontWeight.w200,
      ClockThemeId.retro => FontWeight.w600,
      _ => FontWeight.w300,
    };
    final letterSpacing = switch (themeId) {
      ClockThemeId.oled => 8.0,
      ClockThemeId.retro => 4.0,
      _ => 2.0,
    };
    final fontFamily = themeId == ClockThemeId.retro ? 'Courier' : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                session.remainingLabel,
                style: TextStyle(
                  color: timeColor,
                  fontSize: timeSize,
                  fontWeight: fontWeight,
                  letterSpacing: letterSpacing,
                  fontFamily: fontFamily,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                session.kindLabel,
                style: TextStyle(
                  color: labelColor,
                  fontSize: labelSize,
                  fontWeight: FontWeight.w400,
                  letterSpacing: letterSpacing,
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MinimalClockFace extends StatelessWidget {
  const MinimalClockFace({
    super.key,
    required this.snapshot,
    required this.landscape,
  });

  final ClockSnapshot snapshot;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    return _DigitalFace(
      snapshot: snapshot,
      timeSize: landscape ? 120 : 72,
      dateSize: landscape ? 24 : 18,
      timeColor: Colors.white,
      dateColor: Colors.white70,
      fontWeight: FontWeight.w300,
      letterSpacing: 2,
    );
  }
}

class OledClockFace extends StatelessWidget {
  const OledClockFace({
    super.key,
    required this.snapshot,
    required this.landscape,
  });

  final ClockSnapshot snapshot;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    return _DigitalFace(
      snapshot: snapshot,
      timeSize: landscape ? 160 : 96,
      dateSize: landscape ? 20 : 14,
      timeColor: const Color(0xFFB0B0B0),
      dateColor: const Color(0xFF5A5A5A),
      fontWeight: FontWeight.w200,
      letterSpacing: 8,
    );
  }
}

class RetroClockFace extends StatelessWidget {
  const RetroClockFace({
    super.key,
    required this.snapshot,
    required this.landscape,
  });

  final ClockSnapshot snapshot;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    return _DigitalFace(
      snapshot: snapshot,
      timeSize: landscape ? 112 : 68,
      dateSize: landscape ? 22 : 16,
      timeColor: const Color(0xFF39FF14),
      dateColor: const Color(0xFF1F8A0E),
      fontWeight: FontWeight.w600,
      letterSpacing: 4,
      fontFamily: 'Courier',
    );
  }
}

class _DigitalFace extends StatelessWidget {
  const _DigitalFace({
    required this.snapshot,
    required this.timeSize,
    required this.dateSize,
    required this.timeColor,
    required this.dateColor,
    required this.fontWeight,
    required this.letterSpacing,
    this.fontFamily,
  });

  final ClockSnapshot snapshot;
  final double timeSize;
  final double dateSize;
  final Color timeColor;
  final Color dateColor;
  final FontWeight fontWeight;
  final double letterSpacing;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                snapshot.timeLabel,
                style: TextStyle(
                  color: timeColor,
                  fontSize: timeSize,
                  fontWeight: fontWeight,
                  letterSpacing: letterSpacing,
                  fontFamily: fontFamily,
                ),
              ),
              if (snapshot.showDate) ...[
                const SizedBox(height: 16),
                Text(
                  snapshot.dateLabel,
                  style: TextStyle(
                    color: dateColor,
                    fontSize: dateSize,
                    fontWeight: FontWeight.w400,
                    letterSpacing: letterSpacing,
                    fontFamily: fontFamily,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
