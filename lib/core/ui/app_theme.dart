import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

/// 应用主题工厂。
///
/// 职责：
/// - 将颜色、字体、圆角等设计 token 汇总为 Flutter ThemeData。
/// - 同时提供亮色与暗色主题，交给 AdaptiveTheme 在运行时切换。
///
/// 设计原则：
/// 页面组件优先使用 Theme / AppColors / AppTextStyles，避免散落硬编码样式。
abstract final class AppTheme {
  /// 阴影透明度按亮暗主题分开，暗色下稍强一点以维持层次。
  static const _shadowLight = Color(0x1A000000);
  static const _shadowDark = Color(0x26000000);

  /// 亮色主题入口。
  static ThemeData get lightTheme => _build(
    brightness: Brightness.light,
    background: AppColors.lightBackground,
    card: AppColors.lightCard,
    primary: AppColors.lightPrimary,
    primaryFg: AppColors.lightPrimaryFg,
    onSurface: AppColors.lightCardFg,
    outline: AppColors.lightBorder,
    muted: AppColors.lightMuted,
    mutedFg: AppColors.lightMutedFg,
    shadow: _shadowLight,
    textTheme: AppTextStyles.lightTextTheme,
  );

  /// 暗色主题入口。
  static ThemeData get darkTheme => _build(
    brightness: Brightness.dark,
    background: AppColors.darkBackground,
    card: AppColors.darkCard,
    primary: AppColors.darkPrimary,
    primaryFg: AppColors.darkPrimaryFg,
    onSurface: AppColors.darkCardFg,
    outline: AppColors.darkBorder,
    muted: AppColors.darkMuted,
    mutedFg: AppColors.darkMutedFg,
    shadow: _shadowDark,
    textTheme: AppTextStyles.darkTextTheme,
  );

  /// 构建 ThemeData 的公共方法。
  ///
  /// 通过参数注入亮暗主题差异，避免 lightTheme/darkTheme 维护两份近似重复的 ThemeData。
  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color card,
    required Color primary,
    required Color primaryFg,
    required Color onSurface,
    required Color outline,
    required Color muted,
    required Color mutedFg,
    required Color shadow,
    required TextTheme textTheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      shadowColor: shadow,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: primaryFg,
        secondary: muted,
        onSecondary: mutedFg,
        surface: card,
        onSurface: onSurface,
        error: brightness == Brightness.dark
            ? AppColors.darkDestructive
            : AppColors.lightDestructive,
        onError: brightness == Brightness.dark
            ? AppColors.darkDestructiveFg
            : AppColors.lightDestructiveFg,
        outline: outline,
        outlineVariant: muted,
        surfaceContainerHighest: muted,
        onSurfaceVariant: mutedFg,
      ),
      // TextTheme 让 Material 组件（AppBar、Button、Input 等）获得统一字体基线。
      textTheme: textTheme,
      dividerColor: outline,
      appBarTheme: AppBarTheme(
        backgroundColor: card,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide(color: outline),
        ),
      ),
      dividerTheme: DividerThemeData(color: outline, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: muted,
        selectedColor: primary,
        disabledColor: muted,
        checkmarkColor: Colors.transparent,
        labelStyle: TextStyle(
          color: mutedFg,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        secondaryLabelStyle: TextStyle(
          color: primaryFg,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        side: BorderSide.none,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryFg,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: mutedFg,
          minimumSize: const Size(36, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        hintStyle: TextStyle(color: mutedFg, fontSize: 15),
      ),
    );
  }
}
