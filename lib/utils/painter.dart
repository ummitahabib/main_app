import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  final Color _color;

  Painter(this._color);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;
    //a circle
    canvas.drawCircle(const Offset(200, 200), 100, paint1);
  }
}
