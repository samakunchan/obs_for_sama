import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/index.dart';

class RSIOutlinedBody extends StatelessWidget {
  const RSIOutlinedBody({
    this.child,
    this.text = 'My Outlined body',
    this.edgeClipper = RSIEdgeClipper.init,
    this.color = kButtonColor,
    this.width = 180,
    this.height = 50,
    this.icon,
    super.key,
  });
  final String text;
  final RSIEdgeClipper edgeClipper;
  final Color color;
  final double width;
  final double height;
  final Icon? icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipPath(
        clipper: RSIClipper(edgeClipper: edgeClipper),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: ClipPath(
              clipper: RSIClipper(edgeClipper: edgeClipper),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor,
                ),
                width: width,
                height: height,
                child:
                    child ??
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: HeaderMediumTextButton(text: text),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
