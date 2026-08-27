import 'package:flutter/material.dart';

import 'pixel_shape.dart';

/// 以 Theme 参考稿定稿的 Pixel 组件视觉常量。
///
/// 底部弹层和选择/操作控件共享这些颜色与几何，业务页面不再自行复制。
abstract final class PixelThemeSheetStyle {
  static const panelShadow = Color(0xFF050505);
  static const panelFrame = Color(0xFF0B0C0B);
  static const panelOutline = Color(0xFF454642);
  static const panelOutlineHighlight = Color(0xFF5B5C57);
  static const panelTop = Color(0xFF1C1D1C);
  static const panelCenter = Color(0xFF20211F);
  static const panelBottom = Color(0xFF171817);

  static const optionDepthShade = Color(0xFF151614);
  static const optionFrame = Color(0xFF111210);
  static const optionOutline = Color(0xFF41423E);
  static const optionOutlineSelected = Color(0xFFB8B9B5);
  static const optionSurface = Color(0xFF1D1E1D);
  static const optionSurfaceSelected = Color(0xFF242624);
  static const optionSurfaceHover = Color(0xFF252624);
  static const optionSurfacePressed = Color(0xFF171817);

  static const text = Color(0xFFB8B9B6);
  static const textSelected = Color(0xFFC8C9C6);
  static const check = Color(0xFFD7D8D4);
  static const handle = Color(0xFFB5AF9C);
  static const handleHighlight = Color(0xFFD0CAB7);
  static const handleShade = Color(0xFF777264);

  /// Sheet 使用连续圆角，避免像素切角在大尺寸屏幕上形成明显缺口。
  static const sheetRadius = 22.0;
  static const sheetOutlineRadius = 20.0;
  static const sheetInnerRadius = 18.0;
  static const optionCut = 6.0;
  static const optionDepth = 1.0;
  static const optionGap = 4.0;
  static const sheetInset = 4.0;
  static const contentInset = 24.0;
  static const themeContentInset = 12.0;
  static const headerHeight = 50.0;
  static const bottomInset = 40.0;
  static const themeBottomInset = 88.0;
  static const themeScrollViewportBottomInset = 24.0;
  static const themeLandscapeMaxHeightFactor = 0.9;
}

class PixelThemeSheetFrame extends StatelessWidget {
  const PixelThemeSheetFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _ThemeSheetPainter(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PixelThemeSheetStyle.sheetRadius),
        child: child,
      ),
    );
  }
}

class PixelThemeDragHandle extends StatelessWidget {
  const PixelThemeDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      key: ValueKey('pixel-theme-drag-handle'),
      width: 44,
      height: 8,
      child: CustomPaint(painter: _ThemeDragHandlePainter()),
    );
  }
}

class PixelThemeOptionFrame extends StatelessWidget {
  const PixelThemeOptionFrame({
    super.key,
    required this.child,
    required this.selected,
    required this.focused,
    required this.hovered,
    required this.pressed,
    required this.enabled,
    required this.focusColor,
  });

  final Widget child;
  final bool selected;
  final bool focused;
  final bool hovered;
  final bool pressed;
  final bool enabled;
  final Color focusColor;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: pressed ? const Offset(0, 2) : Offset.zero,
      child: CustomPaint(
        painter: _ThemeOptionPainter(
          selected: selected,
          focused: focused,
          hovered: hovered,
          pressed: pressed,
          enabled: enabled,
          focusColor: focusColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: PixelThemeSheetStyle.optionDepth,
            bottom: PixelThemeSheetStyle.optionDepth,
          ),
          child: ClipPath(
            clipper: const PixelCutClipper(PixelThemeSheetStyle.optionCut),
            child: child,
          ),
        ),
      ),
    );
  }
}

class PixelThemeCheck extends StatelessWidget {
  const PixelThemeCheck({super.key, required this.color, this.size = 24});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _ThemeCheckPainter(color),
      ),
    );
  }
}

class _ThemeSheetPainter extends CustomPainter {
  const _ThemeSheetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    final rect = Offset.zero & size;
    final outerRRect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(PixelThemeSheetStyle.sheetRadius),
    );

    canvas.drawRRect(
      outerRRect.shift(const Offset(2, 2)),
      paint..color = PixelThemeSheetStyle.panelShadow,
    );
    canvas.drawRRect(
      outerRRect,
      paint..color = PixelThemeSheetStyle.panelFrame,
    );

    final outlineRect = Rect.fromLTRB(2, 2, size.width - 2, size.height - 2);
    final outlineRRect = RRect.fromRectAndRadius(
      outlineRect,
      const Radius.circular(PixelThemeSheetStyle.sheetOutlineRadius),
    );
    canvas.drawRRect(
      outlineRRect,
      paint..color = PixelThemeSheetStyle.panelOutline,
    );

    final innerRect = Rect.fromLTRB(4, 4, size.width - 4, size.height - 4);
    final innerRRect = RRect.fromRectAndRadius(
      innerRect,
      const Radius.circular(PixelThemeSheetStyle.sheetInnerRadius),
    );
    paint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        PixelThemeSheetStyle.panelTop,
        PixelThemeSheetStyle.panelCenter,
        PixelThemeSheetStyle.panelBottom,
      ],
      stops: [0, 0.42, 1],
    ).createShader(innerRect);
    canvas.drawRRect(innerRRect, paint);
    paint.shader = null;

    paint.shader = const RadialGradient(
      center: Alignment(0, -0.08),
      radius: 1.05,
      colors: [Color(0x382F302D), Color(0x00171817)],
      stops: [0, 1],
    ).createShader(innerRect);
    canvas.drawRRect(innerRRect, paint);
    paint.shader = null;

    final highlight = Path()
      ..moveTo(20, 2)
      ..lineTo(size.width - 20, 2)
      ..lineTo(size.width - 16, 4);
    canvas.drawPath(
      highlight,
      paint
        ..color = PixelThemeSheetStyle.panelOutlineHighlight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ThemeDragHandlePainter extends CustomPainter {
  const _ThemeDragHandlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    canvas.drawRect(
      const Rect.fromLTWH(0, 4, 44, 4),
      paint..color = PixelThemeSheetStyle.panelShadow,
    );
    canvas.drawRect(
      const Rect.fromLTWH(2, 1, 40, 5),
      paint..color = PixelThemeSheetStyle.handle,
    );
    canvas.drawRect(
      const Rect.fromLTWH(4, 1, 36, 1),
      paint..color = PixelThemeSheetStyle.handleHighlight,
    );
    canvas.drawRect(
      const Rect.fromLTWH(2, 5, 40, 1),
      paint..color = PixelThemeSheetStyle.handleShade,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ThemeOptionPainter extends CustomPainter {
  const _ThemeOptionPainter({
    required this.selected,
    required this.focused,
    required this.hovered,
    required this.pressed,
    required this.enabled,
    required this.focusColor,
  });

  final bool selected;
  final bool focused;
  final bool hovered;
  final bool pressed;
  final bool enabled;
  final Color focusColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    const depth = PixelThemeSheetStyle.optionDepth;
    final faceRect = Rect.fromLTWH(
      0,
      0,
      size.width - depth,
      size.height - depth,
    );
    final outer = pixelCutPath(faceRect, PixelThemeSheetStyle.optionCut);
    final depthOffset = const Offset(depth, depth);
    final body = Path.combine(
      PathOperation.union,
      outer,
      outer.shift(depthOffset),
    );

    // 正面和右下厚度先合成一个连续实体，避免平移完整轮廓造成双边框。
    canvas.drawPath(body, paint..color = PixelThemeSheetStyle.optionDepthShade);
    canvas.drawPath(outer, paint..color = PixelThemeSheetStyle.optionFrame);

    final outlineRect = faceRect.deflate(2);
    canvas.drawPath(
      pixelCutPath(outlineRect, 4),
      paint
        ..color = focused
            ? focusColor
            : selected
            ? PixelThemeSheetStyle.optionOutlineSelected
            : PixelThemeSheetStyle.optionOutline,
    );

    final fillRect = faceRect.deflate(4);
    final fill = !enabled
        ? PixelThemeSheetStyle.optionSurface.withValues(alpha: 0.55)
        : pressed
        ? PixelThemeSheetStyle.optionSurfacePressed
        : hovered
        ? PixelThemeSheetStyle.optionSurfaceHover
        : selected
        ? PixelThemeSheetStyle.optionSurfaceSelected
        : PixelThemeSheetStyle.optionSurface;
    canvas.drawPath(pixelCutPath(fillRect, 2), paint..color = fill);
  }

  @override
  bool shouldRepaint(covariant _ThemeOptionPainter oldDelegate) {
    return selected != oldDelegate.selected ||
        focused != oldDelegate.focused ||
        hovered != oldDelegate.hovered ||
        pressed != oldDelegate.pressed ||
        enabled != oldDelegate.enabled ||
        focusColor != oldDelegate.focusColor;
  }
}

class _ThemeCheckPainter extends CustomPainter {
  const _ThemeCheckPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;
    final unit = size.width / 8;
    const blocks = <(int, int)>[
      (1, 4),
      (2, 4),
      (2, 5),
      (3, 5),
      (3, 4),
      (4, 4),
      (4, 3),
      (5, 3),
      (5, 2),
      (6, 2),
      (6, 1),
      (7, 1),
    ];
    for (final block in blocks) {
      canvas.drawRect(
        Rect.fromLTWH(block.$1 * unit, block.$2 * unit, unit, unit),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ThemeCheckPainter oldDelegate) =>
      color != oldDelegate.color;
}
