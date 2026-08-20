/// 响应式断点。
///
/// 职责：
/// - 给布局判断提供统一宽度阈值。
/// - 避免各页面自己写不同的 magic number。
abstract final class AdaptiveBreakpoints {
  static const double smallPhone = 360;
  static const double phone = 390;
  static const double largePhone = 430;
  static const double tablet = 600;
  static const double desktop = 1024;
}
