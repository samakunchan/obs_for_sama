import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/index.dart';

final ThemeData kThemeData = ThemeData(
  appBarTheme: kAppBarTheme,
  scaffoldBackgroundColor: kPrimaryColor,
  colorScheme: kColorScheme,
  textTheme: kTextTheme,
  textButtonTheme: kTextButtonTheme,
  cardTheme: kCardTheme,
  dialogTheme: kDialogTheme,
  inputDecorationTheme: kInputDecorationTheme,
  tabBarTheme: kTabBarTheme,
  useMaterial3: true,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: kTextShadow,
  ),
  iconTheme: const IconThemeData(color: kTextShadow, size: 20),
);
