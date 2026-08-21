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
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
