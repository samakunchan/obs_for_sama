import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obs_for_sama/core/themes/color_scheme.dart';
import 'package:sizer/sizer.dart';

/// H1
TextStyle kheadlineLarge = GoogleFonts.unicaOne(
  fontWeight: FontWeight.w600,
  fontSize: 25.sp,
  letterSpacing: 4,
  color: kTextColorWhite,
);

/// H2
TextStyle kheadlineMedium = GoogleFonts.unicaOne(
  fontWeight: FontWeight.w600,
  fontSize: 16.sp,
  letterSpacing: 3.2,
  color: kTextColorWhite,
);

/// H3
TextStyle ktitle1 = GoogleFonts.unicaOne(
  fontWeight: FontWeight.w600,
  fontSize: 28.sp,
  letterSpacing: 2.4,
  color: kTextColorWhite,
);

/// Titre Default
TextStyle ktitle2 = GoogleFonts.roboto(
  fontWeight: FontWeight.bold,
  fontSize: 15.sp,
  letterSpacing: 1.2.sp,
  color: kTextColorWhite,
);

/// Text Default
TextStyle kbodyLarge = GoogleFonts.roboto(
  fontSize: 16.sp,
  letterSpacing: 1.6.sp,
  color: kBodyTextColor,
  height: 1,
);

TextTheme kTextTheme = TextTheme(
  headlineLarge: kheadlineLarge,
  headlineMedium: kheadlineMedium,
  titleLarge: ktitle1,
  titleMedium: ktitle2,
  bodyLarge: kbodyLarge,
);
