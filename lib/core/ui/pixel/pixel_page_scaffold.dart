import 'package:flutter/material.dart';

import '../adaptive_page_frame.dart';
import 'pixel_page_header.dart';
import 'pixel_tokens.dart';

typedef PixelPageBodyBuilder =
    Widget Function(BuildContext context, AdaptivePageLayout layout);

/// 二级页面的统一外壳。
///
/// 统一处理页面背景、Safe Area、阅读宽度、页头和内容区约束。业务页面只负责
/// 提供标题、返回行为和正文，避免重复组合 Scaffold、AdaptivePageFrame 与页头。
class PixelPageScaffold extends StatelessWidget {
  const PixelPageScaffold({
    super.key,
    required this.title,
    required this.onBack,
    required this.portraitMaxWidth,
    required this.builder,
  });

  final String title;
  final VoidCallback onBack;
  final double portraitMaxWidth;
  final PixelPageBodyBuilder builder;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);

    return Scaffold(
      backgroundColor: tokens.chrome,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.5, -0.8),
            radius: 1.2,
            colors: [tokens.chromeHighlight, tokens.chrome],
          ),
        ),
        child: AdaptivePageFrame(
          portraitMaxWidth: portraitMaxWidth,
          builder: (context, layout) => Column(
            children: [
              PixelPageHeader(title: title, onBack: onBack),
              Expanded(child: builder(context, layout)),
            ],
          ),
        ),
      ),
    );
  }
}

/// 二级页面中普通分组列表的标准内边距和垂直节奏。
class PixelPageList extends StatelessWidget {
  const PixelPageList({
    super.key,
    required this.layout,
    required this.children,
  });

  final AdaptivePageLayout layout;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final items = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      items.add(children[index]);
      if (index != children.length - 1) {
        items.add(SizedBox(height: tokens.spacingLg));
      }
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(
        layout.isLandscape ? tokens.spacingLg : tokens.spacingMd,
        tokens.spacingLg,
        layout.isLandscape ? tokens.spacingLg : tokens.spacingMd,
        tokens.spacingLg + tokens.spacingSm,
      ),
      children: items,
    );
  }
}
