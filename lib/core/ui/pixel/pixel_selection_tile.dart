import 'package:flutter/material.dart';

import 'pixel_action_tile.dart';
import 'pixel_icon.dart';
import 'pixel_panel.dart';
import 'pixel_tokens.dart';

class PixelSelectionTile extends StatelessWidget {
  const PixelSelectionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
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
        child: PixelPanel(
          padding: EdgeInsets.zero,
          borderColor: selected ? tokens.textPrimary : null,
          child: PixelActionTile(
            label: label,
            onPressed: onSelected,
            minHeight: 56,
            trailing: selected
                ? PixelIcon(
                    kind: PixelIconKind.check,
                    color: tokens.textPrimary,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
