enum ClockThemeId { flip, digital }

extension ClockThemeIdX on ClockThemeId {
  String get label => switch (this) {
    ClockThemeId.flip => 'Flip',
    ClockThemeId.digital => 'Digital',
  };
}
