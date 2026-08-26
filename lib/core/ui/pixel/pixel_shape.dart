import 'package:flutter/material.dart';

Path pixelCutPath(Rect rect, double cutSize) {
  final cut = cutSize.clamp(4.0, rect.shortestSide / 3);
  final step = cut / 2;
  final left = rect.left;
  final right = rect.right;
  final top = rect.top;
  final bottom = rect.bottom;

  return Path()
    ..moveTo(left + cut, top)
    ..lineTo(right - cut, top)
    ..lineTo(right - step, top + step)
    ..lineTo(right - step, top + cut)
    ..lineTo(right, top + cut)
    ..lineTo(right, bottom - cut)
    ..lineTo(right - step, bottom - cut)
    ..lineTo(right - step, bottom - step)
    ..lineTo(right - cut, bottom)
    ..lineTo(left + cut, bottom)
    ..lineTo(left + step, bottom - step)
    ..lineTo(left + step, bottom - cut)
    ..lineTo(left, bottom - cut)
    ..lineTo(left, top + cut)
    ..lineTo(left + step, top + cut)
    ..lineTo(left + step, top + step)
    ..close();
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
