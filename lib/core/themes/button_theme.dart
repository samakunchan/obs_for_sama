import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/core_theme_index.dart';

TextButtonThemeData kTextButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed) || states.contains(WidgetState.focused)) {
          return kButtonColor;
        }
        return kButtonColor;
      },
    ),
    minimumSize: WidgetStateProperty.all<Size>(const Size(80, 50)),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
    // overlayColor: WidgetStateProperty.resolveWith<Color?>(
    //   (Set<WidgetState> states) {
    //     if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed) || states.contains(WidgetState.focused)) {
    //       return kHoverButtonColor;
    //     }
    //     return null;
    //   },
    // ),
    textStyle: WidgetStateProperty.all<TextStyle>(
      kheadlineMedium.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
    ),
    splashFactory: NoSplash.splashFactory,
  ),
);
