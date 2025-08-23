import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';

class AppTextTheme {
  // Base styles
  static final TextStyle _baseLight = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    color: AppColors.BLACK_TEXT_COLOR, // #121212 for light mode
  );

  static final TextStyle _baseDark = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    color: AppColors.WHITE_COLOR, // #FFFFFF for dark mode
  );

  static final TextStyle _baseButton = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: AppColors.BUTTON_TEXT_COLOR, // #2B2B2B for button text readability
  );

  // LIGHT THEME
  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: _baseLight.copyWith(fontSize: 64, fontWeight: FontWeight.w700),
    displayMedium: _baseLight.copyWith(fontSize: 48, fontWeight: FontWeight.w700),
    displaySmall: _baseLight.copyWith(fontSize: 36, fontWeight: FontWeight.w700),
    headlineLarge: _baseLight.copyWith(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: _baseLight.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: _baseLight.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: _baseLight.copyWith(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: _baseLight.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
    titleSmall: _baseLight.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
    labelLarge: _baseButton.copyWith(fontSize: 16), // Button text
    labelMedium: _baseLight.copyWith(fontSize: 14, color: AppColors.GREY_TEXT_COLOR),
    labelSmall: _baseLight.copyWith(fontSize: 12, color: AppColors.GREY_TEXT_COLOR),
    bodyLarge: _baseLight.copyWith(fontSize: 16),
    bodyMedium: _baseLight.copyWith(fontSize: 14),
    bodySmall: _baseLight.copyWith(fontSize: 12),
  );

  // DARK THEME
  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: _baseDark.copyWith(fontSize: 64, fontWeight: FontWeight.w700),
    displayMedium: _baseDark.copyWith(fontSize: 48, fontWeight: FontWeight.w700),
    displaySmall: _baseDark.copyWith(fontSize: 36, fontWeight: FontWeight.w700),
    headlineLarge: _baseDark.copyWith(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: _baseDark.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: _baseDark.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: _baseDark.copyWith(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: _baseDark.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
    titleSmall: _baseDark.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
    labelLarge: _baseButton.copyWith(fontSize: 16), // Button text
    labelMedium: _baseDark.copyWith(fontSize: 14, color: AppColors.GREY_TEXT_COLOR), // Secondary text
    labelSmall: _baseDark.copyWith(fontSize: 12, color: AppColors.GREY_TEXT_COLOR),
    bodyLarge: _baseDark.copyWith(fontSize: 16),
    bodyMedium: _baseDark.copyWith(fontSize: 14),
    bodySmall: _baseDark.copyWith(fontSize: 12),
  );
}