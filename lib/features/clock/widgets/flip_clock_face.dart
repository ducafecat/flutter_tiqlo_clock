import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/flip_palette.dart';

const _flipFont = 'FlipClock';

class FlipClockFace extends StatelessWidget {
  const FlipClockFace({
    super.key,
    required this.snapshot,
    required this.landscape,
    required this.palette,
  });

  final ClockSnapshot snapshot;
  final bool landscape;
  final FlipPalette palette;

  @override
  Widget build(BuildContext context) {
    final cardHeight = landscape ? 260.0 : 210.0;
    final cardWidth = cardHeight * 1.08;
    final gap = cardHeight * 0.09;
    final period = snapshot.period;
    final dateSize = landscape ? 22.0 : 16.0;
    final cards = [
      _FlipCard(
        value: snapshot.displayHour,
        width: cardWidth,
        height: cardHeight,
        palette: palette,
      ),
      _FlipCard(
        value: snapshot.displayMinute,
        width: cardWidth,
        height: cardHeight,
        palette: palette,
      ),
      if (snapshot.showSeconds)
        _FlipCard(
          value: snapshot.displaySecond,
          width: cardWidth,
          height: cardHeight,
          palette: palette,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = 0; index < cards.length; index++) ...[
                    if (index > 0)
                      SizedBox(
                        width: landscape ? gap : 0,
                        height: landscape ? 0 : gap,
                      ),
                    _FlipCardSlot(
                      card: cards[index],
                      badge: index == 0 ? period : null,
                      reserveBadgeSpace: landscape && period != null,
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                      palette: palette,
                    ),
                  ],
                ],
              ),
              if (snapshot.showDate) ...[
                const SizedBox(height: 20),
                Text(
                  snapshot.dateLabel,
                  style: TextStyle(
                    color: palette.digit.withValues(alpha: 0.55),
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

class _FlipCardSlot extends StatelessWidget {
  const _FlipCardSlot({
    required this.card,
    required this.cardWidth,
    required this.cardHeight,
    required this.palette,
    required this.reserveBadgeSpace,
    this.badge,
  });

  final Widget card;
  final double cardWidth;
  final double cardHeight;
  final FlipPalette palette;
  final bool reserveBadgeSpace;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final badgeHeight = cardHeight * 0.16;
    final showBadgeRow = badge != null || reserveBadgeSpace;
    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showBadgeRow)
            SizedBox(
              height: badgeHeight,
              child: badge == null
                  ? null
                  : Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        badge!,
                        key: const ValueKey('flip-period'),
                        style: TextStyle(
                          color: palette.digit,
                          fontFamily: _flipFont,
                          fontSize: cardHeight * 0.12,
                          fontWeight: FontWeight.w900,
                          height: 1,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
            ),
          card,
        ],
      ),
    );
  }
}

class _FlipCard extends StatefulWidget {
  const _FlipCard({
    required this.value,
    required this.width,
    required this.height,
    required this.palette,
  });

  final String value;
  final double width;
  final double height;
  final FlipPalette palette;

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
        final eased = (1 - math.cos(math.pi * raw)) / 2;
        final topPhase = eased < 0.5;
        final topAngle = math.min(eased * math.pi, math.pi / 2);
        final bottomAngle = math.max(eased * math.pi - math.pi, -math.pi / 2);
        final radius = BorderRadius.circular(widget.width * 0.085);
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.32),
                        blurRadius: widget.height * 0.07,
                        spreadRadius: -widget.height * 0.02,
                        offset: Offset(0, widget.height * 0.025),
                      ),
                    ],
                  ),
                  child: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.55),
                        width: 0.8,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: radius,
                      child: Stack(
                        key: const ValueKey('flip-card-stack'),
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Column(
                            children: [
                              _half(_current, top: true),
                              _half(
                                flipping ? _previous : _current,
                                top: false,
                              ),
                            ],
                          ),
                          if (flipping && topPhase)
                            Align(
                              key: const ValueKey('flip-flap'),
                              alignment: Alignment.topCenter,
                              child: _flap(
                                value: _previous,
                                top: true,
                                angle: topAngle,
                              ),
                            ),
                          if (flipping && !topPhase)
                            Align(
                              key: const ValueKey('flip-flap'),
                              alignment: Alignment.bottomCenter,
                              child: _flap(
                                value: _current,
                                top: false,
                                angle: bottomAngle,
                              ),
                            ),
                          Center(child: _divider()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _divider() {
    return Container(
      key: const ValueKey('flip-divider'),
      width: widget.width,
      height: math.max(1.5, widget.height * 0.008),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.palette.digit.withValues(alpha: 0.012),
            Color.lerp(Colors.transparent, widget.palette.divider, 0.72)!,
            Colors.black.withValues(alpha: 0.62),
          ],
          stops: const [0, 0.48, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: widget.height * 0.0015,
            offset: Offset(0, widget.height * 0.0005),
          ),
        ],
      ),
    );
  }

  Widget _flap({
    required String value,
    required bool top,
    required double angle,
  }) {
    final shade = math.sin(angle.abs()).clamp(0.0, 1.0) * 0.38;
    return Transform(
      alignment: top ? Alignment.bottomCenter : Alignment.topCenter,
      filterQuality: FilterQuality.medium,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0028)
        ..rotateX(angle),
      child: _half(value, top: top, shade: shade),
    );
  }

  Widget _half(String value, {required bool top, double shade = 0}) {
    final radius = Radius.circular(widget.width * 0.085);
    return Container(
      key: ValueKey(top ? 'flip-card-top' : 'flip-card-bottom'),
      width: widget.width,
      height: widget.height / 2,
      decoration: BoxDecoration(
        gradient: _panelGradient(top: top),
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
                      color: widget.palette.digit,
                      fontFamily: _flipFont,
                      fontSize: widget.height * 0.82,
                      fontWeight: FontWeight.w700,
                      height: 0.94,
                      letterSpacing: -widget.height * 0.012,
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

  LinearGradient _panelGradient({required bool top}) {
    final base = top ? widget.palette.cardTop : widget.palette.cardBottom;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: top
          ? [base, base, Color.lerp(base, Colors.black, 0.18)!]
          : [Color.lerp(base, Colors.black, 0.2)!, base, base],
      stops: const [0, 0.56, 1],
    );
  }
}
