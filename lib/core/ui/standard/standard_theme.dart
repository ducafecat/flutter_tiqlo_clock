import 'package:flutter/material.dart';

import 'standard_tokens.dart';

abstract final class StandardTheme {
  static final ThemeData lightTheme = _build(
    brightness: Brightness.light,
    background: StandardColors.lightBackground,
    card: StandardColors.lightCard,
    cardForeground: StandardColors.lightCardForeground,
    primary: StandardColors.lightPrimary,
    primaryForeground: StandardColors.lightPrimaryForeground,
    muted: StandardColors.lightMuted,
    mutedForeground: StandardColors.lightMutedForeground,
    destructive: StandardColors.lightDestructive,
    destructiveForeground: StandardColors.lightDestructiveForeground,
    border: StandardColors.lightBorder,
    shadow: const Color(0x1A000000),
  );

  static final ThemeData darkTheme = _build(
    brightness: Brightness.dark,
    background: StandardColors.darkBackground,
    card: StandardColors.darkCard,
    cardForeground: StandardColors.darkCardForeground,
    primary: StandardColors.darkPrimary,
    primaryForeground: StandardColors.darkPrimaryForeground,
    muted: StandardColors.darkMuted,
    mutedForeground: StandardColors.darkMutedForeground,
    destructive: StandardColors.darkDestructive,
    destructiveForeground: StandardColors.darkDestructiveForeground,
    border: StandardColors.darkBorder,
    shadow: const Color(0x26000000),
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color card,
    required Color cardForeground,
    required Color primary,
    required Color primaryForeground,
    required Color muted,
    required Color mutedForeground,
    required Color destructive,
    required Color destructiveForeground,
    required Color border,
    required Color shadow,
  }) {
    final textTheme = StandardTextStyles.textTheme(brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      shadowColor: shadow,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: primaryForeground,
        secondary: muted,
        onSecondary: mutedForeground,
        surface: card,
        onSurface: cardForeground,
        error: destructive,
        onError: destructiveForeground,
        outline: border,
        outlineVariant: muted,
        surfaceContainerHighest: muted,
        onSurfaceVariant: mutedForeground,
      ),
      textTheme: textTheme,
      dividerColor: border,
      appBarTheme: AppBarTheme(
        backgroundColor: card,
        foregroundColor: cardForeground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: StandardTextStyles.pageTitle.copyWith(
          color: cardForeground,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: StandardRadius.card,
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: muted,
        selectedColor: primary,
        disabledColor: muted,
        checkmarkColor: Colors.transparent,
        labelStyle: TextStyle(
          color: mutedForeground,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        secondaryLabelStyle: TextStyle(
          color: primaryForeground,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: StandardSpacing.sm,
          vertical: StandardRadius.md,
        ),
        shape: RoundedRectangleBorder(borderRadius: StandardRadius.control),
        side: BorderSide.none,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: StandardSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: StandardRadius.control),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: StandardSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: StandardRadius.control),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: StandardSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: StandardRadius.control),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: mutedForeground,
          minimumSize: const Size(36, 36),
          shape: RoundedRectangleBorder(borderRadius: StandardRadius.control),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: StandardSpacing.md,
          vertical: StandardSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: StandardRadius.control,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: StandardRadius.control,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: StandardRadius.control,
          borderSide: BorderSide(color: primary, width: 2),
        ),
        hintStyle: TextStyle(color: mutedForeground, fontSize: 15),
      ),
      listTileTheme: ListTileThemeData(
        textColor: cardForeground,
        iconColor: mutedForeground,
        minTileHeight: 56,
      ),
    );
  }
}
