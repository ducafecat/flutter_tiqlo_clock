import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pixel_theme_sheet_style.dart';
import 'pixel_tokens.dart';

enum PixelSheetLayout { theme, content }

class PixelSheet extends StatefulWidget {
  const PixelSheet({
    super.key,
    required this.child,
    this.layout = PixelSheetLayout.content,
  });

  final Widget child;
  final PixelSheetLayout layout;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    FocusNode? restoreFocus,
    PixelSheetLayout layout = PixelSheetLayout.content,
  }) {
    final tokens = PixelTokens.of(context);
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
      barrierColor: tokens.barrier,
      showDragHandle: false,
      sheetAnimationStyle: reduceMotion ? AnimationStyle.noAnimation : null,
      builder: (sheetContext) =>
          PixelSheet(layout: layout, child: builder(sheetContext)),
    ).whenComplete(() {
      if (restoreFocus?.canRequestFocus ?? false) {
        restoreFocus!.requestFocus();
      }
    });
  }

  @override
  State<PixelSheet> createState() => _PixelSheetState();
}

class _PixelSheetState extends State<PixelSheet> {
  late final FocusScopeNode _focusScope = FocusScopeNode(
    debugLabel: 'PixelSheet',
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
    final media = MediaQuery.of(context);
    final compact = media.size.width < 600;
    final landscape = media.orientation == Orientation.landscape;
    final maxHeightFactor = widget.layout == PixelSheetLayout.theme
        ? landscape
              ? PixelThemeSheetStyle.themeLandscapeMaxHeightFactor
              : compact
              ? 0.78
              : 0.8
        : 1.0;
    final bottomInset = widget.layout == PixelSheetLayout.theme
        ? PixelThemeSheetStyle.themeBottomInset
        : PixelThemeSheetStyle.bottomInset;
    final width = compact ? media.size.width : 720.0;

    final sheetContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: const SizedBox(
            height: PixelThemeSheetStyle.headerHeight,
            child: Center(child: PixelThemeDragHandle()),
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: widget.layout == PixelSheetLayout.theme
                  ? PixelThemeSheetStyle.themeScrollViewportBottomInset
                  : 0,
            ),
            child: SingleChildScrollView(
              key: const ValueKey('pixel-sheet-scroll'),
              padding: EdgeInsets.fromLTRB(
                PixelThemeSheetStyle.contentInset,
                0,
                PixelThemeSheetStyle.contentInset,
                bottomInset,
              ),
              child: widget.child,
            ),
          ),
        ),
      ],
    );

    final framedSheet = Padding(
      padding: const EdgeInsets.fromLTRB(
        PixelThemeSheetStyle.sheetInset,
        0,
        PixelThemeSheetStyle.sheetInset,
        PixelThemeSheetStyle.sheetInset,
      ),
      child: PixelThemeSheetFrame(child: sheetContent),
    );

    return FocusScope.withExternalFocusNode(
      focusScopeNode: _focusScope,
      child: Focus(
        autofocus: true,
        skipTraversal: true,
        onKeyEvent: _handleKey,
        child: SizedBox(
          width: width,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: media.size.height * maxHeightFactor,
            ),
            child: framedSheet,
          ),
        ),
      ),
    );
  }
}
