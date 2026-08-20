import 'package:flutter/widgets.dart';

/// 安全区快捷扩展。
///
/// 适用于自定义全屏布局、底部按钮、沉浸式 AppBar 等需要读取刘海/手势区域的场景。
extension SafeAreaExt on BuildContext {
  EdgeInsets get safeAreaPadding => MediaQuery.paddingOf(this);
  double get safeTop => safeAreaPadding.top;
  double get safeBottom => safeAreaPadding.bottom;
  double get safeLeft => safeAreaPadding.left;
  double get safeRight => safeAreaPadding.right;
}
