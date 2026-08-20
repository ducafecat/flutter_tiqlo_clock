import 'package:flutter/material.dart';

import '../../core/ui/ui.dart';

/// 分区标题组件。
///
/// 职责：
/// - 用统一的 label 样式展示 section 标题。
/// - 支持右侧 trailing 操作，例如“查看全部”按钮或筛选入口。
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.labelOn(context),
          ),
        ),
        // Dart pattern matching：仅在 trailing 非空时渲染右侧组件。
        if (trailing case final Widget widget) widget,
      ],
    );
  }
}
