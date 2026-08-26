import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Pixel UI 的固定语义 token。
class PixelTokens extends ThemeExtension<PixelTokens> {
  const PixelTokens({
    required this.background,
    required this.chrome,
    required this.surface,
    required this.surfaceHigh,
    required this.textPrimary,
    required this.textSecondary,
    required this.outline,
    required this.accent,
    required this.section,
    required this.shadow,
    required this.focus,
    required this.danger,
    required this.disabledSurface,
    required this.disabledText,
    required this.barrier,
    required this.hoverOverlay,
    required this.pressedOverlay,
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMd,
    required this.spacingLg,
    required this.outlineWidth,
    required this.hardShadowOffset,
    required this.pressedOffset,
    required this.pressDuration,
    required this.switchDuration,
    required this.flipDuration,
    required this.splashDuration,
    required this.welcomePageDuration,
    required this.welcomeContentDuration,
  });

  const PixelTokens.dark()
    : background = const Color(0xFF000000),
      chrome = const Color(0xFF171612),
      surface = const Color(0xFF25221E),
      surfaceHigh = const Color(0xFF302C27),
      textPrimary = const Color(0xFFF4F0E6),
      textSecondary = const Color(0xFFAAA59B),
      outline = const Color(0xFF756B5A),
      accent = const Color(0xFFED780C),
      section = const Color(0xFFB8A77C),
      shadow = const Color(0xFF000000),
      focus = const Color(0xFF72B7FF),
      danger = const Color(0xFFD75A5A),
      disabledSurface = const Color(0xFF1E1C19),
      disabledText = const Color(0xFF777168),
      barrier = const Color(0xC2000000),
      hoverOverlay = const Color(0x14FFFFFF),
      pressedOverlay = const Color(0x24000000),
      spacingXs = 4,
      spacingSm = 8,
      spacingMd = 16,
      spacingLg = 24,
      outlineWidth = 2,
      hardShadowOffset = 2,
      pressedOffset = 2,
      pressDuration = const Duration(milliseconds: 100),
      switchDuration = const Duration(milliseconds: 150),
      flipDuration = const Duration(milliseconds: 600),
      splashDuration = const Duration(milliseconds: 300),
      welcomePageDuration = const Duration(milliseconds: 300),
      welcomeContentDuration = const Duration(milliseconds: 150);

  final Color background;
  final Color chrome;
  final Color surface;
  final Color surfaceHigh;
  final Color textPrimary;
  final Color textSecondary;
  final Color outline;
  final Color accent;
  final Color section;
  final Color shadow;
  final Color focus;
  final Color danger;
  final Color disabledSurface;
  final Color disabledText;
  final Color barrier;
  final Color hoverOverlay;
  final Color pressedOverlay;
  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final double outlineWidth;
  final double hardShadowOffset;
  final double pressedOffset;
  final Duration pressDuration;
  final Duration switchDuration;
  final Duration flipDuration;
  final Duration splashDuration;
  final Duration welcomePageDuration;
  final Duration welcomeContentDuration;

  static PixelTokens of(BuildContext context) {
    return Theme.of(context).extension<PixelTokens>() ??
        const PixelTokens.dark();
  }

  static const _systemFallback = [
    'PingFang SC',
    'Microsoft YaHei',
    'Noto Sans CJK SC',
    'sans-serif',
  ];

  Duration motionDuration(BuildContext context, Duration duration) {
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false
        ? Duration.zero
        : duration;
  }

  TextStyle heading({double fontSize = 20}) => TextStyle(
    fontFamily: 'PixelifySans',
    fontFamilyFallback: _systemFallback,
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );

  TextStyle body({double fontSize = 16, Color? color}) => TextStyle(
    fontFamily: 'PixelifySans',
    fontFamilyFallback: _systemFallback,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    color: color ?? textPrimary,
    height: 1.35,
  );

  TextStyle hud({double fontSize = 14}) => TextStyle(
    fontFamily: 'Tiny5',
    fontFamilyFallback: _systemFallback,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1,
  );

  TextStyle flipDisplay({double fontSize = 64, Color? color}) => TextStyle(
    fontFamily: 'Silkscreen',
    fontFamilyFallback: _systemFallback,
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    color: color ?? textPrimary,
  );

  TextStyle digitalDisplay({double fontSize = 64, Color? color}) => TextStyle(
    fontFamily: 'DSEG7Classic',
    fontFamilyFallback: _systemFallback,
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    color: color ?? textPrimary,
  );

  @override
  PixelTokens copyWith({
    Color? background,
    Color? chrome,
    Color? surface,
    Color? surfaceHigh,
    Color? textPrimary,
    Color? textSecondary,
    Color? outline,
    Color? accent,
    Color? section,
    Color? shadow,
    Color? focus,
    Color? danger,
    Color? disabledSurface,
    Color? disabledText,
    Color? barrier,
    Color? hoverOverlay,
    Color? pressedOverlay,
    double? spacingXs,
    double? spacingSm,
    double? spacingMd,
    double? spacingLg,
    double? outlineWidth,
    double? hardShadowOffset,
    double? pressedOffset,
    Duration? pressDuration,
    Duration? switchDuration,
    Duration? flipDuration,
    Duration? splashDuration,
    Duration? welcomePageDuration,
    Duration? welcomeContentDuration,
  }) {
    return PixelTokens(
      background: background ?? this.background,
      chrome: chrome ?? this.chrome,
      surface: surface ?? this.surface,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      outline: outline ?? this.outline,
      accent: accent ?? this.accent,
      section: section ?? this.section,
      shadow: shadow ?? this.shadow,
      focus: focus ?? this.focus,
      danger: danger ?? this.danger,
      disabledSurface: disabledSurface ?? this.disabledSurface,
      disabledText: disabledText ?? this.disabledText,
      barrier: barrier ?? this.barrier,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
      spacingXs: spacingXs ?? this.spacingXs,
      spacingSm: spacingSm ?? this.spacingSm,
      spacingMd: spacingMd ?? this.spacingMd,
      spacingLg: spacingLg ?? this.spacingLg,
      outlineWidth: outlineWidth ?? this.outlineWidth,
      hardShadowOffset: hardShadowOffset ?? this.hardShadowOffset,
      pressedOffset: pressedOffset ?? this.pressedOffset,
      pressDuration: pressDuration ?? this.pressDuration,
      switchDuration: switchDuration ?? this.switchDuration,
      flipDuration: flipDuration ?? this.flipDuration,
      splashDuration: splashDuration ?? this.splashDuration,
      welcomePageDuration: welcomePageDuration ?? this.welcomePageDuration,
      welcomeContentDuration:
          welcomeContentDuration ?? this.welcomeContentDuration,
    );
  }

  @override
  PixelTokens lerp(covariant PixelTokens? other, double t) {
    if (other == null) return this;
    return PixelTokens(
      background: Color.lerp(background, other.background, t)!,
      chrome: Color.lerp(chrome, other.chrome, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      section: Color.lerp(section, other.section, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      disabledSurface: Color.lerp(disabledSurface, other.disabledSurface, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      barrier: Color.lerp(barrier, other.barrier, t)!,
      hoverOverlay: Color.lerp(hoverOverlay, other.hoverOverlay, t)!,
      pressedOverlay: Color.lerp(pressedOverlay, other.pressedOverlay, t)!,
      spacingXs: lerpDouble(spacingXs, other.spacingXs, t)!,
      spacingSm: lerpDouble(spacingSm, other.spacingSm, t)!,
      spacingMd: lerpDouble(spacingMd, other.spacingMd, t)!,
      spacingLg: lerpDouble(spacingLg, other.spacingLg, t)!,
      outlineWidth: lerpDouble(outlineWidth, other.outlineWidth, t)!,
      hardShadowOffset: lerpDouble(
        hardShadowOffset,
        other.hardShadowOffset,
        t,
      )!,
      pressedOffset: lerpDouble(pressedOffset, other.pressedOffset, t)!,
      pressDuration: t < 0.5 ? pressDuration : other.pressDuration,
      switchDuration: t < 0.5 ? switchDuration : other.switchDuration,
      flipDuration: t < 0.5 ? flipDuration : other.flipDuration,
      splashDuration: t < 0.5 ? splashDuration : other.splashDuration,
      welcomePageDuration: t < 0.5
          ? welcomePageDuration
          : other.welcomePageDuration,
      welcomeContentDuration: t < 0.5
          ? welcomeContentDuration
          : other.welcomeContentDuration,
    );
  }
}
