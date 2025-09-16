import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../index.dart';

class RSIButtonOutlined extends StatelessWidget {
  const RSIButtonOutlined({
    required this.onTap,
    this.child,
    this.text = 'My button',
    this.edgeClipper = RSIEdgeClipper.init,
    this.color = kTextColor,
    this.width = 180,
    this.height,
    this.icon,
    super.key,
  });
  final VoidCallback onTap;
  final String text;
  final RSIEdgeClipper edgeClipper;
  final Color color;
  final double width;
  final double? height;
  final Icon? icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OutlinedPainter(edgeClipper: edgeClipper, color: color),
      child: ClipPath(
        clipper: RSIClipper(edgeClipper: edgeClipper),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            highlightColor: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              width: width,
              height: height ?? 26.sp,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: child ?? HeaderMediumTextButton(text: text, color: color),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
