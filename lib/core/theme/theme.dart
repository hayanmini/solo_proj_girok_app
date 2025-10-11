import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/theme/colors.dart';

class AppTheme {
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
        bodyLarge: TextStyle(color: AppColors.whiteTextColor),
        bodyMedium: TextStyle(color: AppColors.whiteTextColor),
        titleLarge: TextStyle(color: AppColors.whiteTextColor),
      ),

      cardTheme: CardThemeData(color: AppColors.surface),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pointColor,
          foregroundColor: AppColors.whiteTextColor,
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
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide(color: AppColors.pointColor),
        ),
        hintStyle: TextStyle(color: AppColors.textSecondary),
      ),

      // BottomNavigationBarTheme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.level1Color,
        unselectedItemColor: AppColors.level5Color,
      ),
    );
  }
}
