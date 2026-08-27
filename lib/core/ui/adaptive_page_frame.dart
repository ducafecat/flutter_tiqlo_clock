import 'package:flutter/material.dart';

/// 页面级响应式布局标准：竖屏使用受限的阅读宽度，横屏铺满 Safe Area。
///
/// 适用于包含页头和内容区的二级页面。页面内容可通过 [layout] 取得
/// 当前方向及实际内容宽度，以决定分栏、边距等细节。
class AdaptivePageFrame extends StatelessWidget {
  const AdaptivePageFrame({
    super.key,
    required this.portraitMaxWidth,
    required this.builder,
  });

  /// 竖屏内容最大宽度；小于该值的设备仍使用全部可用宽度。
  final double portraitMaxWidth;
  final AdaptivePageFrameBuilder builder;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: LayoutBuilder(
      builder: (context, viewport) {
        final isLandscape = viewport.maxWidth > viewport.maxHeight;
        final contentWidth = isLandscape
            ? viewport.maxWidth
            : viewport.maxWidth.clamp(0, portraitMaxWidth).toDouble();
        final layout = AdaptivePageLayout(
          isLandscape: isLandscape,
          contentWidth: contentWidth,
        );
        return Center(
          child: SizedBox(width: contentWidth, child: builder(context, layout)),
        );
      },
    ),
  );
}

typedef AdaptivePageFrameBuilder =
    Widget Function(BuildContext context, AdaptivePageLayout layout);

class AdaptivePageLayout {
  const AdaptivePageLayout({
    required this.isLandscape,
    required this.contentWidth,
  });

  final bool isLandscape;
  final double contentWidth;
}
