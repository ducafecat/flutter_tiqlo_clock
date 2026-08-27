import 'package:flutter/material.dart';

import 'pixel_shape.dart';
import 'pixel_tokens.dart';

class PixelSection extends StatelessWidget {
  const PixelSection({
    super.key,
    required this.title,
    required this.children,
    this.showDividers = true,
  });

  final String title;
  final List<Widget> children;

  /// 同类设置项默认显示分隔线；信息型内容可关闭，由内容自身组织排版。
  final bool showDividers;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final items = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      items.add(children[index]);
      if (showDividers && index != children.length - 1) {
        items.add(const _SettingsDivider());
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              title.toUpperCase(),
              style: tokens
                  .heading(fontSize: 19)
                  .copyWith(color: tokens.section, letterSpacing: 1.52),
            ),
          ),
        ),
        const SizedBox(height: 9),
        _SettingsPanel(child: Column(children: items)),
      ],
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _SettingsPanelPainter(),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ClipPath(
          clipper: const _PanelContentClipper(),
          child: ColoredBox(color: const Color(0xFF26231F), child: child),
        ),
      ),
    );
  }
}

class _SettingsPanelPainter extends CustomPainter {
  const _SettingsPanelPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final outer = pixelPanelOuterPath(rect);

    canvas.drawPath(
      outer.shift(const Offset(1, 1)),
      Paint()..color = const Color(0xFF050504),
    );
    canvas.drawPath(outer, Paint()..color = const Color(0xFF0B0A09));

    final outlineRect = rect.deflate(2);
    canvas.drawPath(
      pixelPanelMiddlePath(outlineRect),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF756B5B),
            Color(0xFF5B554B),
            Color(0xFF5B554B),
            Color(0xFF39352F),
          ],
          stops: [0, 0.18, 0.82, 1],
        ).createShader(outlineRect),
    );

    final contentRect = rect.deflate(4);
    canvas.drawPath(
      pixelPanelInnerPath(contentRect),
      Paint()..color = const Color(0xFF26231F),
    );
  }

  @override
  bool shouldRepaint(covariant _SettingsPanelPainter oldDelegate) => false;
}

class _PanelContentClipper extends CustomClipper<Path> {
  const _PanelContentClipper();

  @override
  Path getClip(Size size) => pixelPanelInnerPath(Offset.zero & size);

  @override
  bool shouldReclip(covariant _PanelContentClipper oldClipper) => false;
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: ColoredBox(color: Color(0xFF100F0D))),
        Expanded(flex: 2, child: ColoredBox(color: Color(0xFF5B554B))),
        Expanded(flex: 2, child: ColoredBox(color: Color(0xFF090807))),
      ],
    ),
  );
}
