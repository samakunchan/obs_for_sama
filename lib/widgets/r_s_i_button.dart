import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/constantes.dart';
import 'package:obs_for_sama/widgets/header_medium_text_button.dart';

class RSIButton extends StatelessWidget {
  const RSIButton({
    required this.onTap,
    this.child,
    this.text = 'My button',
    this.edgeClipper = RSIEdgeClipper.init,
    this.color = kButtonColor,
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
    return ClipPath(
      clipper: RSIClipper(edgeClipper: edgeClipper),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Theme.of(context).colorScheme.onSecondary,
          highlightColor: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
            width: width,
            height: height,
            child: Center(
              child: child ??
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: HeaderMediumTextButton(text: text),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
