import 'package:flutter/material.dart';

import '../index.dart';

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
