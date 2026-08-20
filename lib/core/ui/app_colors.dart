import 'package:flutter/material.dart';

/// 应用颜色 token。
///
/// 职责：
/// - 集中维护亮色/暗色主题用到的基础色值。
/// - 与 ThemeData、BuildContext 扩展共同组成可复用的视觉系统。
///
/// ⚠️ 注意：
/// 新增颜色前优先判断是否能复用现有语义色，避免页面逐渐变成“随手取色”。
abstract final class AppColors {
  static const lightBackground = Color(0xFFF9F6EF);
  static const lightForeground = Color(0xFF4A3F2F);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightCardFg = Color(0xFF1A1814);
  static const lightPrimary = Color(0xFFBF6A2E);
  static const lightPrimaryFg = Color(0xFFFFFFFF);
  static const lightMuted = Color(0xFFEBE5D0);
  static const lightMutedFg = Color(0xFF847E6A);
  static const lightDestructive = Color(0xFFD04B2B);
  static const lightDestructiveFg = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFD9D0B8);

  static const darkBackground = Color(0xFF2D2A24);
  static const darkForeground = Color(0xFFCCC3A8);
  static const darkCard = Color(0xFF373330);
  static const darkCardFg = Color(0xFFF9F6EF);
  static const darkPrimary = Color(0xFFCA7835);
  static const darkPrimaryFg = Color(0xFFFFFFFF);
  static const darkMuted = Color(0xFF222019);
  static const darkMutedFg = Color(0xFFBFB89E);
  static const darkDestructive = Color(0xFFD04B2B);
  static const darkDestructiveFg = Color(0xFFFFFFFF);
  static const darkBorder = Color(0xFF474038);
}

/// BuildContext 颜色扩展。
///
/// 用法：
/// - `context.appCard`、`context.appPrimary` 可根据当前亮暗主题自动返回对应颜色。
/// - 组件层不需要手动判断 Brightness。
extension AppColorsX on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get appBackground =>
      isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
  Color get appForeground =>
      isDarkMode ? AppColors.darkForeground : AppColors.lightForeground;
  Color get appCard => isDarkMode ? AppColors.darkCard : AppColors.lightCard;
  Color get appCardFg =>
      isDarkMode ? AppColors.darkCardFg : AppColors.lightCardFg;
  Color get appPrimary =>
      isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;
  Color get appPrimaryFg =>
      isDarkMode ? AppColors.darkPrimaryFg : AppColors.lightPrimaryFg;
  Color get appMuted => isDarkMode ? AppColors.darkMuted : AppColors.lightMuted;
  Color get appMutedFg =>
      isDarkMode ? AppColors.darkMutedFg : AppColors.lightMutedFg;
  Color get appDestructive =>
      isDarkMode ? AppColors.darkDestructive : AppColors.lightDestructive;
  Color get appDestructiveFg =>
      isDarkMode ? AppColors.darkDestructiveFg : AppColors.lightDestructiveFg;
  Color get appBorder =>
      isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
}
