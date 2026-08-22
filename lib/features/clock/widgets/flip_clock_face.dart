import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../clock/clock_engine.dart';

const _flipFont = 'FlipClock';
const _digitColor = Color(0xFFC8C8C8);
const _cardColor = Color(0xFF141414);

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
    final cardHeight = landscape ? 260.0 : 210.0;
    final cardWidth = cardHeight;
    final gap = cardWidth * 0.08;
    final dateSize = landscape ? 22.0 : 16.0;
    final cards = [
      _FlipCard(
        value: snapshot.displayHour,
        width: cardWidth,
        height: cardHeight,
        badge: snapshot.period,
      ),
      _FlipCard(
        value: snapshot.displayMinute,
        width: cardWidth,
        height: cardHeight,
      ),
      if (snapshot.showSeconds)
        _FlipCard(
          value: snapshot.displaySecond,
          width: cardWidth,
          height: cardHeight,
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flex(
                direction: landscape ? Axis.horizontal : Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var index = 0; index < cards.length; index++) ...[
                    if (index > 0)
                      SizedBox(
                        width: landscape ? gap : 0,
                        height: landscape ? 0 : gap,
                      ),
                    cards[index],
                  ],
                ],
              ),
              if (snapshot.showDate) ...[
                const SizedBox(height: 20),
                Text(
                  snapshot.dateLabel,
                  style: TextStyle(
                    color: const Color(0xFF8A8A8A),
                    fontSize: dateSize,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
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

class _FlipCard extends StatefulWidget {
  const _FlipCard({
    required this.value,
    required this.width,
    required this.height,
    this.badge,
  });

  final String value;
  final double width;
  final double height;
  final String? badge;

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late String _current;
  late String _previous;

  @override
  void initState() {
    super.initState();
    _current = widget.value;
    _previous = widget.value;
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 700),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            setState(() => _previous = _current);
          }
        });
  }

  @override
  void didUpdateWidget(_FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previous = oldWidget.value;
      _current = widget.value;
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
        final topAngle =
            Curves.easeInCubic.transform((raw * 2).clamp(0.0, 1.0)) *
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
            children: [
              Column(
                children: [
                  _half(_current, top: true),
                  _half(flipping ? _previous : _current, top: false),
                ],
              ),
              Center(child: _hinge()),
              if (flipping && topPhase)
                Align(
                  alignment: Alignment.topCenter,
                  child: _flap(value: _previous, top: true, angle: topAngle),
                ),
              if (flipping && !topPhase)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _flap(value: _current, top: false, angle: bottomAngle),
                ),
              if (widget.badge != null)
                Positioned(
                  left: widget.width * 0.07,
                  top: widget.height * 0.12,
                  child: Text(
                    widget.badge!,
                    style: TextStyle(
                      color: _digitColor,
                      fontFamily: _flipFont,
                      fontSize: widget.height * 0.085,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _hinge() {
    return ColoredBox(
      color: Colors.black,
      child: SizedBox(width: widget.width, height: widget.height * 0.008),
    );
  }

  Widget _flap({
    required String value,
    required bool top,
    required double angle,
  }) {
    final shade = math.sin(angle.abs()).clamp(0.0, 1.0) * 0.28;
    return Transform(
      alignment: top ? Alignment.bottomCenter : Alignment.topCenter,
      filterQuality: FilterQuality.medium,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0024)
        ..rotateX(angle),
      child: _half(value, top: top, shade: shade),
    );
  }

  Widget _half(String value, {required bool top, double shade = 0}) {
    final radius = Radius.circular(widget.width * 0.085);
    return Container(
      width: widget.width,
      height: widget.height / 2,
      decoration: BoxDecoration(
        color: _cardColor,
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
                    value,
                    style: TextStyle(
                      color: _digitColor,
                      fontFamily: _flipFont,
                      fontSize: widget.height * 0.84,
                      fontWeight: FontWeight.w700,
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
