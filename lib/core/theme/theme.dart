import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/theme/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      dividerColor: AppColors.divider,
      hintColor: AppColors.textSecondary,
      focusColor: AppColors.textSecondary,

      appBarTheme: AppBarTheme(backgroundColor: AppColors.background),

      // Text
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
        titleLarge: TextStyle(color: AppColors.textPrimary),
      ),

      cardTheme: CardThemeData(color: AppColors.surface),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pointColor,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(backgroundColor: AppColors.primary),

      // TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightColor),
        ),
        hintStyle: TextStyle(color: AppColors.textSecondary),
      ),

      // BottomNavigationBarTheme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.pointColor,
        unselectedItemColor: AppColors.lightContainColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      dividerColor: AppColors.divider,
      hintColor: AppColors.textSecondary,
      focusColor: AppColors.textSecondary,

      appBarTheme: AppBarTheme(backgroundColor: AppColors.background),

      // Text
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
        titleLarge: TextStyle(color: AppColors.textPrimary),
      ),

      cardTheme: CardThemeData(color: AppColors.surface),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pointColor,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(backgroundColor: AppColors.primary),

      // TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightColor),
        ),
        hintStyle: TextStyle(color: AppColors.textSecondary),
      ),

      // BottomNavigationBarTheme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.pointColor,
        unselectedItemColor: AppColors.lightContainColor,
      ),
    );
  }
}
