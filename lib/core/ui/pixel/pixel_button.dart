import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pixel_panel.dart';
import 'pixel_tokens.dart';

enum PixelButtonTone { primary, secondary, danger }

class PixelButton extends StatefulWidget {
  const PixelButton({
    super.key,
    required this.onPressed,
    this.label,
    this.child,
    this.semanticLabel,
    this.tone = PixelButtonTone.secondary,
    this.compact = false,
  }) : assert(label != null || child != null);

  final VoidCallback? onPressed;
  final String? label;
  final Widget? child;
  final String? semanticLabel;
  final PixelButtonTone tone;
  final bool compact;

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  var _hovered = false;
  var _focused = false;
  var _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _activate() {
    if (_enabled) widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final base = switch (widget.tone) {
      PixelButtonTone.primary => tokens.accent,
      PixelButtonTone.secondary => tokens.surface,
      PixelButtonTone.danger => tokens.danger,
    };
    final foreground = widget.tone == PixelButtonTone.secondary
        ? tokens.textPrimary
        : tokens.background;
    final color = !_enabled
        ? tokens.disabledSurface
        : _pressed
        ? Color.alphaBlend(tokens.pressedOverlay, base)
        : _hovered
        ? Color.alphaBlend(tokens.hoverOverlay, base)
        : base;
    final motionDuration =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false
        ? Duration.zero
        : tokens.pressDuration;

    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel ?? widget.label,
      onTap: _enabled ? _activate : null,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          enabled: _enabled,
          onShowFocusHighlight: (value) => setState(() => _focused = value),
          onShowHoverHighlight: (value) => setState(() => _hovered = value),
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) => _activate(),
            ),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _enabled ? _activate : null,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            child: AnimatedContainer(
              duration: motionDuration,
              transform: Matrix4.translationValues(
                0,
                _pressed ? tokens.pressedOffset : 0,
                0,
              ),
              constraints: BoxConstraints(
                minWidth: widget.compact ? 48 : 96,
                minHeight: 48,
              ),
              decoration: BoxDecoration(
                border: _focused
                    ? Border.all(
                        color: tokens.focus,
                        width: tokens.outlineWidth,
                      )
                    : null,
              ),
              child: PixelPanel(
                color: color,
                borderColor: _focused ? tokens.focus : tokens.outline,
                cutSize: widget.compact ? 8 : 12,
                shadowOffset: _pressed
                    ? tokens.pressedOffset
                    : tokens.hardShadowOffset,
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spacingMd - tokens.spacingXs,
                  vertical: tokens.spacingSm,
                ),
                child: Center(
                  child:
                      widget.child ??
                      Text(
                        widget.label!,
                        style: tokens.body(
                          color: _enabled ? foreground : tokens.disabledText,
                        ),
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
