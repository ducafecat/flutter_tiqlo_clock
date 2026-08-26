import 'package:flutter/material.dart';

import 'pixel_panel.dart';
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
        items.add(Container(height: 1, color: tokens.outline));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            title.toUpperCase(),
            style: tokens.heading(fontSize: 18).copyWith(color: tokens.section),
          ),
        ),
        SizedBox(height: tokens.spacingMd - tokens.spacingXs),
        PixelPanel(
          padding: EdgeInsets.zero,
          child: Column(children: items),
        ),
      ],
    );
  }
}
