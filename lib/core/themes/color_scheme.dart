import 'package:flutter/material.dart';

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

ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: kPrimaryColor,
  primary: kPrimaryColor,
  primaryContainer: kButtonColor,
  secondary: kSecondaryColor,
  onSecondary: kHoverButtonColor,
  shadow: kShadowColor,
  tertiary: kBodyTextColor,
  outline: kTextShadow,
);
