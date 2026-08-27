import 'package:flutter/material.dart';

import 'pixel_pressable.dart';
import 'pixel_theme_sheet_style.dart';
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
        child: PixelPressable(
          semanticLabel: label,
          onPressed: onSelected,
          builder: (context, state) => PixelThemeOptionFrame(
            selected: selected,
            focused: state.focused,
            hovered: state.hovered,
            pressed: state.pressed,
            enabled: state.enabled,
            focusColor: tokens.focus,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: tokens.body(
                          fontSize: 20,
                          color: state.enabled
                              ? selected
                                    ? PixelThemeSheetStyle.textSelected
                                    : PixelThemeSheetStyle.text
                              : tokens.disabledText,
                        ),
                      ),
                    ),
                    if (selected) ...[
                      const SizedBox(width: 16),
                      const PixelThemeCheck(
                        color: PixelThemeSheetStyle.textSelected,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
