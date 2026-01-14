import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    fontFamily: 'Inter',
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      secondary: AppColors.primary,
      onSecondary: AppColors.primaryForeground,
      background: AppColors.backgroundLight,
      onBackground: AppColors.foregroundLight,
      surface: AppColors.cardLight,
      onSurface: AppColors.foregroundLight,
      error: Colors.red,
      onError: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: BorderSide(color: AppColors.inputLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: BorderSide(color: AppColors.inputLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      hintStyle: TextStyle(color: AppColors.mutedForegroundLight),
      labelStyle: TextStyle(color: AppColors.mutedForegroundLight),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: AppColors.foregroundLight),
      bodyLarge: TextStyle(color: AppColors.foregroundLight, fontFamily: 'Inter'),
      bodyMedium: TextStyle(color: AppColors.mutedForegroundLight, fontFamily: 'Inter'),
      labelLarge: TextStyle(color: AppColors.mutedForegroundLight, fontFamily: 'Inter'),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.foregroundLight,
        side: BorderSide(color: AppColors.inputLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    ),
    cardColor: AppColors.cardLight,
    cardTheme: CardTheme(
      color: AppColors.cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
      ),
    ),
    dividerColor: AppColors.inputLight,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.foregroundLight,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.foregroundLight),
      titleTextStyle: const TextStyle(color: AppColors.foregroundLight, fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 20),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    fontFamily: 'Inter',
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      secondary: AppColors.primary,
      onSecondary: AppColors.primaryForeground,
      background: AppColors.backgroundDark,
      onBackground: AppColors.foregroundDark,
      surface: AppColors.cardDark,
      onSurface: AppColors.foregroundDark,
      error: Colors.red,
      onError: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: BorderSide(color: AppColors.inputDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: BorderSide(color: AppColors.inputDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      hintStyle: TextStyle(color: AppColors.mutedForegroundDark),
      labelStyle: TextStyle(color: AppColors.mutedForegroundDark),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: AppColors.foregroundDark),
      bodyLarge: TextStyle(color: AppColors.foregroundDark, fontFamily: 'Inter'),
      bodyMedium: TextStyle(color: AppColors.mutedForegroundDark, fontFamily: 'Inter'),
      labelLarge: TextStyle(color: AppColors.mutedForegroundDark, fontFamily: 'Inter'),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.foregroundDark,
        side: BorderSide(color: AppColors.inputDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    ),
    cardColor: AppColors.cardDark,
    cardTheme: CardTheme(
      color: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
      ),
    ),
    dividerColor: AppColors.inputDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.foregroundDark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.foregroundDark),
      titleTextStyle: const TextStyle(color: AppColors.foregroundDark, fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 20),
    ),
  );
}
