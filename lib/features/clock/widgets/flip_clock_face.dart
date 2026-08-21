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
    final cardWidth = landscape ? 120.0 : 76.0;
    final cardHeight = landscape ? 140.0 : 88.0;
    final dateSize = landscape ? 24.0 : 18.0;

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
                  _FlipCard(
                    value: snapshot.displayHour,
                    width: cardWidth,
                    height: cardHeight,
                  ),
                  const SizedBox(width: 12),
                  _FlipCard(
                    value: snapshot.displayMinute,
                    width: cardWidth,
                    height: cardHeight,
                  ),
                ],
              ),
              if (snapshot.period != null || snapshot.displaySecond != null) ...[
                const SizedBox(height: 8),
                Text(
                  [
                    if (snapshot.period != null) snapshot.period!,
                    if (snapshot.displaySecond != null) snapshot.displaySecond!,
                  ].join('  '),
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

class _FlipCard extends StatelessWidget {
  const _FlipCard({
    required this.value,
    required this.width,
    required this.height,
  });

  final String value;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        transitionBuilder: (child, animation) {
          return AnimatedBuilder(
            animation: animation,
            child: child,
            builder: (context, child) {
              final angle = (1 - animation.value) * math.pi / 2;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(angle),
                child: child,
              );
            },
          );
        },
        child: _FlipCardFace(
          key: ValueKey(value),
          value: value,
          width: width,
          height: height,
        ),
      ),
    );
  }
}

class _FlipCardFace extends StatelessWidget {
  const _FlipCardFace({
    super.key,
    required this.value,
    required this.width,
    required this.height,
  });

  final String value;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: Colors.white,
          fontSize: height * 0.55,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
