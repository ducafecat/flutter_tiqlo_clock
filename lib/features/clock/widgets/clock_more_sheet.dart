import 'package:flutter/material.dart';

import '../../../core/ui/pixel/pixel_ui.dart';
import '../../../core/ui/pixel/pixel_theme_sheet_style.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PixelThemeOptionFrame(
          selected: false,
          focused: false,
          hovered: false,
          pressed: false,
          enabled: true,
          focusColor: tokens.focus,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: PixelSwitch(
              label: 'Night Mode',
              value: nightMode,
              onChanged: onNightModeChanged,
              compact: true,
            ),
          ),
        ),
        const SizedBox(height: PixelThemeSheetStyle.optionGap),
        PixelActionTile(label: 'Settings', onPressed: onSettings),
        const SizedBox(height: PixelThemeSheetStyle.optionGap),
        PixelActionTile(label: 'About', onPressed: onAbout),
      ],
    );
  }
}
