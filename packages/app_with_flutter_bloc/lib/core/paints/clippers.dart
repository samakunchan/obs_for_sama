import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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

  static const init = RSIEdgeClipper();
}

class RSIClipper extends CustomClipper<Path> {
  const RSIClipper({
    required this.edgeClipper,
  });

  final RSIEdgeClipper edgeClipper;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    if (edgeClipper.edgeRightTop && edgeClipper.edgeLeftBottom) {
      return path
        ..lineTo(size.width - 15.sp, 0)
        ..lineTo(size.width, 15.sp)
        ..lineTo(size.width, size.height)
        ..lineTo(15.sp, size.height)
        ..lineTo(0, size.height - 15.sp)
        ..close();
    } else if (edgeClipper.edgeRightBottom && edgeClipper.edgeLeftTop) {
      return path
        ..moveTo(0, 15.sp)
        ..lineTo(15.sp, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 15.sp)
        ..lineTo(size.width, size.height - (size.height - 15.sp))
        ..lineTo(size.width - 15.sp, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeRightTop && edgeClipper.edgeLeftTop) {
      return path
        ..moveTo(0, 15.sp)
        ..lineTo(15.sp, 0)
        ..lineTo(size.width - 15.sp, 0)
        ..lineTo(size.width, size.height - (size.height - 15.sp))
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeRightBottom && edgeClipper.edgeLeftBottom) {
      return path
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 15.sp)
        ..lineTo(size.width, size.height - 15.sp)
        ..lineTo(size.width - 15.sp, size.height)
        ..lineTo(15.sp, size.height)
        ..lineTo(0, size.height - 15.sp)
        ..close();
    } else if (edgeClipper.edgeRightTop && edgeClipper.edgeRightBottom) {
      return path
        ..lineTo(size.width - 15.sp, 0)
        ..lineTo(size.width, 15.sp)
        ..lineTo(size.width, size.height - 15.sp)
        ..lineTo(size.width - 15.sp, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeLeftTop && edgeClipper.edgeLeftBottom) {
      return path
        ..moveTo(0, 15.sp)
        ..lineTo(15.sp, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(15.sp, size.height)
        ..lineTo(0, size.height - 15.sp)
        ..close();
    } else if (edgeClipper.edgeRightTop) {
      return path
        // ..moveTo(0, 0)
        ..lineTo(size.width - 15.sp, 0)
        ..lineTo(size.width, 15.sp)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeRightBottom) {
      return path
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 15.sp)
        ..lineTo(size.width, size.height - 15.sp)
        ..lineTo(size.width - 15.sp, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeLeftTop) {
      return path
        ..moveTo(0, 15.sp)
        ..lineTo(15.sp, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 15.sp)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (edgeClipper.edgeLeftBottom) {
      return path
        ..lineTo(size.width, 0)
        ..lineTo(size.width, 15.sp)
        ..lineTo(size.width, size.height)
        ..lineTo(15.sp, size.height)
        ..lineTo(0, size.height - 15.sp)
        ..close();
    } else {
      moveToOrigin(path: path, size: size, cutSize: 0);

      lineTop(path: path, size: size, cutSize: 0);

      cutLeftTop(path: path, size: size, cutSize: 0); // L

      cutRightTop(path: path, size: size, cutSize: 0);

      cutRightBottom(path: path, size: size, cutSize: 0);

      lineBottom(path: path, size: size, cutSize: 0);

      cutLeftBottom(path: path, size: size, cutSize: 0);

      /// Facultatif (retour à l'origine)
      // moveToOrigin(path: path, size: size, cutSize: 15.sp);
      path.close();

      return path;
    }
  }

  void lineTop({
    required Path path,
    required Size size,
    double cutSize = 25,
    RSIEdgeClipper edgeClipper = RSIEdgeClipper.init,
  }) {
    if (edgeClipper.edgeLeftTop) {
      path
        ..moveTo(cutSize, 0) // Origine
        ..lineTo(size.width, 0);
    } else {
      path
        ..moveTo(cutSize, 0) // Origine
        ..lineTo(size.width - cutSize, 0);
    }
  }

  void lineBottom({
    required Path path,
    required Size size,
    double cutSize = 25,
  }) {
    path
      ..moveTo(size.width - cutSize, size.height)
      ..lineTo(cutSize, size.height);
  }

  void moveToOrigin({
    required Path path,
    required Size size,
    double cutSize = 25,
  }) {
    path.moveTo(cutSize, 0);
  }

  void cutLeftTop({
    required Path path,
    required Size size,
    double cutSize = 25,
  }) {
    path
      ..moveTo(0, cutSize)
      ..lineTo(cutSize, 0);
  }

  void cutRightTop({
    required Path path,
    required Size size,
    double cutSize = 25,
  }) {
    path
      ..moveTo(size.width - cutSize, 0)
      ..lineTo(size.width, cutSize);
  }

  void cutRightBottom({
    required Path path,
    required Size size,
    double cutSize = 25,
  }) {
    path
      ..moveTo(size.width, cutSize)
      ..lineTo(size.width - cutSize, size.height);
  }

  void cutLeftBottom({
    required Path path,
    required Size size,
    double cutSize = 25,
  }) {
    path
      ..moveTo(cutSize, size.height)
      ..lineTo(0, cutSize);
  }

  @override
  // bool shouldReclip(RSIClipper oldClipper) => oldClipper.edgeClipper.toString() != edgeClipper.toString();
  bool shouldReclip(RSIClipper oldClipper) => true;
}

// ..moveTo(0, 15.sp) // F2
// ..lineTo(15.sp, 0)
// ..lineTo(size.width, 0) // Fin
// ..lineTo(size.width - 15.sp, 0)
// ..lineTo(size.width, size.height - 15.sp) // Enter
// ..lineTo(size.width - 15.sp, size.height)
// ..lineTo(size.width, size.height)
// ..lineTo(15.sp, size.height)
// ..lineTo(0, size.height - 15.sp)
// ..lineTo(0, size.height)
