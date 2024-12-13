import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryColor = Color(0xFF0A1D29);

const Color kSecondaryColor = Color(0xFF58b4f6);

const Color kShadowColor = Colors.grey;

const Color kTextColor = Color(0xFF4ee0ff);
const Color kTextColorWhite = Colors.white;
const Color kHoverTextColor = Color(0xFF37f3ff);

const Color kButtonColor = Color(0xFF54adf7);
const Color kHoverButtonColor = Color(0xFF9ed0fa);

const Color kTextShadow = Color(0xFF00e7ff);

const Color kBodyTextColor = Color(0xFFd8dde0);

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

final ThemeData kThemeData = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimaryColor,
    titleTextStyle: kheadlineLarge,
  ),
  scaffoldBackgroundColor: kPrimaryColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    primary: kPrimaryColor,
    primaryContainer: kButtonColor,
    secondary: kSecondaryColor,
    onSecondary: kHoverButtonColor,
    shadow: kShadowColor,
    tertiary: kBodyTextColor,
    outline: kTextShadow,
  ),
  textTheme: TextTheme(
    headlineLarge: kheadlineLarge,
    headlineMedium: kheadlineMedium,
    titleLarge: ktitle1,
    titleMedium: ktitle2,
    bodyLarge: kbodyLarge,
  ),
  textButtonTheme: TextButtonThemeData(
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
  ),
  cardTheme: CardTheme(color: kPrimaryColor.withOpacity(.5)),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.red,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    titleTextStyle: ktitle1.copyWith(color: kPrimaryColor),
    contentTextStyle: ktitle2,
    insetPadding: const EdgeInsets.all(16),
  ),
  useMaterial3: true,
);
