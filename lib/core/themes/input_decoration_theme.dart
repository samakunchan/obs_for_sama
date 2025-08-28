import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/core_theme_index.dart';

InputDecorationTheme kInputDecorationTheme = InputDecorationTheme(
  labelStyle: kbodyLarge,
  suffixIconColor: kButtonColor,
  prefixIconColor: kButtonColor,
  border: const OutlineInputBorder(
    borderSide: BorderSide(color: kButtonColor, width: .2),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: kButtonColor, width: .2),
  ),
);
