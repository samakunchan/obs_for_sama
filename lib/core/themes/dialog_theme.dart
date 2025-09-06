import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/index.dart';

DialogThemeData kDialogTheme = DialogThemeData(
  backgroundColor: Colors.red,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  titleTextStyle: ktitle1.copyWith(color: kPrimaryColor),
  contentTextStyle: ktitle2,
  insetPadding: const EdgeInsets.all(16),
);
