import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class PixelPressState {
  const PixelPressState({
    required this.enabled,
    required this.hovered,
    required this.focused,
    required this.pressed,
  });

  final bool enabled;
  final bool hovered;
  final bool focused;
  final bool pressed;
}

class PixelPressable extends StatefulWidget {
  const PixelPressable({
    super.key,
    required this.onPressed,
    required this.builder,
    this.semanticLabel,
    this.focusNode,
  });

  final VoidCallback? onPressed;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final Widget Function(BuildContext context, PixelPressState state) builder;

  @override
  State<PixelPressable> createState() => _PixelPressableState();
}

class _PixelPressableState extends State<PixelPressable> {
  var _hovered = false;
  var _focused = false;
  var _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _activate() {
    if (_enabled) widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final state = PixelPressState(
      enabled: _enabled,
      hovered: _hovered,
      focused: _focused,
      pressed: _pressed,
    );
    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: _enabled ? _activate : null,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          focusNode: widget.focusNode,
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
            child: widget.builder(context, state),
          ),
        ),
      ),
    );
  }
}
