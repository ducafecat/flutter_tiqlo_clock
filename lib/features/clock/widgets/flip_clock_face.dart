import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/flip_palette.dart';
import '../../../core/ui/pixel/pixel_tokens.dart';

// Jersey 25 provides the tall, fine-stepped pixel glyphs used by the flip
// reference; Tiny5 remains reserved for the compact AM/PM HUD.
const _flipFont = 'Jersey25';

/// Reference dimensions extracted from the approved 768 x 1522 portrait art.
/// Keeping this coordinate space makes the reference viewport a 1:1 render.
class _FlipReference {
  static const canvas = Size(768, 1522);
  static const horizontalInset = 20.0;
  static const cardWidth = 704.0;
  static const hourTop = 15.0;
  static const hourHeight = 774.0;
  static const cardGap = 32.0;
  // Keep the inner height even so the hinge and rotateX origin land on whole
  // physical pixels at the reference DPR.
  static const compactHeight = 664.0;
  static const minuteTop = hourTop + hourHeight + cardGap;
  static const cardCut = 40.0;
  static const frameInset = 10.0;
  static const axleWidth = 40.0;
  static const axleHeight = 96.0;
  static const dividerHeight = 10.0;
}

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
    final cards = <_FlipCardData>[
      _FlipCardData(snapshot.displayHour, badge: snapshot.period),
      _FlipCardData(snapshot.displayMinute),
      if (snapshot.showSeconds) _FlipCardData(snapshot.displaySecond),
    ];
    final clock = landscape ? _landscapeClock(cards) : _portraitClock(cards);
    final child = snapshot.showDate
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              clock,
              const SizedBox(height: 20),
              Text(
                snapshot.dateLabel,
                style: TextStyle(
                  color: palette.digit.withValues(alpha: 0.55),
                  fontFamily: 'PixelifySans',
                  fontSize: landscape ? 22 : 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          )
        : clock;

    return Semantics(
      container: true,
      label: snapshot.timeLabel,
      child: ExcludeSemantics(
        child: SizedBox.expand(
          child: Center(
            child: FittedBox(fit: BoxFit.contain, child: child),
          ),
        ),
      ),
    );
  }

  Widget _portraitClock(List<_FlipCardData> cards) {
    // The default two-card state fills the reference canvas exactly. Extra
    // cards retain the minute card's compact geometry and scale as one unit.
    if (cards.length == 2) {
      return SizedBox(
        width: _FlipReference.canvas.width,
        height: _FlipReference.canvas.height,
        child: Stack(
          children: [
            Positioned(
              left: _FlipReference.horizontalInset,
              top: _FlipReference.hourTop,
              child: _FlipCard(
                value: cards[0].value,
                width: _FlipReference.cardWidth,
                height: _FlipReference.hourHeight,
                palette: palette,
                badge: cards[0].badge,
              ),
            ),
            Positioned(
              left: _FlipReference.horizontalInset,
              top: _FlipReference.minuteTop,
              child: _FlipCard(
                value: cards[1].value,
                width: _FlipReference.cardWidth,
                height: _FlipReference.compactHeight,
                palette: palette,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FlipCard(
          value: cards.first.value,
          width: _FlipReference.cardWidth,
          height: _FlipReference.hourHeight,
          palette: palette,
          badge: cards.first.badge,
        ),
        for (final card in cards.skip(1)) ...[
          const SizedBox(height: _FlipReference.cardGap),
          _FlipCard(
            value: card.value,
            width: _FlipReference.cardWidth,
            height: _FlipReference.compactHeight,
            palette: palette,
          ),
        ],
      ],
    );
  }

  Widget _landscapeClock(List<_FlipCardData> cards) {
    const hourHeight = 260.0;
    const compactHeight = 222.0;
    const hourWidth = 281.0;
    const compactWidth = 240.0;
    const gap = 24.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _FlipCard(
          value: cards.first.value,
          width: hourWidth,
          height: hourHeight,
          palette: palette,
          badge: cards.first.badge,
        ),
        for (final card in cards.skip(1)) ...[
          const SizedBox(width: gap),
          _FlipCard(
            value: card.value,
            width: compactWidth,
            height: compactHeight,
            palette: palette,
          ),
        ],
      ],
    );
  }
}

class _FlipCardData {
  const _FlipCardData(this.value, {this.badge});

  final String value;
  final String? badge;
}

class _FlipCard extends StatefulWidget {
  const _FlipCard({
    required this.value,
    required this.width,
    required this.height,
    required this.palette,
    this.badge,
  });

  final String value;
  final double width;
  final double height;
  final FlipPalette palette;
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
          duration: const PixelTokens.dark().flipDuration,
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
      if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
        _controller.stop();
        _controller.value = 1;
        _previous = _current;
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flipping = _controller.isAnimating;
    final inset = math.min(_FlipReference.frameInset, widget.width / 12);
    final innerWidth = widget.width - inset * 2;
    final innerHeight = widget.height - inset * 2;
    final cut = math.min(_FlipReference.cardCut, widget.width / 5);

    return RepaintBoundary(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _FlipFramePainter(
                  palette: widget.palette,
                  cut: cut,
                  devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
                ),
              ),
            ),
            Positioned(
              left: inset,
              top: inset,
              width: innerWidth,
              height: innerHeight,
              child: ClipPath(
                clipper: _StepClipper(cut - inset),
                child: Stack(
                  key: const ValueKey('flip-card-stack'),
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Column(
                      children: [
                        _cachedHalf(
                          _current,
                          top: true,
                          width: innerWidth,
                          height: innerHeight,
                        ),
                        _cachedHalf(
                          flipping ? _previous : _current,
                          top: false,
                          width: innerWidth,
                          height: innerHeight,
                        ),
                      ],
                    ),
                    if (flipping)
                      Positioned.fill(
                        key: const ValueKey('flip-flap'),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: _animatedFlap(
                                value: _previous,
                                top: true,
                                width: innerWidth,
                                height: innerHeight,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: _animatedFlap(
                                value: _current,
                                top: false,
                                width: innerWidth,
                                height: innerHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.badge != null)
                      Positioned(
                        left: innerWidth * .056,
                        top: innerHeight * .056,
                        child: Text(
                          widget.badge!,
                          key: const ValueKey('flip-period'),
                          style: TextStyle(
                            color: widget.palette.digit,
                            fontFamily: 'Tiny5',
                            fontSize: math.max(14, widget.height * .083),
                            fontWeight: FontWeight.w400,
                            height: 1,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    Center(child: _divider()),
                  ],
                ),
              ),
            ),
            _axle(left: true),
            _axle(left: false),
          ],
        ),
      ),
    );
  }

  Widget _axle({required bool left}) {
    final scale = math.min(widget.width / _FlipReference.cardWidth, 1.0);
    final width = math.max(16, _FlipReference.axleWidth * scale).toDouble();
    final height = math.max(44, _FlipReference.axleHeight * scale).toDouble();
    return Positioned(
      left: left ? -width * .25 : null,
      right: left ? null : -width * .25,
      top: (widget.height - height) / 2,
      child: ExcludeSemantics(
        child: CustomPaint(
          key: const ValueKey('flip-axle'),
          size: Size(width, height),
          painter: _AxlePainter(palette: widget.palette),
        ),
      ),
    );
  }

  Widget _divider() => Container(
    key: const ValueKey('flip-divider'),
    width: math.max(2, widget.width - 52),
    height: math.max(
      2,
      math.min(_FlipReference.dividerHeight, widget.height * .016),
    ),
    color: widget.palette.divider,
  );

  Widget _cachedHalf(
    String value, {
    required bool top,
    required double width,
    required double height,
    Key? cacheKey,
  }) => RepaintBoundary(
    key: cacheKey,
    child: _half(value, top: top, width: width, height: height),
  );

  Widget _animatedFlap({
    required String value,
    required bool top,
    required double width,
    required double height,
  }) => AnimatedBuilder(
    animation: _controller,
    child: _cachedHalf(
      value,
      top: top,
      width: width,
      height: height,
      cacheKey: ValueKey(top ? 'flip-top-cache' : 'flip-bottom-cache'),
    ),
    builder: (context, child) {
      final progress = _controller.value;
      final eased = (1 - math.cos(math.pi * progress)) / 2;
      final angle = top
          ? math.min(eased * math.pi, math.pi / 2)
          : math.max(eased * math.pi - math.pi, -math.pi / 2);
      return Transform(
        key: ValueKey(top ? 'flip-top-transform' : 'flip-bottom-transform'),
        alignment: top ? Alignment.bottomCenter : Alignment.topCenter,
        filterQuality: FilterQuality.none,
        transform: Matrix4.identity()
          ..setEntry(3, 2, .001)
          ..rotateX(angle),
        child: child,
      );
    },
  );

  Widget _half(
    String value, {
    required bool top,
    required double width,
    required double height,
  }) => Container(
    key: ValueKey(top ? 'flip-card-top' : 'flip-card-bottom'),
    width: width,
    height: height / 2,
    color: top ? widget.palette.cardTop : widget.palette.cardBottom,
    child: Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(painter: _SurfaceTexturePainter(top: top)),
        OverflowBox(
          maxHeight: height,
          alignment: top ? Alignment.topCenter : Alignment.bottomCenter,
          child: SizedBox(
            width: width,
            height: height,
            child: Center(
              child: Transform.translate(
                offset: Offset(height * .012, -height * .025),
                child: Transform.scale(
                  scaleX: .76,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: widget.palette.digit,
                      fontFamily: _flipFont,
                      fontSize: height * 1.047,
                      fontWeight: FontWeight.w400,
                      height: .94,
                      letterSpacing: -height * .012,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SurfaceTexturePainter extends CustomPainter {
  const _SurfaceTexturePainter({required this.top});

  final bool top;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: top ? Alignment.topLeft : Alignment.bottomRight,
      end: top ? Alignment.bottomRight : Alignment.topLeft,
      colors: const [Color(0x08FFFFFF), Color(0x00000000), Color(0x0A000000)],
      stops: const [0, .52, 1],
    );
    canvas.drawRect(
      rect,
      Paint()
        ..isAntiAlias = false
        ..shader = gradient.createShader(rect),
    );

    final grain = Paint()
      ..isAntiAlias = false
      ..strokeWidth = 1
      ..color = const Color(0x03000000);
    for (var offset = -size.height; offset < size.width; offset += 8) {
      canvas.drawLine(
        Offset(offset, size.height),
        Offset(offset + size.height, 0),
        grain,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SurfaceTexturePainter oldDelegate) =>
      top != oldDelegate.top;
}

class _FlipFramePainter extends CustomPainter {
  const _FlipFramePainter({
    required this.palette,
    required this.cut,
    required this.devicePixelRatio,
  });

  final FlipPalette palette;
  final double cut;
  final double devicePixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final outer = _stepPath(rect, cut);
    final middle = _stepPath(_inset(rect, 2), math.max(4, cut - 2));
    final inner = _stepPath(_inset(rect, 4), math.max(4, cut - 4));
    final paint = Paint()..isAntiAlias = false;
    canvas.drawPath(
      outer.shift(const Offset(0, 5)),
      paint..color = const Color(0xFF000000),
    );
    canvas.drawPath(outer, paint..color = const Color(0xFF3A3A3A));
    canvas.drawPath(
      Path.combine(PathOperation.difference, outer, middle),
      paint..color = const Color(0xFF252525),
    );
    canvas.drawPath(
      Path.combine(PathOperation.difference, middle, inner),
      paint..color = const Color(0xFF111111),
    );
  }

  Rect _inset(Rect rect, double value) {
    double aligned(double input) =>
        (input * devicePixelRatio).roundToDouble() / devicePixelRatio;
    return Rect.fromLTRB(
      aligned(rect.left + value),
      aligned(rect.top + value),
      aligned(rect.right - value),
      aligned(rect.bottom - value),
    );
  }

  @override
  bool shouldRepaint(covariant _FlipFramePainter oldDelegate) =>
      palette != oldDelegate.palette ||
      cut != oldDelegate.cut ||
      devicePixelRatio != oldDelegate.devicePixelRatio;
}

class _AxlePainter extends CustomPainter {
  const _AxlePainter({required this.palette});

  final FlipPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    canvas.drawRect(Offset.zero & size, paint..color = const Color(0xFF080808));
    canvas.drawRect(
      Rect.fromLTWH(3, 4, size.width - 6, size.height - 8),
      paint..color = const Color(0xFF353535),
    );
    canvas.drawRect(
      Rect.fromLTWH(6, size.height * .12, size.width - 12, size.height * .42),
      paint..color = const Color(0xFF444444),
    );
    canvas.drawRect(
      Rect.fromLTWH(6, size.height * .62, size.width - 12, size.height * .2),
      paint..color = const Color(0xFF242424),
    );
  }

  @override
  bool shouldRepaint(covariant _AxlePainter oldDelegate) =>
      palette != oldDelegate.palette;
}

class _StepClipper extends CustomClipper<Path> {
  const _StepClipper(this.cut);

  final double cut;

  @override
  Path getClip(Size size) => _stepPath(Offset.zero & size, cut);

  @override
  bool shouldReclip(covariant _StepClipper oldClipper) => cut != oldClipper.cut;
}

Path _stepPath(Rect rect, double cut) {
  final step = math.max(2, cut / 4);
  final path = Path()..moveTo(rect.left + cut, rect.top);
  path
    ..lineTo(rect.right - cut, rect.top)
    ..lineTo(rect.right - cut, rect.top + step)
    ..lineTo(rect.right - step * 2, rect.top + step)
    ..lineTo(rect.right - step * 2, rect.top + step * 2)
    ..lineTo(rect.right - step, rect.top + step * 2)
    ..lineTo(rect.right - step, rect.top + cut)
    ..lineTo(rect.right, rect.top + cut)
    ..lineTo(rect.right, rect.bottom - cut)
    ..lineTo(rect.right - step, rect.bottom - cut)
    ..lineTo(rect.right - step, rect.bottom - step * 2)
    ..lineTo(rect.right - step * 2, rect.bottom - step * 2)
    ..lineTo(rect.right - step * 2, rect.bottom - step)
    ..lineTo(rect.right - cut, rect.bottom - step)
    ..lineTo(rect.right - cut, rect.bottom)
    ..lineTo(rect.left + cut, rect.bottom)
    ..lineTo(rect.left + cut, rect.bottom - step)
    ..lineTo(rect.left + step * 2, rect.bottom - step)
    ..lineTo(rect.left + step * 2, rect.bottom - step * 2)
    ..lineTo(rect.left + step, rect.bottom - step * 2)
    ..lineTo(rect.left + step, rect.bottom - cut)
    ..lineTo(rect.left, rect.bottom - cut)
    ..lineTo(rect.left, rect.top + cut)
    ..lineTo(rect.left + step, rect.top + cut)
    ..lineTo(rect.left + step, rect.top + step * 2)
    ..lineTo(rect.left + step * 2, rect.top + step * 2)
    ..lineTo(rect.left + step * 2, rect.top + step)
    ..lineTo(rect.left + cut, rect.top + step)
    ..close();
  return path;
}
