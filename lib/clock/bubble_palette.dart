import 'dart:ui';

enum BubblePaletteId {
  blue,
  violet,
  coral,
  pink,
  amber,
  red,
  green,
  cyan,
  greenMix,
  blueOrange,
}

class BubblePalette {
  const BubblePalette({
    required this.background,
    required this.digit1,
    required this.digit2,
    required this.digit3,
    required this.digit4,
    required this.colonTop,
    required this.colonBottom,
  });

  final Color background;
  final Color digit1;
  final Color digit2;
  final Color digit3;
  final Color digit4;
  final Color colonTop;
  final Color colonBottom;

  List<Color> get digits => [digit1, digit2, digit3, digit4];

  static const night = BubblePalette(
    background: Color(0xFF020000),
    digit1: Color(0xFF8F1717),
    digit2: Color(0xFF8F1717),
    digit3: Color(0xFF8F1717),
    digit4: Color(0xFF8F1717),
    colonTop: Color(0xFFB52A2A),
    colonBottom: Color(0xFFB52A2A),
  );
}

extension BubblePaletteIdX on BubblePaletteId {
  String get label => switch (this) {
    BubblePaletteId.blue => 'Blue',
    BubblePaletteId.violet => 'Violet',
    BubblePaletteId.coral => 'Coral',
    BubblePaletteId.pink => 'Pink',
    BubblePaletteId.amber => 'Amber',
    BubblePaletteId.red => 'Red',
    BubblePaletteId.green => 'Green',
    BubblePaletteId.cyan => 'Cyan',
    BubblePaletteId.greenMix => 'Green Mix',
    BubblePaletteId.blueOrange => 'Blue Orange',
  };

  BubblePalette get palette => switch (this) {
    BubblePaletteId.blue => const BubblePalette(
      background: Color(0xFF030507),
      digit1: Color(0xFF0B5CF7),
      digit2: Color(0xFF41A4FF),
      digit3: Color(0xFF0757F0),
      digit4: Color(0xFF48A8FF),
      colonTop: Color(0xFFF1D7F4),
      colonBottom: Color(0xFFF1D7F4),
    ),
    BubblePaletteId.violet => const BubblePalette(
      background: Color(0xFF05030A),
      digit1: Color(0xFFB391FF),
      digit2: Color(0xFF8B63EA),
      digit3: Color(0xFFD1A2FF),
      digit4: Color(0xFF865DE2),
      colonTop: Color(0xFFFFDDF0),
      colonBottom: Color(0xFFFFDDF0),
    ),
    BubblePaletteId.coral => const BubblePalette(
      background: Color(0xFF090405),
      digit1: Color(0xFFFF8A7A),
      digit2: Color(0xFFE95B68),
      digit3: Color(0xFFFFB27A),
      digit4: Color(0xFFFF7468),
      colonTop: Color(0xFFFFD9D1),
      colonBottom: Color(0xFFFFD9D1),
    ),
    BubblePaletteId.pink => const BubblePalette(
      background: Color(0xFF08030A),
      digit1: Color(0xFFFF83C5),
      digit2: Color(0xFFD957B0),
      digit3: Color(0xFFFFA0DD),
      digit4: Color(0xFFB94FE0),
      colonTop: Color(0xFFFFDDF3),
      colonBottom: Color(0xFFFFDDF3),
    ),
    BubblePaletteId.amber => const BubblePalette(
      background: Color(0xFF090700),
      digit1: Color(0xFFFFD45E),
      digit2: Color(0xFFFFA936),
      digit3: Color(0xFFFFE48A),
      digit4: Color(0xFFE9952F),
      colonTop: Color(0xFFFFE8BE),
      colonBottom: Color(0xFFFFE8BE),
    ),
    BubblePaletteId.red => const BubblePalette(
      background: Color(0xFF090202),
      digit1: Color(0xFFFF6767),
      digit2: Color(0xFFE43C4B),
      digit3: Color(0xFFFF8B6B),
      digit4: Color(0xFFD6293A),
      colonTop: Color(0xFFFFD1D1),
      colonBottom: Color(0xFFFFD1D1),
    ),
    BubblePaletteId.green => const BubblePalette(
      background: Color(0xFF030706),
      digit1: Color(0xFF68BF55),
      digit2: Color(0xFF68BF55),
      digit3: Color(0xFF238D61),
      digit4: Color(0xFF68BF55),
      colonTop: Color(0xFFDAB5C3),
      colonBottom: Color(0xFFDAB5C3),
    ),
    BubblePaletteId.cyan => const BubblePalette(
      background: Color(0xFF02080A),
      digit1: Color(0xFF73E3E8),
      digit2: Color(0xFF32BFD7),
      digit3: Color(0xFF9AF0D2),
      digit4: Color(0xFF43AFCB),
      colonTop: Color(0xFFD8FFFF),
      colonBottom: Color(0xFFD8FFFF),
    ),
    BubblePaletteId.greenMix => const BubblePalette(
      background: Color(0xFF030706),
      digit1: Color(0xFF79D052),
      digit2: Color(0xFF32AD6D),
      digit3: Color(0xFF168F70),
      digit4: Color(0xFF91D95A),
      colonTop: Color(0xFFE8BFE0),
      colonBottom: Color(0xFFE8BFE0),
    ),
    BubblePaletteId.blueOrange => const BubblePalette(
      background: Color(0xFF060607),
      digit1: Color(0xFF477DFF),
      digit2: Color(0xFF7C9DFF),
      digit3: Color(0xFFFF9642),
      digit4: Color(0xFFFFBF57),
      colonTop: Color(0xFFDCD6FF),
      colonBottom: Color(0xFFFFD7B0),
    ),
  };
}
