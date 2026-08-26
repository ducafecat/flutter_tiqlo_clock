import 'package:flutter/material.dart';

import 'pixel_shape.dart';
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
    return CustomPaint(
      painter: _PixelPanelPainter(
        fill: color ?? tokens.surface,
        border: borderColor ?? tokens.outline,
        shadow: tokens.shadow,
        cutSize: cutSize,
        shadowOffset: shadowOffset ?? tokens.hardShadowOffset,
        outlineWidth: tokens.outlineWidth,
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
    required this.border,
    required this.shadow,
    required this.cutSize,
    required this.shadowOffset,
    required this.outlineWidth,
    required this.devicePixelRatio,
  });

  final Color fill;
  final Color border;
  final Color shadow;
  final double cutSize;
  final double shadowOffset;
  final double outlineWidth;
  final double devicePixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final path = pixelCutPath(Offset.zero & size, cutSize);
    canvas.drawPath(
      path.shift(Offset(shadowOffset, shadowOffset)),
      Paint()..color = shadow,
    );
    canvas.drawPath(path, Paint()..color = fill);
    final halfStroke = outlineWidth / 2;
    final alignedRect = Rect.fromLTRB(
      _alignToPhysicalPixel(halfStroke),
      _alignToPhysicalPixel(halfStroke),
      _alignToPhysicalPixel(size.width - halfStroke),
      _alignToPhysicalPixel(size.height - halfStroke),
    );
    canvas.drawPath(
      pixelCutPath(alignedRect, cutSize),
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = _alignToPhysicalPixel(outlineWidth),
    );
  }

  double _alignToPhysicalPixel(double value) {
    return (value * devicePixelRatio).roundToDouble() / devicePixelRatio;
  }

  @override
  bool shouldRepaint(covariant _PixelPanelPainter oldDelegate) {
    return fill != oldDelegate.fill ||
        border != oldDelegate.border ||
        shadow != oldDelegate.shadow ||
        cutSize != oldDelegate.cutSize ||
        shadowOffset != oldDelegate.shadowOffset ||
        outlineWidth != oldDelegate.outlineWidth ||
        devicePixelRatio != oldDelegate.devicePixelRatio;
  }
}
