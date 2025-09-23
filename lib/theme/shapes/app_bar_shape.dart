import 'package:flutter/material.dart';

class customShape extends CustomPainter {
  customShape({required this.bgColor});
  final Color bgColor;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = bgColor;
    final Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 20, size.height + 25, size.width / 2, size.height - 50);

    path.quadraticBezierTo(
        size.width / 1.5, size.height - 75, size.width, size.height - 10);

    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }
}
