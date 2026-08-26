import 'package:flutter/material.dart';

import 'pixel_tokens.dart';

enum PixelIconKind { back, settingsBack, check, dragHandle }

class PixelIcon extends StatelessWidget {
  const PixelIcon({super.key, required this.kind, this.color, this.size = 24});

  final PixelIconKind kind;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _PixelIconPainter(
          kind,
          color ?? PixelTokens.of(context).textPrimary,
        ),
      ),
    );
  }
}

class _PixelIconPainter extends CustomPainter {
  const _PixelIconPainter(this.kind, this.color);

  final PixelIconKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final unit = size.width / 8;
    switch (kind) {
      case PixelIconKind.back:
        final path = Path()
          ..moveTo(unit, 4 * unit)
          ..lineTo(4 * unit, unit)
          ..lineTo(4 * unit, 2 * unit)
          ..lineTo(2 * unit, 4 * unit)
          ..lineTo(4 * unit, 6 * unit)
          ..lineTo(4 * unit, 7 * unit)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawRect(
          Rect.fromLTWH(3 * unit, 3.5 * unit, 4 * unit, unit),
          paint,
        );
      case PixelIconKind.settingsBack:
        paint.isAntiAlias = false;
        _paintSettingsBack(canvas, size, paint);
      case PixelIconKind.check:
        final path = Path()
          ..moveTo(unit, 4 * unit)
          ..lineTo(2 * unit, 3 * unit)
          ..lineTo(3.5 * unit, 4.5 * unit)
          ..lineTo(6.5 * unit, unit)
          ..lineTo(7.5 * unit, 2 * unit)
          ..lineTo(3.5 * unit, 6.5 * unit)
          ..close();
        canvas.drawPath(path, paint);
      case PixelIconKind.dragHandle:
        canvas.drawRect(
          Rect.fromLTWH(2 * unit, 3 * unit, 4 * unit, unit),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(2 * unit, 5 * unit, 4 * unit, unit),
          paint,
        );
    }
  }

  void _paintSettingsBack(Canvas canvas, Size size, Paint paint) {
    // setting.html: 22x30 viewBox，由五个 6x6 的阶梯色块组成。
    final scale = size.height / 30;
    final left = (size.width - 22 * scale) / 2;
    for (var index = 0; index < 5; index++) {
      final step = index <= 2 ? index : 4 - index;
      canvas.drawRect(
        Rect.fromLTWH(
          left + (14 - step * 6) * scale,
          index * 6 * scale,
          6 * scale,
          6 * scale,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PixelIconPainter oldDelegate) {
    return kind != oldDelegate.kind || color != oldDelegate.color;
  }
}
