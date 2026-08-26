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
    return PixelPanel(
      color: tokens.chrome,
      cutSize: 12,
      padding: EdgeInsets.all(tokens.spacingXs),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: tokens.spacingXs,
        runSpacing: tokens.spacingXs,
        children: [
          for (final action in actions)
            PixelButton(
              label: action.label,
              tone: action.tone,
              compact: true,
              focusNode: action.focusNode,
              onPressed: action.onPressed,
            ),
        ],
      ),
    );
  }
}
