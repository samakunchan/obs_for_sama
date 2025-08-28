import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/core_theme_index.dart';
import 'package:obs_for_sama/widgets/header_medium_text_button.dart';

class RSIButtonOutlined extends StatelessWidget {
  const RSIButtonOutlined({
    required this.onTap,
    this.child,
    this.text = 'My button',
    this.edgeClipper = RSIEdgeClipper.init,
    this.color = kTextColor,
    this.width = 180,
    this.height = 50,
    this.icon,
    super.key,
  });
  final VoidCallback onTap;
  final String text;
  final RSIEdgeClipper edgeClipper;
  final Color color;
  final double width;
  final double height;
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
              height: height,
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
