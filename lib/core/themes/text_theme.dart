import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obs_for_sama/core/themes/color_scheme.dart';

/// H1
TextStyle kheadlineLarge = GoogleFonts.unicaOne(
  fontWeight: FontWeight.w600,
  fontSize: 40,
  letterSpacing: 4,
  color: kTextColorWhite,
);

/// H2
TextStyle kheadlineMedium = GoogleFonts.unicaOne(
  fontWeight: FontWeight.w600,
  fontSize: 24,
  letterSpacing: 3.2,
  color: kTextColorWhite,
);

/// H3
TextStyle ktitle1 = GoogleFonts.unicaOne(
  fontWeight: FontWeight.w600,
  fontSize: 28,
  letterSpacing: 2.4,
  color: kTextColorWhite,
);

/// Titre Default
TextStyle ktitle2 = GoogleFonts.roboto(
  fontWeight: FontWeight.bold,
  fontSize: 16,
  letterSpacing: 1.2,
  color: kTextColorWhite,
);

/// Text Default
TextStyle kbodyLarge = GoogleFonts.roboto(
  fontSize: 16,
  letterSpacing: 1.6,
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
