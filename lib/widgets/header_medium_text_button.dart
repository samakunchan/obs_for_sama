import 'package:flutter/material.dart';

class HeaderMediumTextButton extends StatelessWidget {
  const HeaderMediumTextButton({required this.text, this.color = Colors.black, super.key});
  final String text;
  final Color color;

  @override
  Text build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            letterSpacing: 1,
          ),
      textAlign: TextAlign.center,
      overflow: TextOverflow.clip,
    );
  }
}
