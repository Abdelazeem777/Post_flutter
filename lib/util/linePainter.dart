import 'package:flutter/material.dart';

class linePainter extends CustomPainter{
       
  @override
void paint(Canvas canvas, Size size) {
  final p1 = Offset(0, 0);
  
    final p2 = Offset(size.width, 0);
  final paint = Paint()
    ..color = Color(0xffd7d7d7)
    ..strokeWidth = 4;
  canvas.drawLine(p1, p2, paint);
}

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
