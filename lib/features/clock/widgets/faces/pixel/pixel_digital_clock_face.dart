import 'package:flutter/material.dart';

import '../../../../../clock/clock_engine.dart';
import '../../../../../clock/digital_theme.dart';

class PixelDigitalClockFace extends StatelessWidget {
  const PixelDigitalClockFace({
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
                    offset: Offset.zero,
                    child: Text(
                      time,
                      key: const ValueKey('digital-time'),
                      style: TextStyle(
                        color: theme.digit,
                        fontFamily: 'DotGothic16',
                        fontSize: fontSize,
                        fontWeight: FontWeight.w400,
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
