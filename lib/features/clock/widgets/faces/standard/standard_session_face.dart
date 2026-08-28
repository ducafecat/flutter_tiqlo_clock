import 'package:flutter/material.dart';

import '../../../../../clock/clock_engine.dart';
import 'focus_sprite_assets.dart';

class StandardSessionFace extends StatelessWidget {
  const StandardSessionFace({
    super.key,
    required this.session,
    required this.landscape,
  });

  static const _background = Color(0xFFF4EEE4);
  static const _surface = Color(0xFFFBF7F0);
  static const _ink = Color(0xFF352B24);
  static const _mutedInk = Color(0xFF796B5E);
  static const _accent = Color(0xFFC97835);

  final SessionSnapshot session;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    final complete = session.status == SessionStatus.complete;
    final paused = session.status == SessionStatus.paused;
    final primaryLabel = complete ? 'COMPLETE' : session.remainingLabel;
    final semanticLabel = [
      primaryLabel,
      session.kindLabel,
      if (paused) 'PAUSED',
      if (complete) '${session.duration.inMinutes} min',
    ].join(', ');

    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: ColoredBox(
          color: _background,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: landscape ? 28 : 20,
              vertical: landscape ? 20 : 28,
            ),
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: _ink.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _ink.withValues(alpha: 0.12),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: landscape
                        ? _LandscapeSessionContent(
                            session: session,
                            primaryLabel: primaryLabel,
                          )
                        : _PortraitSessionContent(
                            session: session,
                            primaryLabel: primaryLabel,
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

class _PortraitSessionContent extends StatelessWidget {
  const _PortraitSessionContent({
    required this.session,
    required this.primaryLabel,
  });

  final SessionSnapshot session;
  final String primaryLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 292,
      height: 486,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Brand(),
          const SizedBox(height: 16),
          _SessionScene(session: session, height: 244),
          const SizedBox(height: 18),
          _SessionTime(
            session: session,
            primaryLabel: primaryLabel,
            fontSize: session.status == SessionStatus.complete ? 48 : 72,
          ),
          const SizedBox(height: 10),
          _SessionLabels(session: session),
        ],
      ),
    );
  }
}

class _LandscapeSessionContent extends StatelessWidget {
  const _LandscapeSessionContent({
    required this.session,
    required this.primaryLabel,
  });

  final SessionSnapshot session;
  final String primaryLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 680,
      height: 270,
      child: Row(
        children: [
          SizedBox(
            width: 270,
            child: _SessionScene(session: session, height: 250),
          ),
          const SizedBox(width: 36),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Brand(alignment: MainAxisAlignment.start),
                const SizedBox(height: 18),
                _SessionTime(
                  session: session,
                  primaryLabel: primaryLabel,
                  fontSize: session.status == SessionStatus.complete ? 56 : 92,
                ),
                const SizedBox(height: 14),
                _SessionLabels(session: session),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({this.alignment = MainAxisAlignment.center});

  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FocusSprite(FocusSpriteAssets.tiqloWordmark, width: 72),
        const SizedBox(width: 12),
        Container(width: 1, height: 20, color: StandardSessionFace._mutedInk),
        const SizedBox(width: 12),
        const Text(
          'BREW YOUR TIME',
          style: TextStyle(
            color: StandardSessionFace._mutedInk,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
      ],
    );
  }
}

class _SessionScene extends StatelessWidget {
  const _SessionScene({required this.session, required this.height});

  final SessionSnapshot session;
  final double height;

  @override
  Widget build(BuildContext context) {
    final complete = session.status == SessionStatus.complete;
    final machineAsset = switch (session.status) {
      SessionStatus.running => FocusSpriteAssets.machineBrewing,
      SessionStatus.paused => FocusSpriteAssets.machineReady,
      SessionStatus.complete => FocusSpriteAssets.machineComplete,
    };
    final progressAsset = complete
        ? FocusSpriteAssets.coffeeCupSteam
        : FocusSpriteAssets.coffeeProgress(_progress(session));

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 18,
            top: 0,
            bottom: 0,
            child: FocusSprite(
              machineAsset,
              key: const ValueKey('standard-session-machine'),
              width: 138,
            ),
          ),
          Positioned(
            right: complete ? 14 : 4,
            bottom: complete ? 15 : 24,
            child: FocusSprite(
              progressAsset,
              key: const ValueKey('standard-session-progress'),
              width: complete ? 92 : 108,
              height: complete ? 150 : 86,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionTime extends StatelessWidget {
  const _SessionTime({
    required this.session,
    required this.primaryLabel,
    required this.fontSize,
  });

  final SessionSnapshot session;
  final String primaryLabel;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      primaryLabel,
      key: const ValueKey('standard-session-primary-label'),
      maxLines: 1,
      style: TextStyle(
        color: StandardSessionFace._ink,
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        height: 0.95,
        letterSpacing: session.status == SessionStatus.complete ? 1 : -2,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _SessionLabels extends StatelessWidget {
  const _SessionLabels({required this.session});

  final SessionSnapshot session;

  @override
  Widget build(BuildContext context) {
    final complete = session.status == SessionStatus.complete;
    final paused = session.status == SessionStatus.paused;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 8,
      children: [
        _StatusLabel(label: session.kindLabel, prominent: true),
        if (paused) const _StatusLabel(label: 'PAUSED'),
        if (complete)
          Text(
            '${session.duration.inMinutes} min',
            style: const TextStyle(
              color: StandardSessionFace._mutedInk,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.label, this.prominent = false});

  final String label;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: prominent
            ? StandardSessionFace._accent
            : StandardSessionFace._ink.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Text(
          label,
          style: TextStyle(
            color: prominent ? Colors.white : StandardSessionFace._mutedInk,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}

double _progress(SessionSnapshot session) {
  final total = session.duration.inMilliseconds;
  if (total <= 0) return 0;
  final elapsed = total - session.remaining.inMilliseconds;
  return (elapsed / total).clamp(0.0, 1.0);
}
