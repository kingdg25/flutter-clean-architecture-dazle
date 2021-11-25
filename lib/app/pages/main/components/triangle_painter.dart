import 'package:dazle/app/utils/app.dart';
import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = App.mainColor
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.3);
    path.lineTo(size.width * 0.25, size.height * 0.75);
    path.lineTo(size.width * 0.75, size.height * 0.75);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}