import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const night = Color(0xFF120826);
  static const surface = Color(0xFF241548);
  static const pink = Color.fromARGB(255, 49, 53, 255);
  static const orange = Color(0xFFFF9F1C);
  static const lime = Color(0xFFB8FF3D);
  static const muted = Color(0xFFB7A8E0);
}

ThemeData buildAppTheme() {
  final rounded = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  ///Trecho enjoado de fazer deu pane demais

  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.pink,
      brightness: Brightness.dark,
      primary: AppColors.pink,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.night,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.night),
    cardTheme: CardThemeData(color: AppColors.surface, shape: rounded),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        shape: rounded,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.orange,
      foregroundColor: AppColors.night,
    ),
  );
}
