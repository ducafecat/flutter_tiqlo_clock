import 'package:flutter/material.dart';

/// Standard UI 的语义颜色。
///
/// 常规页面通过 ThemeData/ColorScheme 使用这些颜色；沉浸式 Clock、Splash
/// 和 Welcome 的品牌色也集中在这里，避免散落于业务页面。
abstract final class StandardColors {
  static const lightBackground = Color(0xFFF9F6EF);
  static const lightForeground = Color(0xFF4A3F2F);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightCardForeground = Color(0xFF1A1814);
  static const lightPrimary = Color(0xFFBF6A2E);
  static const lightPrimaryForeground = Color(0xFFFFFFFF);
  static const lightMuted = Color(0xFFEBE5D0);
  static const lightMutedForeground = Color(0xFF847E6A);
  static const lightDestructive = Color(0xFFD04B2B);
  static const lightDestructiveForeground = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFD9D0B8);

  static const darkBackground = Color(0xFF2D2A24);
  static const darkForeground = Color(0xFFCCC3A8);
  static const darkCard = Color(0xFF373330);
  static const darkCardForeground = Color(0xFFF9F6EF);
  static const darkPrimary = Color(0xFFCA7835);
  static const darkPrimaryForeground = Color(0xFFFFFFFF);
  static const darkMuted = Color(0xFF222019);
  static const darkMutedForeground = Color(0xFFBFB89E);
  static const darkDestructive = Color(0xFFD04B2B);
  static const darkDestructiveForeground = Color(0xFFFFFFFF);
  static const darkBorder = Color(0xFF474038);

  static const welcomeAccent = Color(0xFFE8B66B);
  static const clockChrome = Color(0xE61C1C1E);
  static const clockSheet = Color(0xFF1C1C1E);
  static const moreSheet = Color(0xFF212121);
  static const sheetBarrier = Color(0xC2000000);
}

/// Standard UI 的间距节奏。
abstract final class StandardSpacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}

/// Standard UI 的圆角语义。
abstract final class StandardRadius {
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;
  static const double modal = 28;
  static const double pill = 999;

  static BorderRadius get card => BorderRadius.circular(xl);
  static BorderRadius get modalBorderRadius => BorderRadius.circular(modal);
  static BorderRadius get control => BorderRadius.circular(lg);
  static BorderRadius get pillBorderRadius => BorderRadius.circular(pill);
}

/// Standard UI 的文字层级。
abstract final class StandardTextStyles {
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

  static TextStyle displayOn(BuildContext context) =>
      display.copyWith(color: Theme.of(context).colorScheme.onSurface);
  static TextStyle pageTitleOn(BuildContext context) =>
      pageTitle.copyWith(color: Theme.of(context).colorScheme.onSurface);
  static TextStyle sectionTitleOn(BuildContext context) =>
      sectionTitle.copyWith(color: Theme.of(context).colorScheme.onSurface);
  static TextStyle bodyOn(BuildContext context) =>
      body.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color);
  static TextStyle secondaryOn(BuildContext context) =>
      secondary.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
  static TextStyle metaOn(BuildContext context) =>
      meta.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
  static TextStyle labelOn(BuildContext context) =>
      label.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
  static TextStyle captionOn(BuildContext context) =>
      caption.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

  static TextTheme textTheme({required Brightness brightness}) {
    final cardForeground = brightness == Brightness.dark
        ? StandardColors.darkCardForeground
        : StandardColors.lightCardForeground;
    final foreground = brightness == Brightness.dark
        ? StandardColors.darkForeground
        : StandardColors.lightForeground;
    final mutedForeground = brightness == Brightness.dark
        ? StandardColors.darkMutedForeground
        : StandardColors.lightMutedForeground;
    return TextTheme(
      displaySmall: display.copyWith(color: cardForeground),
      headlineSmall: pageTitle.copyWith(color: cardForeground),
      titleLarge: sectionTitle.copyWith(color: cardForeground),
      bodyLarge: body.copyWith(color: foreground),
      bodyMedium: secondary.copyWith(color: foreground),
      bodySmall: meta.copyWith(color: mutedForeground),
      labelSmall: label.copyWith(color: mutedForeground),
    );
  }
}
