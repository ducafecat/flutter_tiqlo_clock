import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pixel/pixel_sheet.dart';
import 'app_ui_style.dart';

enum AppSheetLayout { theme, content }

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
        : _StandardSheet(layout: widget.layout, child: widget.child);
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

class _StandardSheet extends StatelessWidget {
  const _StandardSheet({required this.layout, required this.child});

  final AppSheetLayout layout;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = layout == AppSheetLayout.theme
        ? media.size.height *
              (media.orientation == Orientation.landscape ? 0.9 : 0.8)
        : media.size.height;
    final width = media.size.width > 720 ? 720.0 : media.size.width;
    return SizedBox(
      width: width,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  key: const ValueKey('standard-sheet-scroll'),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
