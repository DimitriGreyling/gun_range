import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);//TODO: change to system by defaukt 

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      secondary: AppColors.accent,
      onSecondary: AppColors.accentForeground,
      background: AppColors.backgroundLight,
      onBackground: AppColors.foregroundLight,
      surface: AppColors.cardLight,
      onSurface: AppColors.foregroundLight,
      error: Colors.red,
      onError: Colors.white,
    ),
    dividerColor: AppColors.borderLight,
    dividerTheme:
        const DividerThemeData(color: AppColors.borderLight, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      hintStyle: TextStyle(color: AppColors.mutedForegroundLight),
      labelStyle: TextStyle(color: AppColors.mutedForegroundLight),
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.foregroundLight),
        bodyLarge: TextStyle(color: AppColors.foregroundLight),
        bodyMedium: TextStyle(color: AppColors.mutedForegroundLight),
        labelLarge: TextStyle(color: AppColors.mutedForegroundLight),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.foregroundLight,
        side: const BorderSide(color: AppColors.borderLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    cardColor: AppColors.cardLight,
    cardTheme: CardTheme(
      color: AppColors.cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
      ),
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.foregroundLight,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.foregroundLight),
      titleTextStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.foregroundLight,
          fontWeight: FontWeight.w600,
          fontSize: 20),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      secondary: AppColors.accent,
      onSecondary: AppColors.accentForeground,
      background: AppColors.backgroundDark,
      onBackground: AppColors.foregroundDark,
      surface: AppColors.cardDark,
      onSurface: AppColors.foregroundDark,
      error: Colors.red,
      onError: Colors.white,
    ),
    dividerColor: AppColors.borderDark,
    dividerTheme:
        const DividerThemeData(color: AppColors.borderDark, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      hintStyle: TextStyle(color: AppColors.mutedForegroundDark),
      labelStyle: TextStyle(color: AppColors.mutedForegroundDark),
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.foregroundDark),
        bodyLarge: TextStyle(color: AppColors.foregroundDark),
        bodyMedium: TextStyle(color: AppColors.mutedForegroundDark),
        labelLarge: TextStyle(color: AppColors.mutedForegroundDark),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.foregroundDark,
        side: const BorderSide(color: AppColors.borderDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    cardColor: AppColors.cardDark,
    cardTheme: CardTheme(
      color: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
      ),
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.foregroundDark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.foregroundDark),
      titleTextStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.foregroundDark,
          fontWeight: FontWeight.w600,
          fontSize: 20),
    ),
  );
}
