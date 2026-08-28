import 'package:flutter/material.dart';

import '../../../clock/clock_theme.dart';
import '../../../clock/digital_theme.dart';
import '../../../clock/flip_palette.dart';
import '../../../core/ui/ui.dart';
import '../../../core/ui/pixel/pixel_theme_sheet_style.dart';

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
    final optionGap = ui.isPixel
        ? PixelThemeSheetStyle.optionGap
        : ui.spacingSm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SheetTitle(label: 'Clock Style'),
        SizedBox(height: ui.spacingSm + ui.spacingXs),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (
              var index = 0;
              index < ClockThemeId.values.length;
              index++
            ) ...[
              if (index > 0) SizedBox(height: optionGap),
              AppSelectionTile(
                key: ValueKey('clock-style-${ClockThemeId.values[index].name}'),
                label: ClockThemeId.values[index].label,
                selected: clockThemeId == ClockThemeId.values[index],
                onSelected: () =>
                    onClockThemeSelected(ClockThemeId.values[index]),
              ),
            ],
          ],
        ),
        SizedBox(height: ui.spacingLg),
        const _SheetTitle(label: 'Color Theme'),
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
            return Wrap(
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
                    // 按文字内容形成参考稿中的不等宽三列。
                    minWidth: 0,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ui = AppUiTheme.of(context);
    return Semantics(
      header: true,
      child: Text(
        label,
        style: ui
            .heading(fontSize: 18)
            .copyWith(
              color: ui.isPixel ? PixelThemeSheetStyle.text : ui.textPrimary,
            ),
      ),
    );
  }
}
