import 'package:flutter/material.dart';

import '../../../clock/clock_theme.dart';
import '../../../clock/digital_theme.dart';
import '../../../clock/flip_palette.dart';
import '../../../core/ui/pixel/pixel_ui.dart';

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
    final tokens = PixelTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SheetTitle(label: 'Clock Style', tokens: tokens),
        SizedBox(height: tokens.spacingSm),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (
              var index = 0;
              index < ClockThemeId.values.length;
              index++
            ) ...[
              if (index > 0) SizedBox(height: tokens.spacingSm),
              PixelSelectionTile(
                key: ValueKey('clock-style-${ClockThemeId.values[index].name}'),
                label: ClockThemeId.values[index].label,
                selected: clockThemeId == ClockThemeId.values[index],
                onSelected: () =>
                    onClockThemeSelected(ClockThemeId.values[index]),
              ),
            ],
          ],
        ),
        SizedBox(height: tokens.spacingLg),
        _SheetTitle(label: 'Color Theme', tokens: tokens),
        SizedBox(height: tokens.spacingSm),
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
              spacing: tokens.spacingSm,
              runSpacing: tokens.spacingSm,
              children: [
                for (final option in options)
                  PixelColorOption(
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
  const _SheetTitle({required this.label, required this.tokens});

  final String label;
  final PixelTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        label,
        style: tokens.heading(fontSize: 18).copyWith(color: tokens.section),
      ),
    );
  }
}
