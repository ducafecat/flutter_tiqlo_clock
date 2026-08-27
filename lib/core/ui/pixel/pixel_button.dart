import 'package:flutter/material.dart';

import 'pixel_panel.dart';
import 'pixel_pressable.dart';
import 'pixel_theme_sheet_style.dart';
import 'pixel_tokens.dart';

enum PixelButtonTone { primary, secondary, danger }

class PixelButton extends StatelessWidget {
  const PixelButton({
    super.key,
    required this.onPressed,
    this.label,
    this.child,
    this.semanticLabel,
    this.focusNode,
    this.tone = PixelButtonTone.secondary,
    this.compact = false,
  }) : assert(label != null || child != null);

  final VoidCallback? onPressed;
  final String? label;
  final Widget? child;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final PixelButtonTone tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final base = switch (tone) {
      PixelButtonTone.primary => tokens.accent,
      PixelButtonTone.secondary => PixelThemeSheetStyle.optionSurface,
      PixelButtonTone.danger => tokens.danger,
    };
    final foreground = tone == PixelButtonTone.secondary
        ? tokens.textPrimary
        : tokens.background;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return PixelPressable(
      semanticLabel: semanticLabel ?? label,
      focusNode: focusNode,
      onPressed: onPressed,
      builder: (context, state) {
        final color = !state.enabled
            ? tokens.disabledSurface
            : state.pressed
            ? Color.alphaBlend(tokens.pressedOverlay, base)
            : state.hovered
            ? Color.alphaBlend(tokens.hoverOverlay, base)
            : base;
        return AnimatedContainer(
          duration: reduceMotion ? Duration.zero : tokens.pressDuration,
          transform: Matrix4.translationValues(
            0,
            state.pressed ? tokens.pressedOffset : 0,
            0,
          ),
          constraints: BoxConstraints(
            minWidth: compact ? 48 : 96,
            minHeight: 48,
          ),
          decoration: BoxDecoration(
            border: state.focused
                ? Border.all(color: tokens.focus, width: tokens.outlineWidth)
                : null,
          ),
          child: PixelPanel(
            color: color,
            borderColor: state.focused ? tokens.focus : tokens.outline,
            cutSize: compact ? 8 : 12,
            shadowOffset: state.pressed
                ? tokens.pressedOffset
                : tokens.hardShadowOffset,
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spacingMd - tokens.spacingXs,
              vertical: tokens.spacingSm,
            ),
            child: Center(
              child:
                  child ??
                  Text(
                    label!,
                    style: tokens.body(
                      color: state.enabled ? foreground : tokens.disabledText,
                    ),
                  ),
            ),
          ),
        );
      },
    );
  }
}
