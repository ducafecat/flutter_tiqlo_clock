import 'package:flutter/material.dart';

import 'pixel_pressable.dart';
import 'pixel_theme_sheet_style.dart';
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
          child: PixelPressable(
            semanticLabel: label,
            onPressed: onSelected,
            builder: (context, state) => PixelThemeOptionFrame(
              selected: selected,
              focused: state.focused,
              hovered: state.hovered,
              pressed: state.pressed,
              enabled: state.enabled,
              focusColor: tokens.focus,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ColorRing(
                        color: _swatchColor,
                        selected: selected,
                        selectedColor: PixelThemeSheetStyle.textSelected,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: tokens.body(
                          fontSize: 18,
                          color: state.enabled
                              ? PixelThemeSheetStyle.text
                              : tokens.disabledText,
                        ),
                      ),
                    ],
                  ),
                ),
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
            Center(child: PixelThemeCheck(color: selectedColor, size: 16)),
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
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;
    const unit = 3.0;
    final origin = Offset(
      (size.width - unit * 7) / 2,
      (size.height - unit * 7) / 2,
    );
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
        Rect.fromLTWH(
          origin.dx + block.$1 * unit,
          origin.dy + block.$2 * unit,
          unit,
          unit,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ColorRingPainter oldDelegate) =>
      color != oldDelegate.color;
}
