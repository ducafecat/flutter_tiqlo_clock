enum ClockThemeId { minimal, flip, oled, retro }

extension ClockThemeIdX on ClockThemeId {
  String get label => switch (this) {
    ClockThemeId.minimal => 'Minimal',
    ClockThemeId.flip => 'Flip',
    ClockThemeId.oled => 'OLED',
    ClockThemeId.retro => 'Retro',
  };
}
