import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 文本样式 token。
///
/// 职责：
/// - 为页面标题、正文、辅助文案、标签等提供统一字号与字重。
/// - 提供 `xxxOn(context)` 快捷方法，根据当前主题自动套用合适颜色。
abstract final class AppTextStyles {
  static const display = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w800,
    height: 1.14,
  );
  static const pageTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );
  static const sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );
  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.65,
  );
  static const secondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  static const meta = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.76,
    height: 1.2,
  );
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// 以下 `xxxOn` 方法只负责补颜色，不改变字号/行高/字重。
  /// 这样页面能保持统一排版，同时自然适配亮暗主题。
  static TextStyle displayOn(BuildContext context) =>
      display.copyWith(color: context.appCardFg);
  static TextStyle pageTitleOn(BuildContext context) =>
      pageTitle.copyWith(color: context.appCardFg);
  static TextStyle sectionTitleOn(BuildContext context) =>
      sectionTitle.copyWith(color: context.appCardFg);
  static TextStyle bodyOn(BuildContext context) =>
      body.copyWith(color: context.appForeground);
  static TextStyle secondaryOn(BuildContext context) =>
      secondary.copyWith(color: context.appMutedFg);
  static TextStyle metaOn(BuildContext context) =>
      meta.copyWith(color: context.appMutedFg);
  static TextStyle labelOn(BuildContext context) =>
      label.copyWith(color: context.appMutedFg);
  static TextStyle captionOn(BuildContext context) =>
      caption.copyWith(color: context.appMutedFg);

  /// Material 亮色 TextTheme 映射。
  ///
  /// 这里把项目语义样式映射到 Flutter 的标准槽位，供 AppBar、Button、Input 等默认组件读取。
  static TextTheme get lightTextTheme => const TextTheme(
    displaySmall: TextStyle(
      fontSize: 38,
      fontWeight: FontWeight.w800,
      color: AppColors.lightCardFg,
      height: 1.14,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.lightCardFg,
      height: 1.25,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.lightCardFg,
      height: 1.25,
    ),
    bodyLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.lightForeground,
      height: 1.65,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightForeground,
      height: 1.3,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.lightMutedFg,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      color: AppColors.lightMutedFg,
      letterSpacing: 1.76,
      height: 1.2,
    ),
  );

  /// Material 暗色 TextTheme 映射。
  static TextTheme get darkTextTheme => const TextTheme(
    displaySmall: TextStyle(
      fontSize: 38,
      fontWeight: FontWeight.w800,
      color: AppColors.darkCardFg,
      height: 1.14,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.darkCardFg,
      height: 1.25,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.darkCardFg,
      height: 1.25,
    ),
    bodyLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.darkForeground,
      height: 1.65,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkForeground,
      height: 1.3,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.darkMutedFg,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      color: AppColors.darkMutedFg,
      letterSpacing: 1.76,
      height: 1.2,
    ),
  );
}
