import 'package:flutter/material.dart';

import '../../../core/ui/pixel/pixel_ui.dart';

class ClockMoreSheet extends StatelessWidget {
  const ClockMoreSheet({
    super.key,
    required this.nightMode,
    required this.onNightModeChanged,
    required this.onSettings,
    required this.onAbout,
  });

  final bool nightMode;
  final ValueChanged<bool> onNightModeChanged;
  final VoidCallback onSettings;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return PixelPanel(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PixelSwitch(
            label: 'Night Mode',
            value: nightMode,
            onChanged: onNightModeChanged,
          ),
          Container(height: 1, color: tokens.outline),
          PixelActionTile(label: 'Settings', onPressed: onSettings),
          Container(height: 1, color: tokens.outline),
          PixelActionTile(label: 'About', onPressed: onAbout),
        ],
      ),
    );
  }
}
