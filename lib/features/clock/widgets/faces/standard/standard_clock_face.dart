import 'package:flutter/material.dart';

import '../../../../../clock/clock_engine.dart';
import '../../../../../clock/clock_theme.dart';
import '../../../../../clock/digital_theme.dart';
import '../../../../../clock/flip_palette.dart';
import 'standard_digital_clock_face.dart';
import 'standard_flip_clock_face.dart';
import 'standard_session_face.dart';

class StandardClockFace extends StatelessWidget {
  const StandardClockFace({
    super.key,
    required this.themeId,
    required this.digitalThemeId,
    required this.flipPaletteId,
    required this.snapshot,
    required this.landscape,
  });

  final ClockThemeId themeId;
  final DigitalThemeId digitalThemeId;
  final FlipPaletteId flipPaletteId;
  final ClockSnapshot snapshot;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    final digitalTheme = digitalThemeId.theme;
    final flipPalette = _standardPalette(flipPaletteId);
    final session = snapshot.session;
    if (session != null) {
      return StandardSessionFace(session: session, landscape: landscape);
    }
    return switch (themeId) {
      ClockThemeId.flip => StandardFlipClockFace(
        snapshot: snapshot,
        landscape: landscape,
        palette: flipPalette,
      ),
      ClockThemeId.digital => StandardDigitalClockFace(
        snapshot: snapshot,
        landscape: landscape,
        theme: digitalTheme,
      ),
    };
  }
}

FlipPalette _standardPalette(FlipPaletteId id) {
  if (id != FlipPaletteId.pureDark) return id.palette;
  return const FlipPalette(
    background: Color(0xFF000000),
    cardTop: Color(0xFF101010),
    cardBottom: Color(0xFF0B0B0B),
    digit: Color(0xFFF5F5F5),
    divider: Color(0xFF000000),
  );
}
