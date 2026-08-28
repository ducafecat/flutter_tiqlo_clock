import 'package:flutter/material.dart';

import '../../../../../clock/clock_engine.dart';
import '../../../../../clock/clock_theme.dart';
import '../../../../../clock/digital_theme.dart';
import '../../../../../clock/flip_palette.dart';
import 'pixel_digital_clock_face.dart';
import 'pixel_flip_clock_face.dart';
import 'pixel_session_face.dart';

class PixelClockFace extends StatelessWidget {
  const PixelClockFace({
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
    final flipPalette = flipPaletteId.palette;
    final session = snapshot.session;
    if (session != null) {
      return PixelSessionFace(
        session: session,
        landscape: landscape,
        themeId: themeId,
        digitalTheme: digitalTheme,
        flipPalette: flipPalette,
      );
    }
    return switch (themeId) {
      ClockThemeId.flip => PixelFlipClockFace(
        snapshot: snapshot,
        landscape: landscape,
        palette: flipPalette,
      ),
      ClockThemeId.digital => PixelDigitalClockFace(
        snapshot: snapshot,
        landscape: landscape,
        theme: digitalTheme,
      ),
    };
  }
}
