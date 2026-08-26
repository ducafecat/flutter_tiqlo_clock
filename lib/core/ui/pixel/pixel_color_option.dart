import 'package:flutter/material.dart';

import 'pixel_action_tile.dart';
import 'pixel_icon.dart';
import 'pixel_panel.dart';
import 'pixel_tokens.dart';

class PixelColorOption extends StatelessWidget {
  const PixelColorOption({
    super.key,
    required this.label,
    required this.colors,
    required this.selected,
    required this.onSelected,
    this.minWidth = 144,
  });

  final String label;
  final List<Color> colors;
  final bool selected;
  final VoidCallback? onSelected;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return Semantics(
      container: true,
      button: true,
      enabled: onSelected != null,
      selected: selected,
      label: label,
      onTap: onSelected,
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: PixelPanel(
            padding: EdgeInsets.zero,
            borderColor: selected ? tokens.textPrimary : null,
            child: PixelActionTile(
              label: label,
              onPressed: onSelected,
              minHeight: 44,
              expand: false,
              leading: _ColorRing(
                color: _swatchColor,
                selected: selected,
                selectedColor: tokens.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color get _swatchColor {
    final primary = colors.first;
    return primary.computeLuminance() < 0.02 && colors.length > 1
        ? colors[1]
        : primary;
  }
}

class _ColorRing extends StatelessWidget {
  const _ColorRing({
    required this.color,
    required this.selected,
    required this.selectedColor,
  });

  final Color color;
  final bool selected;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _ColorRingPainter(color)),
          if (selected)
            Center(
              child: PixelIcon(
                kind: PixelIconKind.check,
                color: selectedColor,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

class _ColorRingPainter extends CustomPainter {
  const _ColorRingPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final unit = size.width / 7;
    // 方形阶梯组成的空心色环，避免抗锯齿以保留像素感。
    final blocks = <(int, int)>[
      (2, 0),
      (3, 0),
      (4, 0),
      (1, 1),
      (5, 1),
      (0, 2),
      (6, 2),
      (0, 3),
      (6, 3),
      (0, 4),
      (6, 4),
      (1, 5),
      (5, 5),
      (2, 6),
      (3, 6),
      (4, 6),
    ];
    for (final block in blocks) {
      canvas.drawRect(
        Rect.fromLTWH(block.$1 * unit, block.$2 * unit, unit, unit),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ColorRingPainter oldDelegate) =>
      color != oldDelegate.color;
}
