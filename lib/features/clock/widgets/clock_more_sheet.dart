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
        AppSwitch(
          label: 'Pixel UI',
          value: pixelUiEnabled,
          onChanged: onPixelUiChanged,
          compact: true,
        ),
        SizedBox(height: ui.spacingSm),
        AppSwitch(
          label: 'Night Mode',
          value: nightMode,
          onChanged: onNightModeChanged,
          compact: true,
        ),
        SizedBox(height: ui.spacingSm),
        AppActionTile(label: 'Settings', onPressed: onSettings),
        SizedBox(height: ui.spacingSm),
        AppActionTile(label: 'About', onPressed: onAbout),
      ],
    );
  }
}
