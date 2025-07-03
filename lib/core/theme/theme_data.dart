import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: ColorConstants.darkBackgroundColor,
  primaryColor: ColorConstants.darkPrimaryColor,
  appBarTheme: AppBarTheme(
    backgroundColor: ColorConstants.darkAppBarColor,
    foregroundColor: ColorConstants.darkTextColor,
  ),
  colorScheme: ColorScheme.dark(
    primary: ColorConstants.darkPrimaryColor,
    secondary: ColorConstants.darkAccentColor,
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.lato(
      color: ColorConstants.darkTextColor,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: GoogleFonts.lato(
      color: ColorConstants.darkTextColor,
      fontSize: 16,
    ),
    bodySmall: GoogleFonts.lato(
      color: ColorConstants.darkTextColor,
      fontSize: 14,
    ),
  ),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: ColorConstants.lightBackgroundColor,
  primaryColor: ColorConstants.lightPrimaryColor,
  appBarTheme: AppBarTheme(
    backgroundColor: ColorConstants.lightAppBarColor,
    foregroundColor: ColorConstants.lightTextColor,
  ),
  colorScheme: ColorScheme.light(
    primary: ColorConstants.lightPrimaryColor,
    secondary: ColorConstants.lightAccentColor,
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.lato(
      color: ColorConstants.lightTextColor,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: GoogleFonts.lato(
      color: ColorConstants.lightTextColor,
      fontSize: 16,
    ),
    bodySmall: GoogleFonts.lato(
      color: ColorConstants.lightTextColor,
      fontSize: 14,
    ),
    //  TextStyle(color: ColorConstants.lightTextColor),
  ),
);
