import 'package:flutter/material.dart';

import 'pixel_action_tile.dart';
import 'pixel_icon.dart';
import 'pixel_tokens.dart';

class PixelColorOption extends StatelessWidget {
  const PixelColorOption({
    super.key,
    required this.label,
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<Color> colors;
  final bool selected;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return Semantics(
      container: true,
      button: true,
      enabled: onSelected != null,
      selected: selected,
      label: label,
      onTap: onSelected,
      child: ExcludeSemantics(
        child: SizedBox(
          width: 144,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: selected
                  ? Border.all(color: tokens.accent, width: tokens.outlineWidth)
                  : null,
            ),
            child: PixelActionTile(
              label: label,
              onPressed: onSelected,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final color in colors.take(2))
                    Container(width: 14, height: 20, color: color),
                  if (selected) ...[
                    SizedBox(width: tokens.spacingSm),
                    PixelIcon(
                      kind: PixelIconKind.check,
                      color: tokens.accent,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
