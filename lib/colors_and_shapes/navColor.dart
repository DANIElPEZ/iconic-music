import 'package:flutter/material.dart';
import 'package:iconicmusic/colors_and_shapes/colors.dart';

class customNavShape extends CustomPainter {
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()..color = colorsPalette[1];
    final Rect backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(backgroundRect, backgroundPaint);

    final Paint paint1 = Paint();
    final Paint paint2 = Paint();

    final Path path1 = Path();

    path1.lineTo(0, 0);
    path1.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path1.lineTo(size.width, 0);
    path1.lineTo(size.width, 50);
    path1.quadraticBezierTo(
        3 * size.width / 4, size.height - 40, size.width / 2, size.height - 60);
    path1.quadraticBezierTo(
        size.width / 4, size.height - 80, 0, size.height - 20);
    path1.lineTo(0, 50);

    final Path path2 = Path();
    path2.moveTo(0, size.height);
    path2.quadraticBezierTo(
        size.width / 4, size.height - 63, size.width / 1.4, size.height);
    path2.quadraticBezierTo(
        size.width, size.height + 20, size.width, size.height);
    path2.lineTo(size.width, size.height);

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);

    final gradient = LinearGradient(
      colors: [colorsPalette[0], colorsPalette[3],colorsPalette[1], colorsPalette[3]],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final Rect gradientRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint gradientPaint = Paint()
      ..shader = gradient.createShader(gradientRect);

    canvas.drawPath(path1, gradientPaint);
    canvas.drawPath(path2, gradientPaint);
  }
}
