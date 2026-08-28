import 'package:flutter/material.dart';

import 'standard_tokens.dart';

enum StandardSheetLayout { theme, content }

class StandardSheetSectionTitle extends StatelessWidget {
  const StandardSheetSectionTitle({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StandardSpacing.xs,
          vertical: StandardSpacing.xs,
        ),
        child: Text(
          label,
          style: StandardTextStyles.meta.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

/// Standard UI 的底部弹层实现。
///
/// 最大高度、阅读宽度、品牌背景、拖拽柄和滚动都封装在模块内部，调用方只
/// 提供内容。
class StandardSheet extends StatelessWidget {
  const StandardSheet({
    super.key,
    required this.child,
    this.layout = StandardSheetLayout.content,
  });

  final Widget child;
  final StandardSheetLayout layout;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isThemeSheet = layout == StandardSheetLayout.theme;
    final maxHeight = isThemeSheet
        ? media.size.height *
              (media.orientation == Orientation.landscape ? 0.9 : 0.8)
        : media.size.height;
    final width = media.size.width > 720 ? 720.0 : media.size.width;
    final background = isThemeSheet
        ? StandardColors.clockSheet
        : StandardColors.moreSheet;
    final baseTheme = Theme.of(context);
    final foreground = Colors.white;
    final sheetTheme = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        surface: background,
        onSurface: foreground,
        onSurfaceVariant: Colors.white70,
        outline: Colors.white.withValues(alpha: 0.12),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        displaySmall: baseTheme.textTheme.displaySmall?.copyWith(
          color: foreground,
        ),
        headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
          color: foreground,
        ),
        titleLarge: baseTheme.textTheme.titleLarge?.copyWith(color: foreground),
        bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(color: foreground),
        bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(color: foreground),
        bodySmall: baseTheme.textTheme.bodySmall?.copyWith(
          color: Colors.white70,
        ),
        labelSmall: baseTheme.textTheme.labelSmall?.copyWith(
          color: Colors.white70,
        ),
      ),
      listTileTheme: baseTheme.listTileTheme.copyWith(
        textColor: foreground,
        iconColor: Colors.white70,
      ),
    );

    return SizedBox(
      width: width,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Theme(
          data: sheetTheme,
          child: Material(
            color: background,
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(StandardRadius.modal),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isThemeSheet) ...[
                  const SizedBox(height: StandardSpacing.sm),
                  Container(
                    width: 36,
                    height: StandardRadius.sm,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: StandardRadius.pillBorderRadius,
                    ),
                  ),
                ],
                Flexible(
                  child: SingleChildScrollView(
                    key: const ValueKey('standard-sheet-scroll'),
                    padding: EdgeInsets.fromLTRB(
                      StandardSpacing.md,
                      isThemeSheet ? StandardSpacing.md : StandardSpacing.sm,
                      StandardSpacing.md,
                      StandardSpacing.lg,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
