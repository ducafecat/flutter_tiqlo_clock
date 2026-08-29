import 'package:flutter/material.dart';

import '../../../core/ui/ui.dart';

class ClockMoreSheet extends StatelessWidget {
  const ClockMoreSheet({
    super.key,
    required this.pixelUiEnabled,
    required this.onPixelUiChanged,
    required this.nightMode,
    required this.onNightModeChanged,
    required this.onSettings,
    required this.onAbout,
  });

  final bool pixelUiEnabled;
  final ValueChanged<bool> onPixelUiChanged;
  final bool nightMode;
  final ValueChanged<bool> onNightModeChanged;
  final VoidCallback onSettings;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    final ui = AppUiTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSheetGroup(
          pixelSeparator: ui.spacingSm,
          children: [
            AppSwitch(
              label: 'Pixel UI',
              value: pixelUiEnabled,
              onChanged: onPixelUiChanged,
              compact: true,
            ),
            AppSwitch(
              label: 'Night Mode',
              value: nightMode,
              onChanged: onNightModeChanged,
              compact: true,
            ),
          ],
        ),
        SizedBox(height: ui.isPixel ? ui.spacingSm : ui.spacingMd),
        AppSheetGroup(
          pixelSeparator: ui.spacingSm,
          children: [
            AppActionTile(label: 'Settings', onPressed: onSettings),
            AppActionTile(label: 'About', onPressed: onAbout),
          ],
        ),
      ],
    );
  }
}
