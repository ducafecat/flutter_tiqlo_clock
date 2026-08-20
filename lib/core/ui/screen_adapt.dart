import 'package:flutter/widgets.dart';

import '../config/app_config.dart';

/// 屏幕适配工具。
///
/// 职责：
/// - 基于设计稿尺寸计算宽高缩放。
/// - 提供字体、图标、圆角的温和缩放，避免大屏过度放大或小屏过度压缩。
///
/// ⚠️ 注意：
/// 不建议把所有尺寸都无脑缩放；复杂布局仍应优先使用弹性布局、约束和断点。
class ScreenAdapt {
  ScreenAdapt(this.context);

  final BuildContext context;

  Size get size => MediaQuery.sizeOf(context);
  EdgeInsets get padding => MediaQuery.paddingOf(context);
  double get screenWidth => size.width;
  double get screenHeight => size.height;
  double get wScale => screenWidth / AppConfig.ui.designWidth;
  double get hScale => screenHeight / AppConfig.ui.designHeight;

  /// 常用设备类型判断，供页面在必要时切换布局密度。
  bool get isSmallPhone => screenWidth < 375;
  bool get isPhone => screenWidth < 600;
  bool get isTablet => screenWidth >= 600;

  /// 按宽/高比例缩放基础尺寸。
  double w(double value) => value * wScale;
  double h(double value) => value * hScale;

  /// 圆角、图标、字体使用 clamp 限制缩放范围，避免视觉失控。
  double radius(double value) => value * wScale.clamp(0.95, 1.12);
  double icon(double value) => value * wScale.clamp(0.95, 1.10);
  double font(double value) => value * wScale.clamp(0.98, 1.08);
}
