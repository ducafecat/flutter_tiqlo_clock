import 'package:flutter/material.dart';

import '../pixel/pixel_ui.dart';
import 'app_ui_style.dart';
import 'app_ui_theme.dart';

enum AppButtonTone { primary, secondary, danger }

class AppSwitch extends StatelessWidget {
  const AppSwitch({
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
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelSwitch(
        label: label,
        value: value,
        onChanged: onChanged,
        compact: compact,
      );
    }
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16),
      dense: compact,
    );
  }
}

class AppActionTile extends StatelessWidget {
  const AppActionTile({
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
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelActionTile(
        label: label,
        onPressed: onPressed,
        leading: leading,
        trailing: trailing,
      );
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: leading,
        trailing: trailing ?? const Icon(Icons.chevron_right),
        title: Text(label),
        onTap: onPressed,
      ),
    );
  }
}

class AppSelectionTile extends StatelessWidget {
  const AppSelectionTile({
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
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelSelectionTile(
        label: label,
        selected: selected,
        onSelected: onSelected,
      );
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      color: selected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surface,
      child: ListTile(
        title: Text(label),
        selected: selected,
        trailing: selected ? const Icon(Icons.check) : null,
        onTap: onSelected,
      ),
    );
  }
}

class AppColorOption extends StatelessWidget {
  const AppColorOption({
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
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelColorOption(
        label: label,
        colors: colors,
        selected: selected,
        onSelected: onSelected,
        minWidth: minWidth,
      );
    }
    final swatch = colors.first.computeLuminance() < 0.02 && colors.length > 1
        ? colors[1]
        : colors.first;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: ChoiceChip(
        avatar: CircleAvatar(backgroundColor: swatch),
        label: Text(label),
        selected: selected,
        onSelected: onSelected == null ? null : (_) => onSelected!(),
      ),
    );
  }
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({
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
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelTextButton(
        label: label,
        onPressed: onPressed,
        focusNode: focusNode,
        prominent: prominent,
      );
    }
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

class AppPageIndicator extends StatelessWidget {
  const AppPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  final int pageCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelPageIndicator(pageCount: pageCount, currentPage: currentPage);
    }
    final ui = AppUiTheme.of(context);
    return Semantics(
      label: '第 ${currentPage + 1} 页，共 $pageCount 页',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < pageCount; index++)
              AnimatedContainer(
                duration: ui.motionDuration(context, ui.welcomeContentDuration),
                width: index == currentPage ? 24 : 7,
                height: 7,
                margin: EdgeInsets.only(right: index == pageCount - 1 ? 0 : 7),
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? ui.accent
                      : ui.textSecondary.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppToolbarAction {
  const AppToolbarAction({
    required this.label,
    required this.onPressed,
    this.tone = AppButtonTone.secondary,
    this.focusNode,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonTone tone;
  final FocusNode? focusNode;
}

class AppToolbar extends StatelessWidget {
  const AppToolbar({super.key, required this.actions});

  final List<AppToolbarAction> actions;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelToolbar(
        actions: [
          for (final action in actions)
            PixelToolbarAction(
              label: action.label,
              onPressed: action.onPressed,
              focusNode: action.focusNode,
              tone: switch (action.tone) {
                AppButtonTone.primary => PixelButtonTone.primary,
                AppButtonTone.secondary => PixelButtonTone.secondary,
                AppButtonTone.danger => PixelButtonTone.danger,
              },
            ),
        ],
      );
    }

    final portrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    final buttons = [for (final action in actions) _StandardButton(action)];
    if (portrait && MediaQuery.sizeOf(context).width < 600) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < buttons.length; index++) ...[
              if (index > 0) const SizedBox(height: 8),
              buttons[index],
            ],
          ],
        ),
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: buttons,
    );
  }
}

class _StandardButton extends StatelessWidget {
  const _StandardButton(this.action);

  final AppToolbarAction action;

  @override
  Widget build(BuildContext context) {
    final style = action.tone == AppButtonTone.danger
        ? FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          )
        : null;
    return FilledButton.tonal(
      focusNode: action.focusNode,
      style: style,
      onPressed: action.onPressed,
      child: Text(action.label),
    );
  }
}
