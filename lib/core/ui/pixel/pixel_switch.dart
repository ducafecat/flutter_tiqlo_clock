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
        : const Color(0xFFFFFDF7);
    final motionDuration = tokens.motionDuration(context, tokens.pressDuration);
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
              curve: const _StepsTwoEnd(),
              constraints: const BoxConstraints(minHeight: 63, minWidth: 48),
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
              decoration: BoxDecoration(
                color: _pressed
                    ? const Color(0xFF302C27)
                    : _hovered && _enabled
                    ? Color.alphaBlend(
                        tokens.hoverOverlay,
                        const Color(0xFF2A2722),
                      )
                    : null,
                gradient: _pressed || (_hovered && _enabled)
                    ? null
                    : const LinearGradient(
                        colors: [
                          Color(0xFF27241F),
                          Color(0xFF2A2722),
                          Color(0xFF26231F),
                        ],
                        stops: [0, 0.54, 1],
                      ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.label,
                      style: tokens
                          .body(fontSize: 22, color: foreground)
                          .copyWith(height: 1.25),
                    ),
                  ),
                  SizedBox(width: tokens.spacingMd),
                  Padding(
                    padding: const EdgeInsets.only(right: 1),
                    child: _SwitchGlyph(
                      enabled: _enabled,
                      value: widget.value,
                      focused: _focused,
                      motionDuration: tokens.motionDuration(
                        context,
                        tokens.switchDuration,
                      ),
                    ),
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
    required this.focused,
    required this.motionDuration,
  });

  final bool enabled;
  final bool value;
  final bool focused;
  final Duration motionDuration;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return SizedBox(
      key: const ValueKey('pixel-switch-control'),
      width: 64,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _SwitchTrackPainter(
                enabled: enabled,
                value: value,
                disabledSurface: tokens.disabledSurface,
              ),
            ),
          ),
          if (focused)
            Positioned(
              left: -4,
              top: -4,
              width: 72,
              height: 48,
              child: IgnorePointer(
                child: CustomPaint(painter: const _SwitchFocusPainter()),
              ),
            ),
          AnimatedPositioned(
            duration: motionDuration,
            curve: const _StepsTwoEnd(),
            left: value ? 33 : 9,
            top: 8,
            width: 22,
            height: 24,
            child: CustomPaint(
              painter: _SwitchKnobPainter(
                enabled: enabled,
                value: value,
                disabledColor: tokens.disabledText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchTrackPainter extends CustomPainter {
  const _SwitchTrackPainter({
    required this.enabled,
    required this.value,
    required this.disabledSurface,
  });

  final bool enabled;
  final bool value;
  final Color disabledSurface;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final outer = pixelSwitchOuterPath(rect);
    canvas.drawPath(
      outer.shift(const Offset(1, 1)),
      Paint()..color = const Color(0xFF050504),
    );
    canvas.drawPath(outer, Paint()..color = const Color(0xFF0B0A09));

    final trackRect = rect.deflate(2);
    canvas.drawPath(
      pixelSwitchTrackPath(trackRect),
      Paint()
        ..color = !enabled
            ? disabledSurface
            : value
            ? const Color(0xFFA3480B)
            : const Color(0xFF5B554B),
    );

    final innerRect = rect.deflate(4);
    final innerPath = pixelSwitchInnerTrackPath(innerRect);
    canvas.save();
    canvas.clipPath(innerPath);
    if (enabled && value) {
      canvas.drawRect(
        innerRect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE88A2A),
              Color(0xFFD96B0C),
              Color(0xFFD96B0C),
              Color(0xFFA74608),
            ],
            stops: [0, 0.0625, 0.9375, 1],
          ).createShader(innerRect),
      );
      canvas.drawRect(
        Rect.fromLTWH(innerRect.left, innerRect.top, innerRect.width, 2),
        Paint()..color = const Color(0xFFED9232),
      );
      canvas.drawRect(
        Rect.fromLTWH(innerRect.left, innerRect.bottom - 1, innerRect.width, 1),
        Paint()..color = const Color(0xFFB55410),
      );
    } else {
      canvas.drawRect(
        innerRect,
        Paint()..color = enabled ? const Color(0xFF171612) : disabledSurface,
      );
      canvas.drawRect(
        Rect.fromLTWH(innerRect.left, innerRect.top, innerRect.width, 2),
        Paint()..color = const Color(0xFF39352F),
      );
      canvas.drawRect(
        Rect.fromLTWH(innerRect.left, innerRect.bottom - 1, innerRect.width, 1),
        Paint()..color = const Color(0xFF0B0B09),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SwitchTrackPainter oldDelegate) {
    return enabled != oldDelegate.enabled ||
        value != oldDelegate.value ||
        disabledSurface != oldDelegate.disabledSurface;
  }
}

class _SwitchKnobPainter extends CustomPainter {
  const _SwitchKnobPainter({
    required this.enabled,
    required this.value,
    required this.disabledColor,
  });

  final bool enabled;
  final bool value;
  final Color disabledColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = pixelSwitchKnobPath(rect);
    final shadow = value ? const Color(0xFF783006) : const Color(0xFF2B2925);
    final fill = !enabled
        ? disabledColor
        : value
        ? const Color(0xFFF4F0E6)
        : const Color(0xFF55524D);
    final highlight = value ? const Color(0xFFFFFDF7) : const Color(0xFF69655F);
    final lowlight = value ? const Color(0xFFD8D1C4) : const Color(0xFF403D38);

    canvas.drawPath(path.shift(const Offset(0, 1)), Paint()..color = shadow);
    canvas.drawPath(path, Paint()..color = fill);

    canvas.save();
    canvas.clipPath(path);
    canvas.drawPath(
      path,
      Paint()
        ..color = highlight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawPath(
      path.shift(const Offset(-1, -1)),
      Paint()
        ..color = lowlight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SwitchKnobPainter oldDelegate) {
    return enabled != oldDelegate.enabled ||
        value != oldDelegate.value ||
        disabledColor != oldDelegate.disabledColor;
  }
}

class _SwitchFocusPainter extends CustomPainter {
  const _SwitchFocusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      (Offset.zero & size).deflate(1.5),
      Paint()
        ..color = const Color(0xFFFFFDF4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _SwitchFocusPainter oldDelegate) => false;
}

class _StepsTwoEnd extends Curve {
  const _StepsTwoEnd();

  @override
  double transformInternal(double t) {
    if (t >= 1) return 1;
    if (t >= 0.5) return 0.5;
    return 0;
  }
}
