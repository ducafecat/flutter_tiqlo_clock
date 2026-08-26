import 'package:flutter/material.dart';

import 'pixel_shape.dart';
import 'pixel_tokens.dart';

class PixelSection extends StatelessWidget {
  const PixelSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final items = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      items.add(children[index]);
      if (index != children.length - 1) {
        items.add(const _SettingsDivider());
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            title.toUpperCase(),
            style: tokens.heading(fontSize: 19).copyWith(color: tokens.section),
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
    return Stack(
      children: [
        Positioned.fill(
          child: Transform.translate(
            offset: const Offset(1, 1),
            child: const _PanelLayer(color: Color(0xFF050504), cut: 10),
          ),
        ),
        Positioned.fill(
          child: const _PanelLayer(color: Color(0xFF0B0A09), cut: 10),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: _PanelLayer(
            color: const Color(0xFF5B554B),
            cut: 8,
            padding: 2,
            child: _PanelLayer(
              color: const Color(0xFF26231F),
              cut: 6,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class _PanelLayer extends StatelessWidget {
  const _PanelLayer({
    required this.color,
    required this.cut,
    this.padding = 0,
    this.child,
  });

  final Color color;
  final double cut;
  final double padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) => ClipPath(
    clipper: PixelCutClipper(cut),
    child: Container(
      color: color,
      padding: EdgeInsets.all(padding),
      child: child,
    ),
  );
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 5,
    child: Column(
      children: [
        Expanded(child: ColoredBox(color: Color(0xFF100F0D))),
        Expanded(flex: 2, child: ColoredBox(color: Color(0xFF5B554B))),
        Expanded(flex: 2, child: ColoredBox(color: Color(0xFF090807))),
      ],
    ),
  );
}
