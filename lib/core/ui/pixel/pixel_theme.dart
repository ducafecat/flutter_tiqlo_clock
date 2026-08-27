import 'package:flutter/material.dart';

import 'pixel_tokens.dart';

abstract final class PixelTheme {
  static const tokens = PixelTokens.dark();

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: tokens.chrome,
    colorScheme: ColorScheme.dark(
      primary: tokens.accent,
      surface: tokens.surface,
      onSurface: tokens.textPrimary,
      error: tokens.danger,
    ),
    extensions: const [tokens],
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'PixelifySans',
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'PixelifySans',
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
