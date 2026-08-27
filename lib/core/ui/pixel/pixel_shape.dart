import 'dart:math' as math;

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

Path pixelCutPath(Rect rect, double cutSize, {double stepSize = 2}) {
  final maximumCut = rect.shortestSide / 3;
  final requestedCut = cutSize < 2 ? 2.0 : cutSize;
  final cut = requestedCut > maximumCut ? maximumCut : requestedCut;
  final requestedStep = stepSize < 2 ? 2.0 : stepSize;
  final roundedStepCount = (cut / requestedStep).round();
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
  const PixelCutClipper(this.cutSize, {this.stepSize = 2});

  final double cutSize;
  final double stepSize;

  @override
  Path getClip(Size size) =>
      pixelCutPath(Offset.zero & size, cutSize, stepSize: stepSize);

  @override
  bool shouldReclip(covariant PixelCutClipper oldClipper) {
    return oldClipper.cutSize != cutSize || oldClipper.stepSize != stepSize;
  }
}

/// 设计稿中的大型 Pixel Sheet 圆弧。
///
/// 每个角使用 `7 × 6` 个像素格：横向步长为 `3-1-1-1-1`，
/// 纵向步长为 `1-1-1-1-2`。路径只包含水平线和垂直线。
Path pixelArcCutPath(Rect rect, double radius, {double pixelSize = 4}) {
  final requestedPixel = pixelSize < 2 ? 2.0 : pixelSize;
  final requestedRadius = radius < requestedPixel * 7
      ? requestedPixel * 7
      : radius;
  final grid = math.min(
    requestedPixel,
    math.min(requestedRadius / 7, math.min(rect.width / 14, rect.height / 12)),
  );
  final cutX = grid * 7;
  final cutY = grid * 6;
  final width = rect.width;
  final height = rect.height;

  return _polygonPath(rect, [
    Offset(cutX, 0),
    Offset(width - cutX, 0),
    Offset(width - cutX, grid),
    Offset(width - grid * 4, grid),
    Offset(width - grid * 4, grid * 2),
    Offset(width - grid * 3, grid * 2),
    Offset(width - grid * 3, grid * 3),
    Offset(width - grid * 2, grid * 3),
    Offset(width - grid * 2, grid * 4),
    Offset(width - grid, grid * 4),
    Offset(width - grid, cutY),
    Offset(width, cutY),
    Offset(width, height - cutY),
    Offset(width - grid, height - cutY),
    Offset(width - grid, height - grid * 4),
    Offset(width - grid * 2, height - grid * 4),
    Offset(width - grid * 2, height - grid * 3),
    Offset(width - grid * 3, height - grid * 3),
    Offset(width - grid * 3, height - grid * 2),
    Offset(width - grid * 4, height - grid * 2),
    Offset(width - grid * 4, height - grid),
    Offset(width - cutX, height - grid),
    Offset(width - cutX, height),
    Offset(cutX, height),
    Offset(cutX, height - grid),
    Offset(grid * 4, height - grid),
    Offset(grid * 4, height - grid * 2),
    Offset(grid * 3, height - grid * 2),
    Offset(grid * 3, height - grid * 3),
    Offset(grid * 2, height - grid * 3),
    Offset(grid * 2, height - grid * 4),
    Offset(grid, height - grid * 4),
    Offset(grid, height - cutY),
    Offset(0, height - cutY),
    Offset(0, cutY),
    Offset(grid, cutY),
    Offset(grid, grid * 4),
    Offset(grid * 2, grid * 4),
    Offset(grid * 2, grid * 3),
    Offset(grid * 3, grid * 3),
    Offset(grid * 3, grid * 2),
    Offset(grid * 4, grid * 2),
    Offset(grid * 4, grid),
    Offset(cutX, grid),
  ]);
}

class PixelArcCutClipper extends CustomClipper<Path> {
  const PixelArcCutClipper(this.radius, {this.pixelSize = 4});

  final double radius;
  final double pixelSize;

  @override
  Path getClip(Size size) =>
      pixelArcCutPath(Offset.zero & size, radius, pixelSize: pixelSize);

  @override
  bool shouldReclip(covariant PixelArcCutClipper oldClipper) {
    return oldClipper.radius != radius || oldClipper.pixelSize != pixelSize;
  }
}
