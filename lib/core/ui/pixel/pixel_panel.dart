import 'package:flutter/material.dart';

import 'pixel_shape.dart';
import 'pixel_theme_sheet_style.dart';
import 'pixel_tokens.dart';

class PixelPanel extends StatelessWidget {
  const PixelPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.cutSize = 8,
    this.borderColor,
    this.shadowOffset,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double cutSize;
  final Color? borderColor;
  final double? shadowOffset;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final resolvedBorder = borderColor ?? PixelThemeSheetStyle.optionOutline;
    return CustomPaint(
      painter: _PixelPanelPainter(
        fill: color ?? PixelThemeSheetStyle.optionSurface,
        shadow: tokens.shadow,
        cutSize: cutSize,
        shadowOffset: shadowOffset ?? tokens.hardShadowOffset,
        outlineWidth: tokens.outlineWidth,
        devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
      ),
      foregroundPainter: _PixelPanelBorderPainter(
        border: resolvedBorder,
        frame: PixelThemeSheetStyle.optionFrame,
        cutSize: cutSize,
        devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
      ),
      child: ClipPath(
        clipper: PixelCutClipper(cutSize),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _PixelPanelPainter extends CustomPainter {
  const _PixelPanelPainter({
    required this.fill,
    required this.shadow,
    required this.cutSize,
    required this.shadowOffset,
    required this.outlineWidth,
    required this.devicePixelRatio,
  });

  final Color fill;
  final Color shadow;
  final double cutSize;
  final double shadowOffset;
  final double outlineWidth;
  final double devicePixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = pixelCutPath(rect, cutSize);
    canvas.drawPath(
      path.shift(Offset(shadowOffset, shadowOffset)),
      Paint()
        ..color = shadow
        ..isAntiAlias = false,
    );
    final innerRect = _insetRect(rect, outlineWidth * 2);
    canvas.drawPath(
      pixelCutPath(innerRect, (cutSize - outlineWidth * 2).clamp(4, cutSize)),
      Paint()
        ..color = fill
        ..isAntiAlias = false,
    );
  }

  Rect _insetRect(Rect rect, double inset) => Rect.fromLTRB(
    _alignToPhysicalPixel(rect.left + inset),
    _alignToPhysicalPixel(rect.top + inset),
    _alignToPhysicalPixel(rect.right - inset),
    _alignToPhysicalPixel(rect.bottom - inset),
  );

  double _alignToPhysicalPixel(double value) {
    return (value * devicePixelRatio).roundToDouble() / devicePixelRatio;
  }

  @override
  bool shouldRepaint(covariant _PixelPanelPainter oldDelegate) {
    return fill != oldDelegate.fill ||
        shadow != oldDelegate.shadow ||
        cutSize != oldDelegate.cutSize ||
        shadowOffset != oldDelegate.shadowOffset ||
        outlineWidth != oldDelegate.outlineWidth ||
        devicePixelRatio != oldDelegate.devicePixelRatio;
  }
}

class _PixelPanelBorderPainter extends CustomPainter {
  const _PixelPanelBorderPainter({
    required this.border,
    required this.frame,
    required this.cutSize,
    required this.devicePixelRatio,
  });

  final Color border;
  final Color frame;
  final double cutSize;
  final double devicePixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final middleRect = _insetRect(rect, 2);
    final innerRect = _insetRect(rect, 4);
    final outer = pixelCutPath(rect, cutSize);
    final middle = pixelCutPath(middleRect, (cutSize - 2).clamp(4, cutSize));
    final inner = pixelCutPath(innerRect, (cutSize - 4).clamp(4, cutSize));
    final paint = Paint()..isAntiAlias = false;

    canvas.drawPath(
      Path.combine(PathOperation.difference, outer, middle),
      paint..color = frame,
    );
    canvas.drawPath(
      Path.combine(PathOperation.difference, middle, inner),
      paint..color = border,
    );
  }

  Rect _insetRect(Rect rect, double inset) => Rect.fromLTRB(
    _align(rect.left + inset),
    _align(rect.top + inset),
    _align(rect.right - inset),
    _align(rect.bottom - inset),
  );

  double _align(double value) =>
      (value * devicePixelRatio).roundToDouble() / devicePixelRatio;

  @override
  bool shouldRepaint(covariant _PixelPanelBorderPainter oldDelegate) {
    return border != oldDelegate.border ||
        frame != oldDelegate.frame ||
        cutSize != oldDelegate.cutSize ||
        devicePixelRatio != oldDelegate.devicePixelRatio;
  }
}
