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
    final second = widget.snapshot.showSeconds
        ? widget.snapshot.displaySecond
        : null;
    final displayedTime = second == null
        ? '$hour:$minute'
        : '$hour:$minute:$second';
    final semanticTime = widget.snapshot.is24Hour
        ? displayedTime
        : '$displayedTime ${widget.snapshot.period ?? ''}'.trim();
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
                  : constraints.maxWidth * 0.70;
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
                          second: second,
                          landscape: landscape,
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
    required this.second,
    required this.landscape,
    required this.palette,
    required this.fontSize,
    required this.digitDuration,
    required this.colorDuration,
  });

  final String hour;
  final String minute;
  final String? second;
  final bool landscape;
  final BubblePalette palette;
  final double fontSize;
  final Duration digitDuration;
  final Duration colorDuration;

  static const _slotTiltDegrees = <double>[-4, 3.5, -3.5, 4, -4, 3.5];

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
      if (second != null) ...[
        (value: second![0], color: palette.digit1, slot: 4),
        (value: second![1], color: palette.digit2, slot: 5),
      ],
    ];
    final sizes = [for (final digit in values) _measureDigit(digit.value)];
    final lineHeight = sizes.fold<double>(
      0,
      (height, size) => math.max(height, size.height),
    );
    final colonSize = fontSize * 0.16;
    final horizontalInset = fontSize * 0.06;
    final verticalInset = fontSize * 0.10;

    Widget digitAt(int index, double left, double top) => Positioned(
      left: left,
      top: top,
      width: sizes[index].width,
      height: lineHeight,
      child: _BubbleDigit(
        value: values[index].value,
        color: values[index].color,
        slot: values[index].slot,
        style: _digitStyle(fontSize, values[index].color),
        digitDuration: digitDuration,
        colorDuration: colorDuration,
        tiltDegrees: _slotTiltDegrees[values[index].slot],
      ),
    );

    if (!landscape) {
      double rowWidth(int start, int end) {
        var width = sizes[start].width;
        for (var i = start + 1; i < end; i++) {
          width +=
              fontSize * _pairKerning(values[i - 1].value, values[i].value);
          width += sizes[i].width;
        }
        return width;
      }

      final rowEnds = <int>[
        hourDigits.length,
        hourDigits.length + 2,
        if (second != null) values.length,
      ];
      final rowWidths = <double>[
        rowWidth(0, rowEnds[0]),
        rowWidth(rowEnds[0], rowEnds[1]),
        if (second != null) rowWidth(rowEnds[1], rowEnds[2]),
      ];
      final width = rowWidths.reduce(math.max) + horizontalInset * 2;
      final positions = List<double>.filled(values.length, 0);
      final rowTops = List<double>.filled(values.length, 0);

      void placeRow(int start, int end, double rowWidth) {
        var x = (width - rowWidth) / 2;
        for (var i = start; i < end; i++) {
          if (i > start) {
            x += fontSize * _pairKerning(values[i - 1].value, values[i].value);
          }
          positions[i] = x;
          x += sizes[i].width;
        }
      }

      final rowGap = fontSize * 0.34;
      var rowStart = 0;
      for (var row = 0; row < rowEnds.length; row++) {
        final rowEnd = rowEnds[row];
        placeRow(rowStart, rowEnd, rowWidths[row]);
        for (var i = rowStart; i < rowEnd; i++) {
          rowTops[i] = verticalInset + row * (lineHeight + rowGap);
        }
        rowStart = rowEnd;
      }
      return SizedBox(
        key: const ValueKey('bubble-portrait-layout'),
        width: width,
        height: rowTops.last + lineHeight + verticalInset,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < values.length; i++)
              digitAt(i, positions[i], rowTops[i]),
          ],
        ),
      );
    }

    final positions = <double>[];
    final colonPositions = <double>[];
    var x = horizontalInset;
    for (var i = 0; i < values.length; i++) {
      if (i == hourDigits.length || i == hourDigits.length + 2) {
        colonPositions.add(x - colonSize * 0.52);
        x = colonPositions.last + colonSize * 0.55;
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
            digitAt(i, positions[i], verticalInset),
          for (var i = 0; i < colonPositions.length; i++)
            Positioned(
              left: colonPositions[i],
              top: verticalInset + (lineHeight - colonSize * 3) / 2,
              child: _BubbleColon(
                key: ValueKey(i == 0 ? 'bubble-colon' : 'bubble-seconds-colon'),
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
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.linear,
      transitionBuilder: (child, animation) => AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          final digitValue = (child!.key! as ValueKey<String>).value;
          final outgoing = animation.status == AnimationStatus.reverse;
          final progress = animation.value;
          final phase = outgoing ? (1 - progress) * 2 : (progress - 0.5) * 2;
          final eased = Curves.easeInOut.transform(phase.clamp(0.0, 1.0));
          final angle = outgoing
              ? eased * math.pi / 2
              : (eased - 1) * math.pi / 2;
          return Transform(
            key: ValueKey('bubble-digit-flip-$slot-$digitValue'),
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(angle),
            child: Opacity(opacity: progress >= 0.5 ? 1 : 0, child: child),
          );
        },
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
