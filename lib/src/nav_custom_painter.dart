import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

const s = 0.24;

class NavCustomPainter extends CustomPainter {
  late double loc;
  late double bottom;
  Color color;
  bool hasLabel;
  TextDirection textDirection;

  NavCustomPainter({
    required double startingLoc,
    required int itemsLength,
    required this.color,
    required this.textDirection,
    this.hasLabel = false,
  }) {
    final span = 1.0 / itemsLength;
    final l = startingLoc + (span - s) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
    bottom = hasLabel
        ? (Platform.isAndroid ? 0.55 : 0.45)
        : (Platform.isAndroid ? 0.6 : 0.5);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = Radius.circular(200); // <-- border radius you want

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, radius);
    final padding = size.width * .15;
    final width = size.width - (padding * 2);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(width * (loc - 0.05) + padding, 0)
      ..cubicTo(
        width * (loc + s * 0.2) + padding, // topX
        size.height * 0.05, // topY
        width * loc + padding, // bottomX
        size.height * bottom, // bottomY
        width * (loc + s * 0.5) + padding, // centerX
        size.height * bottom, // centerY
      )
      ..cubicTo(
        width * (loc + s) + padding, // bottomX
        size.height * bottom, // bottomY
        width * (loc + s * 0.8) + padding, // topX
        size.height * 0.05, // topY
        width * (loc + s + 0.05) + padding,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final finalPath = Path.combine(
      PathOperation.intersect,
      Path()..addRRect(rrect),
      path,
    );
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
