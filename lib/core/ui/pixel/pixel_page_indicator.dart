import 'package:flutter/material.dart';

import 'pixel_tokens.dart';

/// Welcome 等分页内容的当前页指示器。
class PixelPageIndicator extends StatelessWidget {
  const PixelPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  }) : assert(pageCount > 0),
       assert(currentPage >= 0 && currentPage < pageCount);

  final int pageCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return Semantics(
      label: '第 ${currentPage + 1} 页，共 $pageCount 页',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < pageCount; index++)
              AnimatedContainer(
                duration: tokens.motionDuration(
                  context,
                  tokens.welcomeContentDuration,
                ),
                width: index == currentPage ? 24 : 8,
                height: 8,
                margin: EdgeInsets.only(
                  right: index == pageCount - 1 ? 0 : tokens.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: index == currentPage ? tokens.accent : tokens.outline,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
