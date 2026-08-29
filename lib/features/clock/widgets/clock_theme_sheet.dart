import 'package:flutter/material.dart';

import '../../../clock/clock_theme.dart';
import '../../../clock/digital_theme.dart';
import '../../../clock/flip_palette.dart';
import '../../../core/ui/ui.dart';

class ClockThemeSheet extends StatelessWidget {
  const ClockThemeSheet({
    super.key,
    required this.clockThemeId,
    required this.flipPaletteId,
    required this.digitalThemeId,
    required this.onClockThemeSelected,
    required this.onFlipPaletteSelected,
    required this.onDigitalThemeSelected,
  });

  final ClockThemeId clockThemeId;
  final FlipPaletteId flipPaletteId;
  final DigitalThemeId digitalThemeId;
  final ValueChanged<ClockThemeId> onClockThemeSelected;
  final ValueChanged<FlipPaletteId> onFlipPaletteSelected;
  final ValueChanged<DigitalThemeId> onDigitalThemeSelected;

  @override
  Widget build(BuildContext context) {
    final ui = AppUiTheme.of(context);
    final optionGap = ui.spacingXs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppSheetSectionTitle(label: 'Clock Style'),
        SizedBox(height: ui.spacingSm + ui.spacingXs),
        AppSheetGroup(
          pixelSeparator: optionGap,
          children: [
            for (final id in ClockThemeId.values)
              AppSelectionTile(
                key: ValueKey('clock-style-${id.name}'),
                label: id.label,
                selected: clockThemeId == id,
                onSelected: () => onClockThemeSelected(id),
              ),
          ],
        ),
        SizedBox(height: ui.spacingLg),
        const AppSheetSectionTitle(label: 'Color Theme'),
        SizedBox(height: ui.spacingSm + ui.spacingXs),
        Builder(
          builder: (context) {
            final options = clockThemeId == ClockThemeId.flip
                ? [
                    for (final id in FlipPaletteId.values)
                      (
                        key: 'palette-${id.name}',
                        label: id.label,
                        colors: [id.palette.cardTop, id.palette.digit],
                        selected: flipPaletteId == id,
                        select: () => onFlipPaletteSelected(id),
                      ),
                  ]
                : [
                    for (final id in DigitalThemeId.values)
                      (
                        key: 'digital-theme-${id.name}',
                        label: id.label,
                        colors: [id.theme.background, id.theme.digit],
                        selected: digitalThemeId == id,
                        select: () => onDigitalThemeSelected(id),
                      ),
                  ];
            final grid = Wrap(
              spacing: optionGap,
              runSpacing: optionGap,
              children: [
                for (final option in options)
                  AppColorOption(
                    key: ValueKey(option.key),
                    label: option.label,
                    colors: option.colors,
                    selected: option.selected,
                    onSelected: option.select,
                    minWidth: 0,
                  ),
              ],
            );
            if (ui.isPixel) return grid;
            return AppSheetGroup(
              showDividers: false,
              padding: EdgeInsets.all(ui.spacingSm),
              children: [grid],
            );
          },
        ),
      ],
    );
  }
}
