import 'package:flutter/material.dart';

import 'pixel_pressable.dart';
import 'pixel_tokens.dart';

/// 只读的标签/值信息行，例如版本、作者等元数据。
class PixelInfoRow extends StatelessWidget {
  const PixelInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacingMd,
          vertical: tokens.spacingSm + tokens.spacingXs,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: tokens.body(fontSize: 16, color: tokens.textSecondary),
            ),
            SizedBox(width: tokens.spacingMd),
            Expanded(
              child: Text(
                value,
                style: tokens.body(fontSize: 17),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 带说明值的整行链接/跳转操作。
class PixelLinkTile extends StatelessWidget {
  const PixelLinkTile({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final String value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return PixelPressable(
      semanticLabel: '$label: $value',
      onPressed: onPressed,
      builder: (context, state) => SizedBox(
        width: double.infinity,
        child: ColoredBox(
          color: state.pressed
              ? tokens.pressedOverlay
              : state.hovered
              ? tokens.hoverOverlay
              : tokens.background.withValues(alpha: 0),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spacingMd,
              vertical: tokens.spacingSm + tokens.spacingXs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: tokens.body(fontSize: 16, color: tokens.textSecondary),
                ),
                SizedBox(height: tokens.spacingXs),
                Text(
                  value,
                  style: tokens.body(fontSize: 16, color: tokens.accent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 面板内的紧凑文字清单。
class PixelTextList extends StatelessWidget {
  const PixelTextList({super.key, required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacingMd,
          vertical: tokens.spacingSm + tokens.spacingXs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < values.length; index++) ...[
              Text(
                values[index],
                style: tokens.body(fontSize: 16, color: tokens.textSecondary),
              ),
              if (index != values.length - 1)
                SizedBox(height: tokens.spacingSm),
            ],
          ],
        ),
      ),
    );
  }
}
