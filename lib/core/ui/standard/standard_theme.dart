import 'package:flutter/material.dart';

abstract final class StandardTheme {
  static const background = Color(0xFF2D2A24);
  static const surface = Color(0xFF373330);
  static const primary = Color(0xFFCA7835);
  static const outline = Color(0xFF5C554B);
  static const text = Color(0xFFF9F6EF);
  static const secondaryText = Color(0xFFBFB89E);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    canvasColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      onPrimary: Colors.white,
      secondary: Color(0xFF847E6A),
      onSecondary: text,
      surface: surface,
      onSurface: text,
      error: Color(0xFFD04B2B),
      onError: Colors.white,
      outline: outline,
      surfaceContainerHighest: Color(0xFF222019),
      onSurfaceVariant: secondaryText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: text,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: outline),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: outline,
      thickness: 1,
      space: 1,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: text,
      iconColor: secondaryText,
      minTileHeight: 56,
    ),
  );
}
