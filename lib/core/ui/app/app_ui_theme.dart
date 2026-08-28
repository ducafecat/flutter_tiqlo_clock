import 'package:flutter/material.dart';

import '../pixel/pixel_tokens.dart';
import '../standard/standard_theme.dart';
import 'app_ui_style.dart';

class AppUiTheme {
  const AppUiTheme._({
    required this.style,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMd,
    required this.spacingLg,
    required this.splashDuration,
    required this.welcomePageDuration,
    required this.welcomeContentDuration,
  });

  factory AppUiTheme.of(BuildContext context) {
    final style = AppUiScope.of(context);
    if (style == AppUiStyle.pixel) {
      final tokens = PixelTokens.of(context);
      return AppUiTheme._(
        style: style,
        background: tokens.background,
        surface: tokens.surface,
        textPrimary: tokens.textPrimary,
        textSecondary: tokens.textSecondary,
        accent: tokens.accent,
        spacingXs: tokens.spacingXs,
        spacingSm: tokens.spacingSm,
        spacingMd: tokens.spacingMd,
        spacingLg: tokens.spacingLg,
        splashDuration: tokens.splashDuration,
        welcomePageDuration: tokens.welcomePageDuration,
        welcomeContentDuration: tokens.welcomeContentDuration,
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return AppUiTheme._(
      style: style,
      background: scheme.surface,
      surface: scheme.surfaceContainerHighest,
      textPrimary: scheme.onSurface,
      textSecondary: scheme.onSurfaceVariant,
      accent: scheme.primary,
      spacingXs: 4,
      spacingSm: 8,
      spacingMd: 16,
      spacingLg: 24,
      splashDuration: const Duration(milliseconds: 900),
      welcomePageDuration: const Duration(milliseconds: 360),
      welcomeContentDuration: const Duration(milliseconds: 240),
    );
  }

  final AppUiStyle style;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final Duration splashDuration;
  final Duration welcomePageDuration;
  final Duration welcomeContentDuration;

  bool get isPixel => style == AppUiStyle.pixel;

  Duration motionDuration(BuildContext context, Duration duration) {
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false
        ? Duration.zero
        : duration;
  }

  TextStyle heading({double fontSize = 20}) => TextStyle(
    fontFamily: isPixel ? 'PixelifySans' : null,
    fontSize: fontSize,
    fontWeight: isPixel ? FontWeight.w600 : FontWeight.w700,
    color: textPrimary,
    height: 1.2,
  );

  TextStyle body({double fontSize = 16, Color? color}) => TextStyle(
    fontFamily: isPixel ? 'PixelifySans' : null,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    color: color ?? textPrimary,
    height: 1.35,
  );

  static ThemeData themeFor(AppUiStyle style) => switch (style) {
    AppUiStyle.pixel => throw StateError('Use PixelTheme.darkTheme.'),
    AppUiStyle.standard => StandardTheme.darkTheme,
  };
}
