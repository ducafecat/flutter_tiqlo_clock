import 'dart:ui';

enum DigitalThemeId {
  digital,
  digitalBlue,
  digitalRed,
  digitalAmber,
  digitalOrange,
  pureDark,
  dark,
  light,
  classic,
}

class DigitalTheme {
  const DigitalTheme({
    required this.background,
    required this.digit,
    required this.secondary,
  });

  final Color background;
  final Color digit;
  final Color secondary;
}

extension DigitalThemeIdX on DigitalThemeId {
  String get label => switch (this) {
    DigitalThemeId.digital => 'Digital',
    DigitalThemeId.digitalBlue => 'Digital-Blue',
    DigitalThemeId.digitalRed => 'Digital-Red',
    DigitalThemeId.digitalAmber => 'Digital-Amber',
    DigitalThemeId.digitalOrange => 'Digital-Orange',
    DigitalThemeId.pureDark => 'Pure Dark',
    DigitalThemeId.dark => 'Dark',
    DigitalThemeId.light => 'Light',
    DigitalThemeId.classic => 'Classic',
  };

  DigitalTheme get theme => switch (this) {
    DigitalThemeId.digital => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFF39FF14),
      secondary: Color(0xFF168B12),
    ),
    DigitalThemeId.digitalBlue => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFF00BFFF),
      secondary: Color(0xFF087FA8),
    ),
    DigitalThemeId.digitalRed => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFFFF3030),
      secondary: Color(0xFFA81919),
    ),
    DigitalThemeId.digitalAmber => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFFFFBF00),
      secondary: Color(0xFF9D7600),
    ),
    DigitalThemeId.digitalOrange => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFFFF7A00),
      secondary: Color(0xFFA54F00),
    ),
    DigitalThemeId.pureDark => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFFF5F5F5),
      secondary: Color(0xFF737373),
    ),
    DigitalThemeId.dark => const DigitalTheme(
      background: Color(0xFF171717),
      digit: Color(0xFFF5F5F5),
      secondary: Color(0xFF737373),
    ),
    DigitalThemeId.light => const DigitalTheme(
      background: Color(0xFFF5F5F5),
      digit: Color(0xFF171717),
      secondary: Color(0xFF737373),
    ),
    DigitalThemeId.classic => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFFFFFFFF),
      secondary: Color(0xFF666666),
    ),
  };
}
