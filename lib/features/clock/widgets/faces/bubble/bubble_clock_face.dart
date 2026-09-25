import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../clock/bubble_palette.dart';
import '../../../../../clock/clock_engine.dart';

class BubbleClockFace extends StatefulWidget {
  const BubbleClockFace({
    super.key,
    required this.snapshot,
    required this.palette,
  });

  final ClockSnapshot snapshot;
  final BubblePalette palette;

  @override
  State<BubbleClockFace> createState() => _BubbleClockFaceState();
}

class _BubbleClockFaceState extends State<BubbleClockFace> {
  static const _glyphScale = 0.82;

  // SVG viewBox widths, scaled from their shared 180-unit height to 160.
  static const _digitWidths = <double>[
    132.77 * 160 / 180,
    89.12 * 160 / 180,
    135.46 * 160 / 180,
    129.18 * 160 / 180,
    145.72 * 160 / 180,
    133.52 * 160 / 180,
    139.27 * 160 / 180,
    141.70 * 160 / 180,
    139.53 * 160 / 180,
    137.81 * 160 / 180,
  ];

  static const _burnInOffsets = <Offset>[
    Offset(0, 0),
    Offset(3, -1),
    Offset(1, 2),
    Offset(-3, 1),
    Offset(-1, -2),
  ];

  Timer? _burnInTimer;
  var _offsetIndex = 0;
  var _hasBurnInShifted = false;

  @override
  void initState() {
    super.initState();
    _burnInTimer = Timer.periodic(const Duration(minutes: 3), (_) {
      if (!mounted) return;
      setState(() {
        _offsetIndex = (_offsetIndex + 1) % _burnInOffsets.length;
        _hasBurnInShifted = true;
      });
    });
  }

  @override
  void dispose() {
    _burnInTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hour = widget.snapshot.displayHour;
    final minute = widget.snapshot.displayMinute;
    final semanticTime = widget.snapshot.is24Hour
        ? '$hour:$minute'
        : '$hour:$minute ${widget.snapshot.period ?? ''}'.trim();
    final hourDigits = hour.split('');
    final colors = widget.palette.digits;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final digitDuration = disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 280);
    final colorDuration = disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 260);
    final burnInDuration = disableAnimations
        ? Duration.zero
        : const Duration(seconds: 8);
    final burnInBeginIndex = _hasBurnInShifted
        ? (_offsetIndex - 1 + _burnInOffsets.length) % _burnInOffsets.length
        : _offsetIndex;
    final singleDigitHourOffset = hourDigits.length == 1 ? -34.0 : 0.0;

    return ColoredBox(
      color: widget.palette.background,
      child: Semantics(
        container: true,
        label: semanticTime,
        child: ExcludeSemantics(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: TweenAnimationBuilder<Offset>(
                  tween: Tween<Offset>(
                    begin: _burnInOffsets[burnInBeginIndex],
                    end: _burnInOffsets[_offsetIndex],
                  ),
                  duration: burnInDuration,
                  curve: Curves.easeInOut,
                  builder: (context, offset, child) => Transform.translate(
                    key: const ValueKey('bubble-burn-in-offset'),
                    offset: offset,
                    child: child,
                  ),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: FittedBox(
                      key: const ValueKey('bubble-content-viewport'),
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: 370,
                        height: 160,
                        child: Transform.translate(
                          offset: Offset(singleDigitHourOffset, 0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: _digitSlot(
                                  hourDigits.length == 2
                                      ? int.parse(hourDigits[0])
                                      : null,
                                  colors[0],
                                  0,
                                  digitDuration,
                                  colorDuration,
                                ),
                              ),
                              Positioned(
                                left: 53,
                                top: 0,
                                child: _digitSlot(
                                  int.parse(hourDigits.last),
                                  colors[1],
                                  1,
                                  digitDuration,
                                  colorDuration,
                                ),
                              ),
                              Positioned(
                                left: 166,
                                top: 0,
                                child: _digitSlot(
                                  int.parse(minute[0]),
                                  colors[2],
                                  2,
                                  digitDuration,
                                  colorDuration,
                                ),
                              ),
                              Positioned(
                                left: 236,
                                top: 0,
                                child: _digitSlot(
                                  int.parse(minute[1]),
                                  colors[3],
                                  3,
                                  digitDuration,
                                  colorDuration,
                                ),
                              ),
                              Positioned(
                                left: 125,
                                top: 0,
                                child: Transform.scale(
                                  scale: _glyphScale,
                                  child: _BubbleColon(
                                    key: const ValueKey('bubble-colon'),
                                    topColor: widget.palette.colonTop,
                                    bottomColor: widget.palette.colonBottom,
                                    colorDuration: colorDuration,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _digitSlot(
    int? digit,
    Color color,
    int slot,
    Duration digitDuration,
    Duration colorDuration,
  ) {
    if (digit == null) return const SizedBox(width: 130, height: 160);
    final offset = Offset(
      ((digit * 7 + slot * 11) % 9 - 4) * 0.65,
      ((digit * 11 + slot * 5) % 7 - 3) * 0.7,
    );
    return SizedBox(
      width: 130,
      height: 160,
      child: AnimatedSwitcher(
        duration: digitDuration,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
            child: child,
          ),
        ),
        child: TweenAnimationBuilder<Color?>(
          key: ValueKey(digit),
          tween: ColorTween(end: color),
          duration: colorDuration,
          curve: Curves.easeOutCubic,
          builder: (context, digitColor, _) => Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: _glyphScale,
              child: Center(
                child: Opacity(
                  key: ValueKey('bubble-glyph-$digit'),
                  opacity: 0.86,
                  child: SvgPicture.asset(
                    'assets/bubble/$digit.svg',
                    width: _digitWidths[digit],
                    height: 160,
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      digitColor ?? color,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BubbleColon extends StatelessWidget {
  const _BubbleColon({
    super.key,
    required this.topColor,
    required this.bottomColor,
    required this.colorDuration,
  });

  final Color topColor;
  final Color bottomColor;
  final Duration colorDuration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 160,
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: topColor),
        duration: colorDuration,
        curve: Curves.easeOutCubic,
        builder: (context, animatedTop, _) => TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: bottomColor),
          duration: colorDuration,
          curve: Curves.easeOutCubic,
          builder: (context, animatedBottom, _) => ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [animatedTop ?? topColor, animatedBottom ?? bottomColor],
              stops: const [0.5, 0.5],
            ).createShader(bounds),
            child: SvgPicture.asset(
              'assets/bubble/colon.svg',
              width: 64,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
