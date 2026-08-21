import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../clock/clock_engine.dart';

class FlipClockFace extends StatelessWidget {
  const FlipClockFace({
    super.key,
    required this.snapshot,
    required this.landscape,
  });

  final ClockSnapshot snapshot;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    final cardWidth = landscape ? 72.0 : 48.0;
    final cardHeight = landscape ? 112.0 : 76.0;
    final dateSize = landscape ? 24.0 : 18.0;
    final hour = snapshot.displayHour;
    final minute = snapshot.displayMinute;
    final second = snapshot.displaySecond;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FlipDigit(digit: hour[0], width: cardWidth, height: cardHeight),
                  const SizedBox(width: 6),
                  _FlipDigit(digit: hour[1], width: cardWidth, height: cardHeight),
                  _FlipColon(height: cardHeight),
                  _FlipDigit(
                    digit: minute[0],
                    width: cardWidth,
                    height: cardHeight,
                  ),
                  const SizedBox(width: 6),
                  _FlipDigit(
                    digit: minute[1],
                    width: cardWidth,
                    height: cardHeight,
                  ),
                  _FlipColon(height: cardHeight),
                  _FlipDigit(
                    digit: second[0],
                    width: cardWidth,
                    height: cardHeight,
                  ),
                  const SizedBox(width: 6),
                  _FlipDigit(
                    digit: second[1],
                    width: cardWidth,
                    height: cardHeight,
                  ),
                ],
              ),
              if (snapshot.period != null) ...[
                const SizedBox(height: 8),
                Text(
                  snapshot.period!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2,
                  ),
                ),
              ],
              if (snapshot.showDate) ...[
                const SizedBox(height: 16),
                Text(
                  snapshot.dateLabel,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: dateSize,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FlipColon extends StatelessWidget {
  const _FlipColon({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: height * 0.08,
      height: height * 0.08,
      decoration: const BoxDecoration(
        color: Color(0xFFD0D0D0),
        shape: BoxShape.circle,
      ),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: height * 0.12),
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dot,
            SizedBox(height: height * 0.18),
            dot,
          ],
        ),
      ),
    );
  }
}

class _FlipDigit extends StatefulWidget {
  const _FlipDigit({
    required this.digit,
    required this.width,
    required this.height,
  });

  final String digit;
  final double width;
  final double height;

  @override
  State<_FlipDigit> createState() => _FlipDigitState();
}

class _FlipDigitState extends State<_FlipDigit>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late String _current;
  late String _previous;

  @override
  void initState() {
    super.initState();
    _current = widget.digit;
    _previous = widget.digit;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _previous = _current);
      }
    });
  }

  @override
  void didUpdateWidget(_FlipDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.digit != oldWidget.digit) {
      _previous = oldWidget.digit;
      _current = widget.digit;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final raw = _controller.value;
        final flipping = _controller.isAnimating;
        final topPhase = raw < 0.5;
        final topAngle = Curves.easeInCubic.transform((raw * 2).clamp(0.0, 1.0)) *
            (math.pi / 2);
        final bottomAngle =
            (Curves.easeOutCubic.transform(((raw - 0.5) * 2).clamp(0.0, 1.0)) -
                1) *
            (math.pi / 2);
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  _half(_current, top: true),
                  _half(flipping ? _previous : _current, top: false),
                ],
              ),
              Center(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.22),
                  child: SizedBox(width: widget.width, height: 1),
                ),
              ),
              if (flipping && topPhase)
                Align(
                  alignment: Alignment.topCenter,
                  child: _flap(
                    digit: _previous,
                    top: true,
                    angle: topAngle,
                  ),
                ),
              if (flipping && !topPhase)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _flap(
                    digit: _current,
                    top: false,
                    angle: bottomAngle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _flap({
    required String digit,
    required bool top,
    required double angle,
  }) {
    final shade = math.sin(angle.abs()).clamp(0.0, 1.0) * 0.2;
    return Transform(
      alignment: top ? Alignment.bottomCenter : Alignment.topCenter,
      filterQuality: FilterQuality.medium,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0028)
        ..rotateX(angle),
      child: _half(digit, top: top, shade: shade),
    );
  }

  Widget _half(String digit, {required bool top, double shade = 0}) {
    final radius = Radius.circular(widget.width * 0.12);
    return Container(
      width: widget.width,
      height: widget.height / 2,
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: top
            ? BorderRadius.vertical(top: radius)
            : BorderRadius.vertical(bottom: radius),
      ),
      child: ClipRRect(
        borderRadius: top
            ? BorderRadius.vertical(top: radius)
            : BorderRadius.vertical(bottom: radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            OverflowBox(
              maxHeight: widget.height,
              alignment: top ? Alignment.topCenter : Alignment.bottomCenter,
              child: SizedBox(
                width: widget.width,
                height: widget.height,
                child: Center(
                  child: Text(
                    digit,
                    style: TextStyle(
                      color: const Color(0xFFF2F2F2),
                      fontSize: widget.height * 0.62,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
            if (shade > 0)
              ColoredBox(color: Colors.black.withValues(alpha: shade)),
          ],
        ),
      ),
    );
  }
}
