import 'package:flutter/material.dart';

import '../../../../../clock/clock_engine.dart';
import '../../../../../clock/clock_theme.dart';
import '../../../../../clock/digital_theme.dart';
import '../../../../../clock/flip_palette.dart';

class PixelSessionFace extends StatelessWidget {
  const PixelSessionFace({
    super.key,
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
                    key: const ValueKey('session-primary-label'),
                    style: TextStyle(
                      color: digitColor,
                      fontFamily: themeId == ClockThemeId.digital
                          ? 'DotGothic16'
                          : 'Jersey25',
                      fontSize: timeSize,
                      fontWeight: FontWeight.w400,
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
