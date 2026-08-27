/// 间距 token。
///
/// 新 UI 应从 `PixelTokens.of(context)` 读取间距。此静态别名只用于无法取得
/// BuildContext 的兼容代码，并与 PixelTokens 的 4 / 8 / 16 / 24 节奏保持一致。
@Deprecated('Use PixelTokens.of(context) spacing values in UI code.')
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}
