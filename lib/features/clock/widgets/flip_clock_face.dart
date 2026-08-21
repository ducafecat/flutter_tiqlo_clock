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

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
      duration: const Duration(milliseconds: 600),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _previous = _current);
        _controller.reset();
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
        final t = _controller.value;
        final flipping = t > 0 && t < 1;
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
                  const SizedBox(height: 2),
                  _half(flipping ? _previous : _current, top: false),
                ],
              ),
              if (flipping && t < 0.5)
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.006)
                      ..rotateX(t * math.pi),
                    child: _half(_previous, top: true),
                  ),
                ),
              if (flipping && t >= 0.5)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.006)
                      ..rotateX((t - 1) * math.pi),
                    child: _half(_current, top: false),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _half(String digit, {required bool top}) {
    final radius = Radius.circular(widget.width * 0.12);
    return Container(
      width: widget.width,
      height: widget.height / 2 - 1,
      decoration: BoxDecoration(
        color: top ? const Color(0xFF2A2A2A) : const Color(0xFF1A1A1A),
        borderRadius: top
            ? BorderRadius.vertical(top: radius)
            : BorderRadius.vertical(bottom: radius),
      ),
      child: ClipRRect(
        borderRadius: top
            ? BorderRadius.vertical(top: radius)
            : BorderRadius.vertical(bottom: radius),
        child: OverflowBox(
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
      ),
    );
  }
}
