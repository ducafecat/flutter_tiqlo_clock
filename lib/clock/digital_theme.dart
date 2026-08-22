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
    this.glow = const [],
  });

  final Color background;
  final Color digit;
  final Color secondary;
  final List<Shadow> glow;
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
      glow: [
        Shadow(color: Color(0xCC39FF14), blurRadius: 4),
        Shadow(color: Color(0x5939FF14), blurRadius: 14),
      ],
    ),
    DigitalThemeId.digitalBlue => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFF00BFFF),
      secondary: Color(0xFF087FA8),
      glow: [
        Shadow(color: Color(0xCC00BFFF), blurRadius: 4),
        Shadow(color: Color(0x5900BFFF), blurRadius: 14),
      ],
    ),
    DigitalThemeId.digitalRed => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFFFF3030),
      secondary: Color(0xFFA81919),
      glow: [
        Shadow(color: Color(0xCCFF3030), blurRadius: 4),
        Shadow(color: Color(0x59FF3030), blurRadius: 14),
      ],
    ),
    DigitalThemeId.digitalAmber => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFFFFBF00),
      secondary: Color(0xFF9D7600),
      glow: [
        Shadow(color: Color(0xCCFFBF00), blurRadius: 4),
        Shadow(color: Color(0x59FFBF00), blurRadius: 14),
      ],
    ),
    DigitalThemeId.digitalOrange => const DigitalTheme(
      background: Color(0xFF000000),
      digit: Color(0xFFFF7A00),
      secondary: Color(0xFFA54F00),
      glow: [
        Shadow(color: Color(0xCCFF7A00), blurRadius: 4),
        Shadow(color: Color(0x59FF7A00), blurRadius: 14),
      ],
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
      glow: [Shadow(color: Color(0x59FFFFFF), blurRadius: 3)],
    ),
  };
}
