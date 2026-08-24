import 'package:flutter/material.dart';

import '../../core/ui/ui.dart';

/// 设置项行组件。
///
/// 职责：
/// - 提供统一的左右布局：leading / label / trailing。
/// - 通过 InkWell 保留 Material 点击反馈。
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.label,
    this.trailing,
    this.leading,
    this.onTap,
  });

  final String label;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // pattern matching 写法可避免先判空再强转。
            if (leading case final Widget widget) ...[
              widget,
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(label, style: AppTextStyles.bodyOn(context))),
            if (trailing case final Widget widget) widget,
          ],
        ),
      ),
    );
  }
}

/// 设置分组容器。
///
/// 职责：
/// - 把多个 SettingsTile 组合成带边框、圆角和分隔线的组。
/// - 统一处理首尾裁剪，保证涟漪和内容不会溢出圆角。
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    // 在子项之间插入分隔线，避免调用方手动维护 Divider。
    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i != children.length - 1) {
        items.add(Divider(height: 1, color: context.appBorder));
      }
    }

    return Material(
      color: context.appCard,
      elevation: 1,
      shadowColor: const Color(0x14000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: BorderSide(color: context.appBorder),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: items),
    );
  }
}
