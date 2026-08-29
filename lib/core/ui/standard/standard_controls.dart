import 'package:flutter/material.dart';

import 'standard_tokens.dart';

class StandardSwitch extends StatelessWidget {
  const StandardSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label, style: StandardTextStyles.bodyOn(context)),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: StandardSpacing.md,
      ),
      dense: compact,
    );
  }
}

class StandardActionTile extends StatelessWidget {
  const StandardActionTile({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      title: Text(label, style: StandardTextStyles.bodyOn(context)),
      onTap: onPressed,
    );
  }
}

class StandardSelectionTile extends StatelessWidget {
  const StandardSelectionTile({
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
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? scheme.onSurface.withValues(alpha: 0.12)
          : Colors.transparent,
      child: ListTile(
        title: Text(label, style: StandardTextStyles.bodyOn(context)),
        selected: selected,
        selectedColor: scheme.onSurface,
        selectedTileColor: Colors.transparent,
        trailing: selected ? Icon(Icons.check, color: scheme.onSurface) : null,
        onTap: onSelected,
      ),
    );
  }
}

class StandardColorOption extends StatelessWidget {
  const StandardColorOption({
    super.key,
    required this.label,
    required this.colors,
    required this.selected,
    required this.onSelected,
    this.minWidth = 144,
  });

  final String label;
  final List<Color> colors;
  final bool selected;
  final VoidCallback? onSelected;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    assert(
      colors.isNotEmpty,
      'StandardColorOption requires at least one color.',
    );
    final scheme = Theme.of(context).colorScheme;
    final foreground = scheme.onSurface;
    final swatchBackground = colors.first;
    final swatchForeground = colors.length > 1 ? colors[1] : colors.first;
    final checkColor = swatchBackground.computeLuminance() > 0.45
        ? Colors.black87
        : Colors.white;
    return Semantics(
      button: true,
      enabled: onSelected != null,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth, minHeight: 40),
          child: Material(
            color: foreground.withValues(alpha: selected ? 0.16 : 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: StandardRadius.control,
              side: BorderSide(
                color: foreground.withValues(alpha: selected ? 0.55 : 0.12),
                width: selected ? 1.5 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onSelected,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StandardSpacing.sm,
                  vertical: StandardSpacing.xs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: swatchBackground,
                        shape: BoxShape.circle,
                        border: Border.all(color: swatchForeground, width: 1.5),
                      ),
                      child: selected
                          ? Icon(Icons.check, size: 12, color: checkColor)
                          : null,
                    ),
                    const SizedBox(width: StandardSpacing.xs),
                    Text(
                      label,
                      style: StandardTextStyles.secondary.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class StandardTextButton extends StatelessWidget {
  const StandardTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.focusNode,
    this.prominent = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    if (prominent) {
      return FilledButton(
        focusNode: focusNode,
        onPressed: onPressed,
        child: Text(label),
      );
    }
    return TextButton(
      focusNode: focusNode,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class StandardPageIndicator extends StatelessWidget {
  const StandardPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    required this.duration,
  });

  final int pageCount;
  final int currentPage;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '第 ${currentPage + 1} 页，共 $pageCount 页',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < pageCount; index++)
              AnimatedContainer(
                duration: duration,
                width: index == currentPage ? 24 : 7,
                height: 7,
                margin: EdgeInsets.only(right: index == pageCount - 1 ? 0 : 7),
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? StandardColors.welcomeAccent
                      : Colors.white30,
                  borderRadius: StandardRadius.pillBorderRadius,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StandardToolbarAction {
  const StandardToolbarAction({
    required this.label,
    required this.onPressed,
    this.focusNode,
  });

  final String label;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
}

/// Clock 底部瞬时操作层。
///
/// 背景、描边、按钮排布和字号都封装在此；Clock 页面只声明有哪些操作。
class StandardToolbar extends StatelessWidget {
  const StandardToolbar({super.key, required this.actions});

  final List<StandardToolbarAction> actions;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: StandardColors.clockChrome,
      elevation: 16,
      shadowColor: Colors.black,
      shape: StadiumBorder(
        side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final action in actions)
              TextButton(
                focusNode: action.focusNode,
                onPressed: action.onPressed,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text(action.label),
              ),
          ],
        ),
      ),
    );
  }
}
