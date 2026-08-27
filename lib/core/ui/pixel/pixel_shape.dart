import 'package:flutter/material.dart';

Path _polygonPath(Rect rect, List<Offset> points) {
  final path = Path();
  for (var index = 0; index < points.length; index++) {
    final point = points[index];
    final translated = Offset(rect.left + point.dx, rect.top + point.dy);
    if (index == 0) {
      path.moveTo(translated.dx, translated.dy);
    } else {
      path.lineTo(translated.dx, translated.dy);
    }
  }
  return path..close();
}

/// Settings 分组最外层的 2px 阶梯轮廓，对应 HTML 的 panel-outer。
Path pixelPanelOuterPath(Rect rect) {
  final width = rect.width;
  final height = rect.height;
  return _polygonPath(rect, [
    const Offset(10, 0),
    Offset(width - 10, 0),
    Offset(width - 10, 2),
    Offset(width - 6, 2),
    Offset(width - 6, 4),
    Offset(width - 4, 4),
    Offset(width - 4, 6),
    Offset(width - 2, 6),
    Offset(width - 2, 10),
    Offset(width, 10),
    Offset(width, height - 10),
    Offset(width - 2, height - 10),
    Offset(width - 2, height - 6),
    Offset(width - 4, height - 6),
    Offset(width - 4, height - 4),
    Offset(width - 6, height - 4),
    Offset(width - 6, height - 2),
    Offset(width - 10, height - 2),
    Offset(width - 10, height),
    Offset(10, height),
    Offset(10, height - 2),
    Offset(6, height - 2),
    Offset(6, height - 4),
    Offset(4, height - 4),
    Offset(4, height - 6),
    Offset(2, height - 6),
    Offset(2, height - 10),
    Offset(0, height - 10),
    const Offset(0, 10),
    const Offset(2, 10),
    const Offset(2, 6),
    const Offset(4, 6),
    const Offset(4, 4),
    const Offset(6, 4),
    const Offset(6, 2),
    const Offset(10, 2),
  ]);
}

/// Settings 分组暖灰描边轮廓，对应 HTML 的 panel-middle。
Path pixelPanelMiddlePath(Rect rect) {
  final width = rect.width;
  final height = rect.height;
  return _polygonPath(rect, [
    const Offset(8, 0),
    Offset(width - 8, 0),
    Offset(width - 8, 2),
    Offset(width - 4, 2),
    Offset(width - 4, 4),
    Offset(width - 2, 4),
    Offset(width - 2, 8),
    Offset(width, 8),
    Offset(width, height - 8),
    Offset(width - 2, height - 8),
    Offset(width - 2, height - 4),
    Offset(width - 4, height - 4),
    Offset(width - 4, height - 2),
    Offset(width - 8, height - 2),
    Offset(width - 8, height),
    Offset(8, height),
    Offset(8, height - 2),
    Offset(4, height - 2),
    Offset(4, height - 4),
    Offset(2, height - 4),
    Offset(2, height - 8),
    Offset(0, height - 8),
    const Offset(0, 8),
    const Offset(2, 8),
    const Offset(2, 4),
    const Offset(4, 4),
    const Offset(4, 2),
    const Offset(8, 2),
  ]);
}

/// Settings 分组内容裁切轮廓，对应 HTML 的 panel-inner。
Path pixelPanelInnerPath(Rect rect) {
  final width = rect.width;
  final height = rect.height;
  return _polygonPath(rect, [
    const Offset(6, 0),
    Offset(width - 6, 0),
    Offset(width - 6, 2),
    Offset(width - 2, 2),
    Offset(width - 2, 6),
    Offset(width, 6),
    Offset(width, height - 6),
    Offset(width - 2, height - 6),
    Offset(width - 2, height - 2),
    Offset(width - 6, height - 2),
    Offset(width - 6, height),
    Offset(6, height),
    Offset(6, height - 2),
    Offset(2, height - 2),
    Offset(2, height - 6),
    Offset(0, height - 6),
    const Offset(0, 6),
    const Offset(2, 6),
    const Offset(2, 2),
    const Offset(6, 2),
  ]);
}

/// 64x40 Radio 的黑色外轮廓，对应 HTML 的 switch-outer。
Path pixelSwitchOuterPath(Rect rect) {
  final width = rect.width;
  final height = rect.height;
  return _polygonPath(rect, [
    const Offset(14, 0),
    Offset(width - 14, 0),
    Offset(width - 14, 2),
    Offset(width - 10, 2),
    Offset(width - 10, 4),
    Offset(width - 6, 4),
    Offset(width - 6, 6),
    Offset(width - 4, 6),
    Offset(width - 4, 10),
    Offset(width - 2, 10),
    Offset(width - 2, 14),
    Offset(width, 14),
    Offset(width, height - 14),
    Offset(width - 2, height - 14),
    Offset(width - 2, height - 10),
    Offset(width - 4, height - 10),
    Offset(width - 4, height - 6),
    Offset(width - 6, height - 6),
    Offset(width - 6, height - 4),
    Offset(width - 10, height - 4),
    Offset(width - 10, height - 2),
    Offset(width - 14, height - 2),
    Offset(width - 14, height),
    Offset(14, height),
    Offset(14, height - 2),
    Offset(10, height - 2),
    Offset(10, height - 4),
    Offset(6, height - 4),
    Offset(6, height - 6),
    Offset(4, height - 6),
    Offset(4, height - 10),
    Offset(2, height - 10),
    Offset(2, height - 14),
    Offset(0, height - 14),
    const Offset(0, 14),
    const Offset(2, 14),
    const Offset(2, 10),
    const Offset(4, 10),
    const Offset(4, 6),
    const Offset(6, 6),
    const Offset(6, 4),
    const Offset(10, 4),
    const Offset(10, 2),
    const Offset(14, 2),
  ]);
}

/// Radio 暖灰/橙色中轨；传入的矩形固定为 60x36。
Path pixelSwitchTrackPath(Rect rect) {
  final width = rect.width;
  final height = rect.height;
  return _polygonPath(rect, [
    const Offset(10, 0),
    Offset(width - 10, 0),
    Offset(width - 10, 2),
    Offset(width - 6, 2),
    Offset(width - 6, 4),
    Offset(width - 3, 4),
    Offset(width - 3, 8),
    Offset(width - 1, 8),
    Offset(width - 1, 10),
    Offset(width, 10),
    Offset(width, height - 10),
    Offset(width - 1, height - 10),
    Offset(width - 1, height - 8),
    Offset(width - 3, height - 8),
    Offset(width - 3, height - 4),
    Offset(width - 6, height - 4),
    Offset(width - 6, height - 2),
    Offset(width - 10, height - 2),
    Offset(width - 10, height),
    Offset(10, height),
    Offset(10, height - 2),
    Offset(6, height - 2),
    Offset(6, height - 4),
    Offset(3, height - 4),
    Offset(3, height - 8),
    Offset(1, height - 8),
    Offset(1, height - 10),
    Offset(0, height - 10),
    const Offset(0, 10),
    const Offset(1, 10),
    const Offset(1, 8),
    const Offset(3, 8),
    const Offset(3, 4),
    const Offset(6, 4),
    const Offset(6, 2),
    const Offset(10, 2),
  ]);
}

/// Radio 深色/橙色内轨；传入的矩形固定为 56x32。
Path pixelSwitchInnerTrackPath(Rect rect) {
  final width = rect.width;
  final height = rect.height;
  return _polygonPath(rect, [
    const Offset(8, 0),
    Offset(width - 8, 0),
    Offset(width - 8, 2),
    Offset(width - 4, 2),
    Offset(width - 4, 4),
    Offset(width - 2, 4),
    Offset(width - 2, 8),
    Offset(width, 8),
    Offset(width, height - 8),
    Offset(width - 2, height - 8),
    Offset(width - 2, height - 4),
    Offset(width - 4, height - 4),
    Offset(width - 4, height - 2),
    Offset(width - 8, height - 2),
    Offset(width - 8, height),
    Offset(8, height),
    Offset(8, height - 2),
    Offset(4, height - 2),
    Offset(4, height - 4),
    Offset(2, height - 4),
    Offset(2, height - 8),
    Offset(0, height - 8),
    const Offset(0, 8),
    const Offset(2, 8),
    const Offset(2, 4),
    const Offset(4, 4),
    const Offset(4, 2),
    const Offset(8, 2),
  ]);
}

/// 22x24 Radio 滑块的五段式轮廓。
Path pixelSwitchKnobPath(Rect rect) {
  return _polygonPath(rect, const [
    Offset(6, 0),
    Offset(16, 0),
    Offset(16, 3),
    Offset(19, 3),
    Offset(19, 6),
    Offset(22, 6),
    Offset(22, 18),
    Offset(19, 18),
    Offset(19, 21),
    Offset(16, 21),
    Offset(16, 24),
    Offset(6, 24),
    Offset(6, 21),
    Offset(3, 21),
    Offset(3, 18),
    Offset(0, 18),
    Offset(0, 6),
    Offset(3, 6),
    Offset(3, 3),
    Offset(6, 3),
  ]);
}

Path pixelCutPath(Rect rect, double cutSize) {
  final maximumCut = rect.shortestSide / 3;
  final requestedCut = cutSize < 2 ? 2.0 : cutSize;
  final cut = requestedCut > maximumCut ? maximumCut : requestedCut;
  final roundedStepCount = (cut / 2).round();
  final stepCount = roundedStepCount < 1 ? 1 : roundedStepCount;
  final step = cut / stepCount;
  final left = rect.left;
  final right = rect.right;
  final top = rect.top;
  final bottom = rect.bottom;

  final path = Path()
    ..moveTo(left + cut, top)
    ..lineTo(right - cut, top);

  // 每一级都只使用水平线和垂直线，形成设计稿中的小方块锯齿角。
  for (var index = 0; index < stepCount; index++) {
    path
      ..lineTo(right - cut + index * step, top + (index + 1) * step)
      ..lineTo(right - cut + (index + 1) * step, top + (index + 1) * step);
  }
  path.lineTo(right, bottom - cut);
  for (var index = 0; index < stepCount; index++) {
    path
      ..lineTo(right - (index + 1) * step, bottom - cut + index * step)
      ..lineTo(right - (index + 1) * step, bottom - cut + (index + 1) * step);
  }
  path.lineTo(left + cut, bottom);
  for (var index = 0; index < stepCount; index++) {
    path
      ..lineTo(left + cut - index * step, bottom - (index + 1) * step)
      ..lineTo(left + cut - (index + 1) * step, bottom - (index + 1) * step);
  }
  path.lineTo(left, top + cut);
  for (var index = 0; index < stepCount; index++) {
    path
      ..lineTo(left + (index + 1) * step, top + cut - index * step)
      ..lineTo(left + (index + 1) * step, top + cut - (index + 1) * step);
  }
  return path..close();
}

class PixelCutClipper extends CustomClipper<Path> {
  const PixelCutClipper(this.cutSize);

  final double cutSize;

  @override
  Path getClip(Size size) => pixelCutPath(Offset.zero & size, cutSize);

  @override
  bool shouldReclip(covariant PixelCutClipper oldClipper) {
    return oldClipper.cutSize != cutSize;
  }
}
