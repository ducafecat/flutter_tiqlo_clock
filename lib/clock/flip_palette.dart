import 'dart:ui';

enum FlipPaletteId {
  pureDark,
  dark,
  light,
  green,
  blue,
  red,
  orange,
  yellow,
  purple,
  pink,
}

class FlipPalette {
  const FlipPalette({
    required this.background,
    required this.cardTop,
    required this.cardBottom,
    required this.digit,
    required this.divider,
  });

  final Color background;
  final Color cardTop;
  final Color cardBottom;
  final Color digit;
  final Color divider;
}

extension FlipPaletteIdX on FlipPaletteId {
  String get label => switch (this) {
    FlipPaletteId.pureDark => 'Pure Dark',
    FlipPaletteId.dark => 'Dark',
    FlipPaletteId.light => 'Light',
    FlipPaletteId.green => 'Green',
    FlipPaletteId.blue => 'Blue',
    FlipPaletteId.red => 'Red',
    FlipPaletteId.orange => 'Orange',
    FlipPaletteId.yellow => 'Yellow',
    FlipPaletteId.purple => 'Purple',
    FlipPaletteId.pink => 'Pink',
  };

  FlipPalette get palette => switch (this) {
    FlipPaletteId.pureDark => const FlipPalette(
      background: Color(0xFF000000),
      cardTop: Color(0xFF181818),
      cardBottom: Color(0xFF151515),
      digit: Color(0xFFF5F5F5),
      divider: Color(0xFF000000),
    ),
    FlipPaletteId.dark => const FlipPalette(
      background: Color(0xFF121212),
      cardTop: Color(0xFF292929),
      cardBottom: Color(0xFF222222),
      digit: Color(0xFFF5F5F5),
      divider: Color(0xFF111111),
    ),
    FlipPaletteId.light => const FlipPalette(
      background: Color(0xFFEEEEEE),
      cardTop: Color(0xFFFFFFFF),
      cardBottom: Color(0xFFF4F4F4),
      digit: Color(0xFF111111),
      divider: Color(0xFFD0D0D0),
    ),
    FlipPaletteId.green => const FlipPalette(
      background: Color(0xFF07140D),
      cardTop: Color(0xFF18864A),
      cardBottom: Color(0xFF14713E),
      digit: Color(0xFFFFFFFF),
      divider: Color(0x4D000000),
    ),
    FlipPaletteId.blue => const FlipPalette(
      background: Color(0xFF07111F),
      cardTop: Color(0xFF2563EB),
      cardBottom: Color(0xFF1D4ED8),
      digit: Color(0xFFFFFFFF),
      divider: Color(0x4D000000),
    ),
    FlipPaletteId.red => const FlipPalette(
      background: Color(0xFF190707),
      cardTop: Color(0xFFDC2626),
      cardBottom: Color(0xFFB91C1C),
      digit: Color(0xFFFFFFFF),
      divider: Color(0x4D000000),
    ),
    FlipPaletteId.orange => const FlipPalette(
      background: Color(0xFF1A0C05),
      cardTop: Color(0xFFEA580C),
      cardBottom: Color(0xFFC2410C),
      digit: Color(0xFFFFFFFF),
      divider: Color(0x4D000000),
    ),
    FlipPaletteId.yellow => const FlipPalette(
      background: Color(0xFF171305),
      cardTop: Color(0xFFFACC15),
      cardBottom: Color(0xFFEAB308),
      digit: Color(0xFF111111),
      divider: Color(0x40000000),
    ),
    FlipPaletteId.purple => const FlipPalette(
      background: Color(0xFF10091A),
      cardTop: Color(0xFF7C3AED),
      cardBottom: Color(0xFF6D28D9),
      digit: Color(0xFFFFFFFF),
      divider: Color(0x4D000000),
    ),
    FlipPaletteId.pink => const FlipPalette(
      background: Color(0xFF190A11),
      cardTop: Color(0xFFDB2777),
      cardBottom: Color(0xFFBE185D),
      digit: Color(0xFFFFFFFF),
      divider: Color(0x4D000000),
    ),
  };
}
