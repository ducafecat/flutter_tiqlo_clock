import 'package:flutter/widgets.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/clock_theme.dart';
import '../../../clock/digital_theme.dart';
import '../../../clock/flip_palette.dart';
import '../../../core/ui/app/app_ui_style.dart';
import 'faces/pixel/pixel_clock_face.dart';
import 'faces/pixel/pixel_digital_clock_face.dart';
import 'faces/pixel/pixel_flip_clock_face.dart';
import 'faces/standard/standard_clock_face.dart';

export 'faces/pixel/pixel_digital_clock_face.dart';
export 'faces/pixel/pixel_flip_clock_face.dart';
export 'faces/standard/standard_digital_clock_face.dart';
export 'faces/standard/standard_flip_clock_face.dart';

/// Clock 表盘的唯一 seam。具体布局、绘制和动画完全留在各自 adapter 内。
class ClockFace extends StatelessWidget {
  const ClockFace({
    super.key,
    required this.style,
    required this.themeId,
    required this.digitalThemeId,
    required this.flipPaletteId,
    required this.snapshot,
    required this.landscape,
  });

  final AppUiStyle style;
  final ClockThemeId themeId;
  final DigitalThemeId digitalThemeId;
  final FlipPaletteId flipPaletteId;
  final ClockSnapshot snapshot;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      AppUiStyle.pixel => PixelClockFace(
        key: const ValueKey('pixel-clock-face'),
        themeId: themeId,
        digitalThemeId: digitalThemeId,
        flipPaletteId: flipPaletteId,
        snapshot: snapshot,
        landscape: landscape,
      ),
      AppUiStyle.standard => StandardClockFace(
        key: const ValueKey('standard-clock-face'),
        themeId: themeId,
        digitalThemeId: digitalThemeId,
        flipPaletteId: flipPaletteId,
        snapshot: snapshot,
        landscape: landscape,
      ),
    };
  }
}

// 兼容现有调用方；新测试应直接使用明确的 Pixel 类型。
typedef FlipClockFace = PixelFlipClockFace;
typedef DigitalClockFace = PixelDigitalClockFace;
