import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../color/app_colors.dart';

class AppTextTheme {
  // Base styles
  static final TextStyle _baseLight = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: AppColors.BLACK_TEXT_COLOR,
  );

  static final TextStyle _baseDark = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: AppColors.WHITE_COLOR,
  );

  // LIGHT THEME
  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: _baseLight.copyWith(fontSize: 64),
    displayMedium: _baseLight.copyWith(fontSize: 48),
    displaySmall: _baseLight.copyWith(fontSize: 36),
    headlineLarge: _baseLight.copyWith(fontSize: 32),
    headlineMedium: _baseLight.copyWith(fontSize: 28),
    headlineSmall: _baseLight.copyWith(fontSize: 24),
    titleLarge: _baseLight.copyWith(fontSize: 22),
    titleMedium: _baseLight.copyWith(fontSize: 20),
    titleSmall: _baseLight.copyWith(fontSize: 18),
    labelLarge: _baseLight.copyWith(fontSize: 16),
    labelMedium: _baseLight.copyWith(fontSize: 14),
    labelSmall: _baseLight.copyWith(fontSize: 12),
    bodyLarge: _baseLight.copyWith(fontSize: 14),
    bodyMedium: _baseLight.copyWith(fontSize: 12),
    bodySmall: _baseLight.copyWith(fontSize: 10),
  );

  // DARK THEME
  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: _baseDark.copyWith(fontSize: 64),
    displayMedium: _baseDark.copyWith(fontSize: 48),
    displaySmall: _baseDark.copyWith(fontSize: 36),
    headlineLarge: _baseDark.copyWith(fontSize: 32),
    headlineMedium: _baseDark.copyWith(fontSize: 28),
    headlineSmall: _baseDark.copyWith(fontSize: 24),
    titleLarge: _baseDark.copyWith(fontSize: 22),
    titleMedium: _baseDark.copyWith(fontSize: 20),
    titleSmall: _baseDark.copyWith(fontSize: 18),
    labelLarge: _baseDark.copyWith(fontSize: 16),
    labelMedium: _baseDark.copyWith(fontSize: 14),
    labelSmall: _baseDark.copyWith(fontSize: 12),
    bodyLarge: _baseDark.copyWith(fontSize: 14),
    bodyMedium: _baseDark.copyWith(fontSize: 12),
    bodySmall: _baseDark.copyWith(fontSize: 10),
  );
}
