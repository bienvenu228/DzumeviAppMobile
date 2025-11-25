import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppConstants.primary,
    scaffoldBackgroundColor: AppConstants.background,
    colorScheme: ColorScheme.light(
      primary: AppConstants.primary,
      secondary: AppConstants.secondary,
      error: AppConstants.error,
      surface: AppConstants.surface,
      background: AppConstants.background,
    ),

    // Police principale (très belle et lisible en Afrique de l'Ouest)

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppConstants.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),

    // ElevatedButton global
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppConstants.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppConstants.error, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.black87),
    ),

    // Card
    cardTheme: CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),

    // Text selection
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppConstants.primary,
      selectionColor: AppConstants.secondary,
      selectionHandleColor: AppConstants.primary,
    ),

    // FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppConstants.secondary,
      foregroundColor: Colors.black,
    ),

    // Divider
    dividerColor: Colors.grey[300],
  );
}

// Extension pour utiliser facilement les couleurs
extension ThemeColors on BuildContext {
  Color get primary => Theme.of(this).primaryColor;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get tMoney => AppConstants.tMoneyColor;
  Color get flooz => AppConstants.floozColor;
}