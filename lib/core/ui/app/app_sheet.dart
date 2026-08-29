import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pixel/pixel_sheet.dart';
import '../pixel/pixel_theme_sheet_style.dart';
import '../standard/standard_ui.dart';
import 'app_ui_style.dart';
import 'app_ui_theme.dart';

enum AppSheetLayout { theme, content }

class AppSheetSectionTitle extends StatelessWidget {
  const AppSheetSectionTitle({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.standard) {
      return StandardSheetSectionTitle(label: label);
    }
    final ui = AppUiTheme.of(context);
    return Semantics(
      header: true,
      child: Text(
        label,
        style: ui
            .heading(fontSize: 18)
            .copyWith(color: PixelThemeSheetStyle.text),
      ),
    );
  }
}

class AppSheetGroup extends StatelessWidget {
  const AppSheetGroup({
    super.key,
    required this.children,
    this.showDividers = true,
    this.pixelSeparator,
    this.padding,
  });

  final List<Widget> children;
  final bool showDividers;
  final double? pixelSeparator;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      final gap = pixelSeparator ?? AppUiTheme.of(context).spacingXs;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) SizedBox(height: gap),
            children[index],
          ],
        ],
      );
    }
    return StandardSettingsGroup(
      showDividers: showDividers,
      children: [
        if (padding == null)
          ...children
        else
          Padding(
            padding: padding!,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
      ],
    );
  }
}

class AppSheet extends StatefulWidget {
  const AppSheet({
    super.key,
    required this.child,
    this.layout = AppSheetLayout.content,
  });

  final Widget child;
  final AppSheetLayout layout;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    FocusNode? restoreFocus,
    AppSheetLayout layout = AppSheetLayout.content,
  }) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      requestFocus: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xC2000000),
      showDragHandle: false,
      sheetAnimationStyle: reduceMotion ? AnimationStyle.noAnimation : null,
      builder: (sheetContext) =>
          AppSheet(layout: layout, child: builder(sheetContext)),
    ).whenComplete(() {
      if (restoreFocus?.canRequestFocus ?? false) {
        restoreFocus!.requestFocus();
      }
    });
  }

  @override
  State<AppSheet> createState() => _AppSheetState();
}

class _AppSheetState extends State<AppSheet> {
  late final FocusScopeNode _focusScope = FocusScopeNode(
    debugLabel: 'AppSheet',
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
    directionalTraversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );

  @override
  void dispose() {
    _focusScope.dispose();
    super.dispose();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.maybePop(context);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final child = AppUiScope.of(context) == AppUiStyle.pixel
        ? PixelSheet(
            layout: widget.layout == AppSheetLayout.theme
                ? PixelSheetLayout.theme
                : PixelSheetLayout.content,
            child: widget.child,
          )
        : StandardSheet(
            layout: widget.layout == AppSheetLayout.theme
                ? StandardSheetLayout.theme
                : StandardSheetLayout.content,
            child: widget.child,
          );
    return FocusScope.withExternalFocusNode(
      focusScopeNode: _focusScope,
      child: Focus(
        autofocus: true,
        skipTraversal: true,
        onKeyEvent: _handleKey,
        child: child,
      ),
    );
  }
}
