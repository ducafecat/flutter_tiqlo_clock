import 'package:flutter/material.dart';

import '../../../../../clock/clock_engine.dart';
import '../../../../../clock/digital_theme.dart';

class StandardDigitalClockFace extends StatelessWidget {
  const StandardDigitalClockFace({
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
                    key: const ValueKey('standard-digital-time-optical-offset'),
                    offset: snapshot.showSeconds
                        ? Offset.zero
                        : standardDigitalOpticalOffset(time, fontSize),
                    child: Text(
                      time,
                      key: const ValueKey('standard-digital-time'),
                      style: TextStyle(
                        color: theme.digit,
                        fontFamily: 'DSEG7Classic',
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
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
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
      ),
    );
  }
}

Offset standardDigitalOpticalOffset(String time, double fontSize) {
  const oneCompensation = 0.28;
  final leading = time.startsWith('1') ? -oneCompensation : 0.0;
  final trailing = time.endsWith('1') ? oneCompensation : 0.0;
  return Offset((leading + trailing) * fontSize, 0);
}
