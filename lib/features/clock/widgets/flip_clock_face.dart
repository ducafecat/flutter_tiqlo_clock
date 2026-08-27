import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/flip_palette.dart';
import '../../../core/ui/ui.dart';

// Jersey 25 provides the tall, fine-stepped pixel glyphs used by the flip
// reference; Tiny5 remains reserved for the compact AM/PM HUD.
const _flipFont = 'Jersey25';

/// Reference dimensions extracted from the approved 768 x 1522 portrait art.
/// Keeping this coordinate space makes the reference viewport a 1:1 render.
class _FlipReference {
  static const canvas = Size(768, 1522);
  static const cardWidth = 704.0;
  static const horizontalInset = 32.0;
  static const hourHeight = cardWidth;
  static const multiCardHeight = cardWidth;
  static const cardGap = 32.0;
  static const hourTop = 41.0;
  static const compactHeight = hourHeight;
  static const minuteTop = hourTop + hourHeight + cardGap;
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

    return Semantics(
      container: true,
      label: snapshot.timeLabel,
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final renderScale = _layoutScale(constraints, cards.length);
            final clock = landscape
                ? _landscapeClock(cards, renderScale)
                : _portraitClock(cards, renderScale);
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
            return SizedBox.expand(
              child: Center(
                child: FittedBox(fit: BoxFit.contain, child: child),
              ),
            );
          },
        ),
      ),
    );
  }

  double _layoutScale(BoxConstraints constraints, int cardCount) {
    final designSize = landscape
        ? Size(cardCount * 281 + (cardCount - 1) * 24, 281)
        : cardCount == 2
        ? _FlipReference.canvas
        : Size(
            _FlipReference.canvas.width,
            cardCount * _FlipReference.multiCardHeight +
                (cardCount - 1) * _FlipReference.cardGap,
          );
    final datedHeight =
        designSize.height +
        (snapshot.showDate ? 20 + (landscape ? 28 : 20) : 0);
    final widthScale = constraints.maxWidth / designSize.width;
    final heightScale = constraints.maxHeight / datedHeight;
    final scale = math.min(widthScale, heightScale);
    return scale.isFinite && scale > 0 ? scale : 1;
  }

  Widget _portraitClock(List<_FlipCardData> cards, double renderScale) {
    // The default two-card state centers two square cards in the reference
    // canvas. Every optional card keeps the same square geometry.
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
                renderScale: renderScale,
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
                renderScale: renderScale,
              ),
            ),
          ],
        ),
      );
    }

    // Three square cards are height-constrained on portrait phones. The whole
    // group scales uniformly, preserving 1:1 cards instead of stretching them
    // horizontally to consume otherwise unused width.
    return SizedBox(
      width: _FlipReference.canvas.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FlipCard(
            value: cards.first.value,
            width: _FlipReference.cardWidth,
            height: _FlipReference.multiCardHeight,
            palette: palette,
            badge: cards.first.badge,
            renderScale: renderScale,
          ),
          for (final card in cards.skip(1)) ...[
            const SizedBox(height: _FlipReference.cardGap),
            _FlipCard(
              value: card.value,
              width: _FlipReference.cardWidth,
              height: _FlipReference.multiCardHeight,
              palette: palette,
              renderScale: renderScale,
            ),
          ],
        ],
      ),
    );
  }

  Widget _landscapeClock(List<_FlipCardData> cards, double renderScale) {
    const cardWidth = 281.0;
    const cardHeight = cardWidth;
    const gap = 24.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _FlipCard(
          value: cards.first.value,
          width: cardWidth,
          height: cardHeight,
          palette: palette,
          badge: cards.first.badge,
          renderScale: renderScale,
        ),
        for (final card in cards.skip(1)) ...[
          const SizedBox(width: gap),
          _FlipCard(
            value: card.value,
            width: cardWidth,
            height: cardHeight,
            palette: palette,
            renderScale: renderScale,
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
    required this.renderScale,
    this.badge,
  });

  final String value;
  final double width;
  final double height;
  final FlipPalette palette;
  final double renderScale;
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
    final renderScale = math.max(.001, widget.renderScale);
    final visualCardMin = math.min(widget.width, widget.height) * renderScale;
    final visualCut = (visualCardMin * .055).clamp(12.0, 32.0);
    final cut = math.min(visualCut / renderScale, widget.width / 5);
    final visualInset = (visualCardMin * .014).clamp(4.0, 10.0);
    final inset = math.min(visualInset / renderScale, widget.width / 12);
    final innerWidth = widget.width - inset * 2;
    final innerHeight = widget.height - inset * 2;

    return RepaintBoundary(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(
                key: const ValueKey('flip-frame'),
                painter: _FlipFramePainter(
                  palette: widget.palette,
                  cut: cut,
                  renderScale: renderScale,
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
                            shadows: _badgeStroke(widget.height),
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

  List<Shadow> _badgeStroke(double height) {
    final stroke = math.max(1, height * .0026).toDouble();
    return [
      Shadow(color: widget.palette.digit, offset: Offset(stroke, 0)),
      Shadow(color: widget.palette.digit, offset: Offset(-stroke, 0)),
      Shadow(color: widget.palette.digit, offset: Offset(0, stroke)),
      Shadow(color: widget.palette.digit, offset: Offset(0, -stroke)),
    ];
  }

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
      final topTurn = (eased * 2).clamp(0.0, 1.0);
      final bottomTurn = _bottomReveal(progress);
      final turn = top ? topTurn : bottomTurn;
      final angle = top ? turn * math.pi / 2 : -(1 - turn) * math.pi / 2;
      final shadeOpacity = (top ? turn : 1 - turn) * .46;
      final edgeOpacity = math.sin(angle.abs()) * .72;
      final edgeHeight = 3 / math.max(.001, widget.renderScale);
      final flapSurface = Stack(
        fit: StackFit.passthrough,
        children: [
          child!,
          Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(
                key: ValueKey(top ? 'flip-top-shade' : 'flip-bottom-shade'),
                color: Colors.black.withValues(alpha: shadeOpacity),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: top ? null : 0,
            bottom: top ? 0 : null,
            height: edgeHeight,
            child: IgnorePointer(
              child: ColoredBox(
                key: ValueKey(top ? 'flip-top-edge' : 'flip-bottom-edge'),
                color: const Color(0xFF555555).withValues(alpha: edgeOpacity),
              ),
            ),
          ),
        ],
      );
      return Transform(
        key: ValueKey(top ? 'flip-top-transform' : 'flip-bottom-transform'),
        alignment: top ? Alignment.bottomCenter : Alignment.topCenter,
        filterQuality: angle.abs() < .0001
            ? FilterQuality.none
            : FilterQuality.low,
        transform: Matrix4.identity()
          ..setEntry(3, 2, .0007)
          ..rotateX(angle),
        child: flapSurface,
      );
    },
  );

  double _bottomReveal(double progress) {
    const start = .5;
    const settle = .95;
    if (progress <= start) return 0;
    if (progress >= settle) return 1;
    final t = (progress - start) / (settle - start);
    final t2 = t * t;
    final t3 = t2 * t;
    final smoothStep = -2 * t3 + 3 * t2;
    final initialSlope = math.pi * (settle - start);
    final startTangent = t3 - 2 * t2 + t;
    return (smoothStep + initialSlope * startTangent).clamp(0.0, 1.0);
  }

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
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
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
    required this.renderScale,
    required this.devicePixelRatio,
  });

  final FlipPalette palette;
  final double cut;
  final double renderScale;
  final double devicePixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final unit = 1 / renderScale;
    final outer = _stepPath(rect, cut);
    final middle = _stepPath(
      _inset(rect, 2 * unit),
      math.max(4 * unit, cut - 2 * unit),
    );
    final inner = _stepPath(
      _inset(rect, 4 * unit),
      math.max(4 * unit, cut - 4 * unit),
    );
    final paint = Paint()..isAntiAlias = false;
    canvas.drawPath(
      outer.shift(Offset(0, 5 * unit)),
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
    double aligned(double input) {
      final physicalScale = devicePixelRatio * renderScale;
      return (input * physicalScale).roundToDouble() / physicalScale;
    }

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
      renderScale != oldDelegate.renderScale ||
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
