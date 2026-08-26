import 'package:flutter/material.dart';

import 'pixel_pressable.dart';
import 'pixel_tokens.dart';

class PixelActionTile extends StatelessWidget {
  const PixelActionTile({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return PixelPressable(
      semanticLabel: label,
      onPressed: onPressed,
      builder: (context, state) {
        final foreground = state.enabled
            ? tokens.textPrimary
            : tokens.disabledText;
        final baseColor = state.enabled
            ? tokens.surface
            : tokens.disabledSurface;
        final color = state.pressed
            ? Color.alphaBlend(tokens.pressedOverlay, baseColor)
            : state.hovered && state.enabled
            ? Color.alphaBlend(tokens.hoverOverlay, baseColor)
            : baseColor;
        return AnimatedContainer(
          duration: reduceMotion ? Duration.zero : tokens.pressDuration,
          transform: Matrix4.translationValues(
            0,
            state.pressed ? tokens.pressedOffset : 0,
            0,
          ),
          constraints: const BoxConstraints(minHeight: 64, minWidth: 48),
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacingMd,
            vertical: tokens.spacingSm,
          ),
          decoration: BoxDecoration(
            color: color,
            border: state.focused
                ? Border.all(color: tokens.focus, width: tokens.outlineWidth)
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(label, style: tokens.body(color: foreground)),
              ),
              if (trailing != null) ...[
                SizedBox(width: tokens.spacingMd),
                trailing!,
              ],
            ],
          ),
        );
      },
    );
  }
}
