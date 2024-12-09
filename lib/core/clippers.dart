import 'package:flutter/material.dart';

class RSIEdgeClipper {
  const RSIEdgeClipper({
    this.edgeRightTop = false,
    this.edgeRightBottom = false,
    this.edgeLeftBottom = false,
    this.edgeLeftTop = false,
  });

  final bool edgeRightTop;
  final bool edgeRightBottom;
  final bool edgeLeftBottom;
  final bool edgeLeftTop;
}

class RSIClipper extends CustomClipper<Path> {
  const RSIClipper({
    required this.edgeClipper,
  });

  final RSIEdgeClipper edgeClipper;

  @override
  Path getClip(Size size) {
    final path = Path();
    if (edgeClipper.edgeRightTop && edgeClipper.edgeLeftBottom) {
      return path
        ..moveTo(0, 0)
        ..lineTo(size.width - 25, 0)
        ..lineTo(size.width, 25)
        ..lineTo(size.width, size.height)
        ..lineTo(25, size.height)
        ..lineTo(0, size.height - 25)
        ..close();
    } else if (edgeClipper.edgeRightBottom && edgeClipper.edgeLeftTop) {
      return path
        ..moveTo(0, 25)
        ..lineTo(25, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 25)
        ..lineTo(size.width, size.height - 25)
        ..lineTo(size.width - 25, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeRightBottom && edgeClipper.edgeLeftBottom) {
      return path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 25)
        ..lineTo(size.width, size.height - 25)
        ..lineTo(size.width - 25, size.height)
        ..lineTo(25, size.height)
        ..lineTo(0, size.height - 25)
        ..close();
    } else if (edgeClipper.edgeRightTop) {
      return path
        ..moveTo(0, 0)
        ..lineTo(size.width - 25, 0)
        ..lineTo(size.width, 25)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeRightBottom) {
      return path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 25)
        ..lineTo(size.width, size.height - 25)
        ..lineTo(size.width - 25, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeLeftTop) {
      return path
        ..moveTo(0, 25)
        ..lineTo(25, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 25)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeLeftBottom) {
      return path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 25)
        ..lineTo(size.width, size.height)
        ..lineTo(25, size.height)
        ..lineTo(0, size.height - 25)
        ..close();
    } else {
      return path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 25)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
