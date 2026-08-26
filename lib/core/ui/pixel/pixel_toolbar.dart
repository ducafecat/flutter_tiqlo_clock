import 'package:flutter/material.dart';

import 'pixel_button.dart';
import 'pixel_panel.dart';
import 'pixel_tokens.dart';

class PixelToolbarAction {
  const PixelToolbarAction({
    required this.label,
    required this.onPressed,
    this.tone = PixelButtonTone.secondary,
    this.focusNode,
  });

  final String label;
  final VoidCallback? onPressed;
  final PixelButtonTone tone;
  final FocusNode? focusNode;
}

class PixelToolbar extends StatelessWidget {
  const PixelToolbar({super.key, required this.actions});

  final List<PixelToolbarAction> actions;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final mediaQuery = MediaQuery.maybeOf(context);
    final usePortraitMenu =
        mediaQuery != null &&
        mediaQuery.orientation == Orientation.portrait &&
        mediaQuery.size.width < 600;

    if (usePortraitMenu) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: tokens.spacingSm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < actions.length; index++) ...[
              if (index > 0) SizedBox(height: tokens.spacingSm),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 56),
                child: _ToolbarButton(action: actions[index], labelSize: 24),
              ),
            ],
          ],
        ),
      );
    }

    return PixelPanel(
      color: tokens.chrome,
      cutSize: 12,
      padding: EdgeInsets.all(tokens.spacingXs),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: tokens.spacingXs,
        runSpacing: tokens.spacingXs,
        children: [
          for (final action in actions) _ToolbarButton(action: action),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({required this.action, this.labelSize});

  final PixelToolbarAction action;
  final double? labelSize;

  @override
  Widget build(BuildContext context) {
    final labelSize = this.labelSize;
    return PixelButton(
      label: action.label,
      tone: action.tone,
      compact: true,
      focusNode: action.focusNode,
      onPressed: action.onPressed,
      child: labelSize == null
          ? null
          : Text(
              action.label,
              style: PixelTokens.of(context).body(fontSize: labelSize),
            ),
    );
  }
}
