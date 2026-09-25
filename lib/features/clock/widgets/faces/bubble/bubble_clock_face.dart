import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

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

    return ColoredBox(
      color: widget.palette.background,
      child: Semantics(
        container: true,
        label: semanticTime,
        child: ExcludeSemantics(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final landscape = constraints.maxWidth > constraints.maxHeight;
              final fontSize = landscape
                  ? constraints.maxHeight * 0.92
                  : constraints.maxWidth * 0.32;
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: FittedBox(
                        key: const ValueKey('bubble-content-viewport'),
                        fit: BoxFit.scaleDown,
                        child: _BubbleTimeDisplay(
                          hour: hour,
                          minute: minute,
                          palette: widget.palette,
                          fontSize: fontSize,
                          digitDuration: digitDuration,
                          colorDuration: colorDuration,
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
}

class _BubbleTimeDisplay extends StatelessWidget {
  const _BubbleTimeDisplay({
    required this.hour,
    required this.minute,
    required this.palette,
    required this.fontSize,
    required this.digitDuration,
    required this.colorDuration,
  });

  final String hour;
  final String minute;
  final BubblePalette palette;
  final double fontSize;
  final Duration digitDuration;
  final Duration colorDuration;

  static const _slotTiltDegrees = <double>[-4, 3.5, -3.5, 4];

  static double _pairKerning(String left, String right) =>
      switch ('$left$right') {
        '11' => -0.050,
        '12' => -0.090,
        '20' => -0.140,
        '21' => -0.080,
        '22' => -0.140,
        '23' => -0.130,
        '49' => -0.090,
        '52' => -0.150,
        _ => -0.110,
      };

  static TextStyle _digitStyle(double fontSize, Color color) => TextStyle(
    fontFamily: 'BubbleClock',
    fontWeight: FontWeight.w500,
    fontSize: fontSize,
    height: 0.84,
    color: color,
  );

  Size _measureDigit(String value) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: _digitStyle(fontSize, Colors.white)),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
    )..layout();
    final size = painter.size;
    painter.dispose();
    return size;
  }

  @override
  Widget build(BuildContext context) {
    final hourDigits = hour.split('');
    final values = <({String value, Color color, int slot})>[
      if (hourDigits.length == 2)
        (value: hourDigits[0], color: palette.digit1, slot: 0),
      (value: hourDigits.last, color: palette.digit2, slot: 1),
      (value: minute[0], color: palette.digit3, slot: 2),
      (value: minute[1], color: palette.digit4, slot: 3),
    ];
    final sizes = [for (final digit in values) _measureDigit(digit.value)];
    final lineHeight = sizes.fold<double>(
      0,
      (height, size) => math.max(height, size.height),
    );
    final colonSize = fontSize * 0.16;
    final horizontalInset = fontSize * 0.06;
    final verticalInset = fontSize * 0.10;
    final positions = <double>[];
    var x = horizontalInset;
    var colonLeft = 0.0;
    for (var i = 0; i < values.length; i++) {
      if (i == hourDigits.length) {
        colonLeft = x - colonSize * 0.52;
        x = colonLeft + colonSize * 0.55;
      } else if (i > 0) {
        x += fontSize * _pairKerning(values[i - 1].value, values[i].value);
      }
      positions.add(x);
      x += sizes[i].width;
    }

    return SizedBox(
      width: x + horizontalInset,
      height: lineHeight + verticalInset * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < values.length; i++)
            Positioned(
              left: positions[i],
              top: verticalInset,
              width: sizes[i].width,
              height: lineHeight,
              child: _BubbleDigit(
                value: values[i].value,
                color: values[i].color,
                slot: values[i].slot,
                style: _digitStyle(fontSize, values[i].color),
                digitDuration: digitDuration,
                colorDuration: colorDuration,
                tiltDegrees: _slotTiltDegrees[values[i].slot],
              ),
            ),
          Positioned(
            left: colonLeft,
            top: verticalInset + (lineHeight - colonSize * 3) / 2,
            child: _BubbleColon(
              key: const ValueKey('bubble-colon'),
              topColor: palette.colonTop,
              bottomColor: palette.colonBottom,
              size: colonSize,
              colorDuration: colorDuration,
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleDigit extends StatelessWidget {
  const _BubbleDigit({
    required this.value,
    required this.color,
    required this.slot,
    required this.style,
    required this.digitDuration,
    required this.colorDuration,
    required this.tiltDegrees,
  });

  final String value;
  final Color color;
  final int slot;
  final TextStyle style;
  final Duration digitDuration;
  final Duration colorDuration;
  final double tiltDegrees;

  @override
  Widget build(BuildContext context) {
    final digit = int.parse(value);
    final tilt = (tiltDegrees + (digit % 3 - 1) * 0.5) * math.pi / 180;
    return AnimatedSwitcher(
      duration: digitDuration,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [...previousChildren, ?currentChild],
      ),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: TweenAnimationBuilder<Color?>(
        key: ValueKey(value),
        tween: ColorTween(end: color),
        duration: colorDuration,
        curve: Curves.easeOutCubic,
        builder: (context, animatedColor, _) => Transform.rotate(
          key: ValueKey('bubble-digit-tilt-$slot'),
          angle: tilt,
          child: Opacity(
            opacity: 0.86,
            child: Text(
              value,
              key: ValueKey('bubble-glyph-$value'),
              textScaler: TextScaler.noScaling,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: style.copyWith(color: animatedColor ?? color),
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
    required this.size,
    required this.colorDuration,
  });

  final Color topColor;
  final Color bottomColor;
  final double size;
  final Duration colorDuration;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size * 3,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _dot('bubble-colon-top', topColor),
        _dot('bubble-colon-bottom', bottomColor),
      ],
    ),
  );

  Widget _dot(String key, Color color) => TweenAnimationBuilder<Color?>(
    tween: ColorTween(end: color),
    duration: colorDuration,
    curve: Curves.easeOutCubic,
    builder: (context, animatedColor, _) => Opacity(
      key: ValueKey(key),
      opacity: 0.68,
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: animatedColor ?? color,
          ),
        ),
      ),
    ),
  );
}
