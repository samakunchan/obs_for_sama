import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/index.dart';
import 'package:sizer/sizer.dart';

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
  iconTheme: IconThemeData(color: kTextShadow, size: 20.sp),
  drawerTheme: DrawerThemeData(backgroundColor: kPrimaryColor, elevation: 40.sp),
  listTileTheme: ListTileThemeData(
    horizontalTitleGap: 20,
    contentPadding: Device.screenType == ScreenType.mobile
        ? null
        : EdgeInsets.symmetric(
            vertical: 12.sp,
            horizontal: 16.sp,
          ),
  ),
);
