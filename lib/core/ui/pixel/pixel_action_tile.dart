import 'package:flutter/material.dart';

import 'pixel_pressable.dart';
import 'pixel_theme_sheet_style.dart';
import 'pixel_tokens.dart';

class PixelActionTile extends StatelessWidget {
  const PixelActionTile({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.trailing,
    this.minHeight = 48,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final double minHeight;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return PixelPressable(
      semanticLabel: label,
      onPressed: onPressed,
      builder: (context, state) {
        return PixelThemeOptionFrame(
          selected: false,
          focused: state.focused,
          hovered: state.hovered,
          pressed: state.pressed,
          enabled: state.enabled,
          focusColor: tokens.focus,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight, minWidth: 48),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacingMd + 2,
                vertical: tokens.spacingSm,
              ),
              child: Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    leading!,
                    SizedBox(width: tokens.spacingSm),
                  ],
                  if (expand)
                    Expanded(
                      child: Text(
                        label,
                        style: tokens.body(
                          fontSize: 20,
                          color: state.enabled
                              ? PixelThemeSheetStyle.text
                              : tokens.disabledText,
                        ),
                      ),
                    )
                  else
                    Text(
                      label,
                      style: tokens.body(
                        fontSize: 20,
                        color: state.enabled
                            ? PixelThemeSheetStyle.text
                            : tokens.disabledText,
                      ),
                    ),
                  if (trailing != null) ...[
                    SizedBox(width: tokens.spacingMd),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
