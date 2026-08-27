import 'package:flutter/material.dart';

import 'pixel_pressable.dart';
import 'pixel_tokens.dart';

/// 无底板的像素文字按钮。
///
/// 适合欢迎页、轻量导航等不应抢占内容视觉权重的操作，同时保留完整的
/// 48dp 点击区域、键盘操作与焦点反馈。
class PixelTextButton extends StatelessWidget {
  const PixelTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.focusNode,
    this.prominent = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;

  /// 主操作使用强调色；普通操作使用主文字色。
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return IntrinsicWidth(
      child: SizedBox(
        height: 48,
        child: PixelPressable(
          semanticLabel: label,
          focusNode: focusNode,
          onPressed: onPressed,
          builder: (context, state) {
            final foreground = !state.enabled
                ? tokens.disabledText
                : prominent
                ? tokens.accent
                : tokens.textPrimary;
            final background = state.pressed
                ? tokens.pressedOverlay
                : state.hovered
                ? tokens.hoverOverlay
                : tokens.background.withValues(alpha: 0);

            return AnimatedContainer(
              key: const ValueKey('pixel-text-button'),
              duration: reduceMotion ? Duration.zero : tokens.pressDuration,
              transform: Matrix4.translationValues(
                0,
                state.pressed ? tokens.pressedOffset : 0,
                0,
              ),
              constraints: const BoxConstraints(minWidth: 48),
              padding: EdgeInsets.symmetric(horizontal: tokens.spacingSm),
              decoration: BoxDecoration(
                color: background,
                border: Border(
                  bottom: BorderSide(
                    color: state.focused
                        ? tokens.focus
                        : state.hovered || state.pressed
                        ? foreground
                        : tokens.background.withValues(alpha: 0),
                    width: tokens.outlineWidth,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: tokens
                      .body(fontSize: 16, color: foreground)
                      .copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
