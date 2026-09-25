enum ClockThemeId { flip, digital, bubble }

extension ClockThemeIdX on ClockThemeId {
  String get label => switch (this) {
    ClockThemeId.flip => 'Flip',
    ClockThemeId.digital => 'Digital',
    ClockThemeId.bubble => 'Bubble',
  };
}
