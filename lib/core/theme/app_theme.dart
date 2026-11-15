import 'package:flutter/material.dart';

class AppColors {
  static const Color sky = Color(0xFF69C9FF);
  static const Color purple = Color(0xFFA98BFF);
  static const Color yellow = Color(0xFFFFD85E);
  static const Color pink = Color(0xFFFF91B5);
  static const Color mint = Color(0xFF75DDB4);
  static const Color orange = Color(0xFFFFAA65);
  static const Color cream = Color(0xFFFFF9ED);
  static const Color ink = Color(0xFF3B2A63);
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.purple,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.cream,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.yellow,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
