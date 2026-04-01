import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import '../constants/app_colors.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final repo = ref.watch(isAuthenticatedProvider);

  // if (repo) {
  //   final profileRepo = ref.read(authUserProvider).value;
  //   return themeModeFromDb(profileRepo?.appMetadata['theme_mode'] as String?);
  // }

  return ThemeMode.dark;
});

final themeModeTogglerProvider = Provider<AppTheme>((ref) => AppTheme());

// class AppTheme {
//   static ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: AppColors.primary,
//     scaffoldBackgroundColor: AppColors.backgroundLight,
//     fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
//     colorScheme: const ColorScheme(
//       brightness: Brightness.light,
//       primary: AppColors.primary,
//       onPrimary: AppColors.primaryForeground,
//       secondary: AppColors.accent,
//       onSecondary: AppColors.accentForeground,
//       tertiary: AppColors.tertiary,
//       onTertiary: AppColors.tertiaryForeground,
//       surface: AppColors.cardLight,
//       onSurface: AppColors.foregroundLight,
//       error: Colors.red,
//       onError: Colors.white,
//     ),
//     dividerColor: AppColors.borderLight,
//     dividerTheme:
//         const DividerThemeData(color: AppColors.borderLight, thickness: 1),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: AppColors.inputLight,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         borderSide: const BorderSide(color: AppColors.borderLight),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         borderSide: const BorderSide(color: AppColors.borderLight),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         borderSide: const BorderSide(color: AppColors.primary),
//       ),
//       hintStyle: const TextStyle(color: AppColors.mutedForegroundLight),
//       labelStyle: const TextStyle(color: AppColors.mutedForegroundLight),
//     ),
//     textTheme: GoogleFonts.spaceGroteskTextTheme(
//       const TextTheme(
//         displayLarge: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: AppColors.foregroundLight),
//         bodyLarge: TextStyle(color: AppColors.foregroundLight),
//         bodyMedium: TextStyle(color: AppColors.mutedForegroundLight),
//         labelLarge: TextStyle(color: AppColors.mutedForegroundLight),
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         foregroundColor: AppColors.primaryForeground,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         ),
//         textStyle:
//             const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
//       ),
//     ),
//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         foregroundColor: AppColors.foregroundLight,
//         side: const BorderSide(color: AppColors.borderLight),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         ),
//         textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//     ),
//     cardColor: AppColors.cardLight,
//     cardTheme: CardTheme(
//       color: AppColors.cardLight,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//       ),
//       elevation: 0,
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: AppColors.backgroundLight,
//       foregroundColor: AppColors.foregroundLight,
//       elevation: 0,
//       iconTheme: const IconThemeData(color: AppColors.foregroundLight),
//       titleTextStyle: GoogleFonts.spaceGrotesk(
//           color: AppColors.foregroundLight,
//           fontWeight: FontWeight.w600,
//           fontSize: 20),
//     ),
//   );

//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: AppColors.primary,
//     scaffoldBackgroundColor: AppColors.backgroundDark,
//     fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
//     colorScheme: const ColorScheme(
//       brightness: Brightness.dark,
//       primary: AppColors.primary,
//       onPrimary: AppColors.primaryForeground,
//       secondary: AppColors.accent,
//       onSecondary: AppColors.accentForeground,
//       surface: AppColors.cardDark,
//       onSurface: AppColors.foregroundDark,
//       error: Colors.red,
//       onError: Colors.white,
//       tertiary: AppColors.tertiary,
//       onTertiary: AppColors.tertiaryForeground,
//     ),
//     dividerColor: AppColors.borderDark,
//     dividerTheme:
//         const DividerThemeData(color: AppColors.borderDark, thickness: 1),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: AppColors.inputDark,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         borderSide: const BorderSide(color: AppColors.borderDark),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         borderSide: const BorderSide(color: AppColors.borderDark),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         borderSide: const BorderSide(color: AppColors.primary),
//       ),
//     ),
//     textTheme: GoogleFonts.spaceGroteskTextTheme(
//       const TextTheme(
//         displayLarge: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: AppColors.foregroundDark),
//         bodyLarge: TextStyle(color: AppColors.foregroundDark),
//         bodyMedium: TextStyle(color: AppColors.mutedForegroundDark),
//         labelLarge: TextStyle(color: AppColors.mutedForegroundDark),
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         foregroundColor: AppColors.primaryForeground,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         ),
//         textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//     ),
//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         foregroundColor: AppColors.foregroundDark,
//         side: const BorderSide(color: AppColors.borderDark),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//         ),
//         textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//     ),
//     cardColor: AppColors.cardDark,
//     cardTheme: CardTheme(
//       color: AppColors.cardDark,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppColors.borderRadiusLg),
//       ),
//       elevation: 0,
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: AppColors.backgroundDark,
//       foregroundColor: AppColors.foregroundDark,
//       elevation: 0,
//       iconTheme: const IconThemeData(color: AppColors.foregroundDark),
//       titleTextStyle: GoogleFonts.spaceGrotesk(
//           color: AppColors.foregroundDark,
//           fontWeight: FontWeight.w600,
//           fontSize: 20),
//     ),
//   );

// void toggleThemeMode(WidgetRef ref) async {
//   final current = ref.read(themeModeProvider);
//   final next = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

//   ref.read(themeModeProvider.notifier).state = next;

//   final repo = ref.read(profileRepositoryProvider);
//   await repo.updateMyThemeMode(themeModeToDb(next));
// }
// }

// String themeModeToDb(ThemeMode mode) => switch (mode) {
//       ThemeMode.dark => 'dark',
//       ThemeMode.light => 'light',
//       ThemeMode.system => 'system',
//     };

// ThemeMode themeModeFromDb(String? v) => switch (v) {
//       'dark' => ThemeMode.dark,
//       'system' => ThemeMode.system,
//       _ => ThemeMode.light,
//     };

class AppTheme {
  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.surfaceBright,
      onSecondary: AppColors.onSurface,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.tertiary,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerLowest: AppColors.surface,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      surfaceBright: AppColors.surfaceBright,
      surfaceDim: AppColors.surfaceContainerLow,
      surfaceVariant: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.onSurfaceMuted,
      outline: Colors.transparent,
      outlineVariant: AppColors.outlineVariant,
      shadow: AppColors.shadow,
      scrim: Colors.black87,
      inverseSurface: AppColors.onSurface,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.primaryContainer,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      canvasColor: AppColors.surface,
      splashFactory: InkRipple.splashFactory,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      inputDecorationTheme: _inputTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      chipTheme: _chipTheme(base.chipTheme, colorScheme),
      dividerTheme: const DividerThemeData(
        color: Colors.transparent,
        thickness: 0,
        space: 0,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusXl),
        ),
      ),
    );
  }

  void toggleThemeMode(WidgetRef ref) async {
    // final current = ref.read(themeModeProvider);
    // final next = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    // ref.read(themeModeProvider.notifier).state = next;

    // final repo = ref.read(profileRepositoryProvider);
    // await repo.updateMyThemeMode(themeModeToDb(next));
  }

  static TextTheme _textTheme(TextTheme base, ColorScheme scheme) {
    final inter = GoogleFonts.interTextTheme(base);
    return inter.copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 1.0,
        color: scheme.onSurface,
      ),
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.1,
        color: scheme.onSurface,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: scheme.onSurface,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: scheme.onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: scheme.onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: scheme.onSurfaceVariant,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: scheme.onSurfaceVariant,
      ),
    );
  }

  static AppBarTheme _appBarTheme(ColorScheme scheme) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
    );
  }

  static CardTheme _cardTheme(ColorScheme scheme) {
    return CardTheme(
      color: scheme.surfaceContainer,
      elevation: 0,
      shadowColor: scheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusXl),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static InputDecorationTheme _inputTheme(ColorScheme scheme) {
    const transparent = BorderSide(color: Colors.transparent, width: 0);

    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: const UnderlineInputBorder(
        borderSide: transparent,
        borderRadius: BorderRadius.all(Radius.circular(AppColors.radiusLg)),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: transparent,
        borderRadius: BorderRadius.all(Radius.circular(AppColors.radiusLg)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryContainer, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(AppColors.radiusLg)),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme scheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusXl),
        ),
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme scheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.surfaceContainerHighest,
        foregroundColor: scheme.onSurface,
        side: const BorderSide(color: Colors.transparent),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(ColorScheme scheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ChipThemeData _chipTheme(ChipThemeData base, ColorScheme scheme) {
    return base.copyWith(
      backgroundColor: scheme.surfaceContainerHigh,
      selectedColor: scheme.tertiaryContainer,
      secondaryLabelStyle: TextStyle(color: scheme.onSurface),
      labelStyle: TextStyle(color: scheme.onSurface),
      side: const BorderSide(color: Colors.transparent),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
