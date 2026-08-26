import 'package:flutter/material.dart';

import 'pixel_tokens.dart';

abstract final class PixelTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF171612),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFE87512),
      surface: Color(0xFF26231F),
      onSurface: Color(0xFFF4F0E6),
      error: Color(0xFFD75A5A),
    ),
    extensions: const [PixelTokens.dark()],
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
