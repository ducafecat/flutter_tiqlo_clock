import 'package:flutter/material.dart';

import '../pixel/pixel_ui.dart';
import '../standard/standard_ui.dart';
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
    return StandardSwitch(
      label: label,
      value: value,
      onChanged: onChanged,
      compact: compact,
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
    return StandardActionTile(
      label: label,
      onPressed: onPressed,
      leading: leading,
      trailing: trailing,
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
    return StandardSelectionTile(
      label: label,
      selected: selected,
      onSelected: onSelected,
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
    return StandardColorOption(
      label: label,
      colors: colors,
      selected: selected,
      onSelected: onSelected,
      minWidth: minWidth,
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
    return StandardTextButton(
      label: label,
      focusNode: focusNode,
      onPressed: onPressed,
      prominent: prominent,
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
    return StandardPageIndicator(
      pageCount: pageCount,
      currentPage: currentPage,
      duration: ui.motionDuration(context, ui.welcomeContentDuration),
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

    return StandardToolbar(
      actions: [
        for (final action in actions)
          StandardToolbarAction(
            label: action.label,
            onPressed: action.onPressed,
            focusNode: action.focusNode,
          ),
      ],
    );
  }
}
