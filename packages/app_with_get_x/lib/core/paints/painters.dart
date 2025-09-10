import 'package:flutter/material.dart';

import 'clippers.dart';

class OutlinedPainter extends CustomPainter {
  OutlinedPainter({
    required this.edgeClipper,
    required this.color,
  });

  final RSIEdgeClipper edgeClipper;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = RSIClipper(edgeClipper: edgeClipper).getClip(size);

    final Paint borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(OutlinedPainter oldDelegate) => color != oldDelegate.color;
}
