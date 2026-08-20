import 'package:flutter/widgets.dart';

/// 圆角 token。
///
/// 职责：
/// - 将常用圆角尺寸集中命名，形成一致的组件形态。
/// - 提供 BorderRadius 快捷 getter，减少页面重复 `BorderRadius.circular(...)`。
abstract final class AppRadius {
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;
  static const double modal = 28;
  static const double pill = 999;

  static BorderRadius get cardBorderRadius => BorderRadius.circular(xl);
  static BorderRadius get modalBorderRadius => BorderRadius.circular(modal);
  static BorderRadius get chipBorderRadius => BorderRadius.circular(lg);
  static BorderRadius get pillBorderRadius => BorderRadius.circular(pill);
}
