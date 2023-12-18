import 'package:flutter/material.dart';

class OpenPainter extends CustomPainter {
  final Color color;

  OpenPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(15, 0), 6, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
