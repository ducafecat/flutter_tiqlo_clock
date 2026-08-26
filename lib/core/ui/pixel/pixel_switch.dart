import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pixel_shape.dart';
import 'pixel_tokens.dart';

class PixelSwitch extends StatefulWidget {
  const PixelSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<PixelSwitch> createState() => _PixelSwitchState();
}

class _PixelSwitchState extends State<PixelSwitch> {
  var _hovered = false;
  var _focused = false;
  var _pressed = false;

  bool get _enabled => widget.onChanged != null;

  void _toggle() {
    if (_enabled) widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final foreground = !_enabled
        ? tokens.disabledText
        : _hovered
        ? tokens.textPrimary
        : tokens.textPrimary;
    final motionDuration =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false
        ? Duration.zero
        : tokens.pressDuration;
    return Semantics(
      label: widget.label,
      enabled: _enabled,
      checked: widget.value,
      onTap: _enabled ? _toggle : null,
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
              onInvoke: (_) => _toggle(),
            ),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _enabled ? _toggle : null,
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
              constraints: const BoxConstraints(minHeight: 64, minWidth: 48),
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacingMd,
                vertical: tokens.spacingSm,
              ),
              decoration: BoxDecoration(
                color: _hovered && _enabled
                    ? Color.alphaBlend(tokens.hoverOverlay, tokens.surface)
                    : tokens.surface,
                border: _focused
                    ? Border.all(
                        color: tokens.focus,
                        width: tokens.outlineWidth,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.label,
                      style: tokens.body(color: foreground),
                    ),
                  ),
                  SizedBox(width: tokens.spacingMd),
                  _SwitchGlyph(
                    enabled: _enabled,
                    value: widget.value,
                    pressed: _pressed,
                    motionDuration:
                        MediaQuery.maybeOf(context)?.disableAnimations ?? false
                        ? Duration.zero
                        : tokens.switchDuration,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchGlyph extends StatelessWidget {
  const _SwitchGlyph({
    required this.enabled,
    required this.value,
    required this.pressed,
    required this.motionDuration,
  });

  final bool enabled;
  final bool value;
  final bool pressed;
  final Duration motionDuration;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final track = !enabled
        ? tokens.disabledSurface
        : value
        ? tokens.accent
        : const Color(0xFF1C1A17);
    return AnimatedContainer(
      duration: motionDuration,
      width: 56,
      height: 32,
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: track,
        shape: _PixelSwitchShape(
          tokens.outline,
          devicePixelRatio: devicePixelRatio,
          strokeWidth: tokens.outlineWidth,
        ),
      ),
      child: Align(
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: motionDuration,
          width: 20,
          height: 20,
          transform: Matrix4.translationValues(0, pressed ? 1 : 0, 0),
          decoration: ShapeDecoration(
            color: !enabled
                ? tokens.disabledText
                : value
                ? tokens.textPrimary
                : tokens.outline,
            shape: _PixelSwitchShape(
              tokens.outline,
              devicePixelRatio: devicePixelRatio,
              strokeWidth: tokens.outlineWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class _PixelSwitchShape extends ShapeBorder {
  const _PixelSwitchShape(
    this.color, {
    required this.devicePixelRatio,
    required this.strokeWidth,
  });

  final Color color;
  final double devicePixelRatio;
  final double strokeWidth;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(1);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return pixelCutPath(rect.deflate(1), 8);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return pixelCutPath(rect, 8);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final alignedStroke = _alignToPhysicalPixel(strokeWidth);
    final halfStroke = alignedStroke / 2;
    final alignedRect = Rect.fromLTRB(
      _alignToPhysicalPixel(rect.left + halfStroke),
      _alignToPhysicalPixel(rect.top + halfStroke),
      _alignToPhysicalPixel(rect.right - halfStroke),
      _alignToPhysicalPixel(rect.bottom - halfStroke),
    );
    canvas.drawPath(
      pixelCutPath(alignedRect, 8),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = alignedStroke,
    );
  }

  double _alignToPhysicalPixel(double value) {
    return (value * devicePixelRatio).roundToDouble() / devicePixelRatio;
  }

  @override
  ShapeBorder scale(double t) => this;
}
