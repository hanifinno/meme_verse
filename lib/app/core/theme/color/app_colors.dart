// import 'package:flutter/material.dart';

// class AppColors {
//   static const Color SCAFFOLD_BG_COLOR = Color(0xffF8FAFC);

//   static const Color PRIMARY_COLOR = Color(0xff192D6B);
//   static const LinearGradient PRIMARY_GRADIENT = LinearGradient(
//     colors: [
//       Color(0xffFFA500), // Yellowish-orange (start)
//       Color(0xffFF4500), // Orange-red (middle)
//       Color(0xffDC143C), // Red (end)
//     ],
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     stops: [0.0, 0.5, 1.0],
//   );

//   static const Color BLACK_COLOR = Color(0xff2b2b2b);
//   static const Color WHITE_COLOR = Color(0xffFFFFFF);
//   static const Color GREEN_COLOR = Color(0xff16833e);
//   static const Color RED_COLOR = Color(0xffdb2424);
//   static const Color ORANGE_COLOR = Color(0xffFF4500);
//   static const Color Sky_BLUE_COLOR = Color(0xff0da2e7);
//   static const GREY_COLOR = Color(0xffE2E8F0);
//   static const Color GRAY_WHITE_COLOR = Color(0xFFF3F2F7);
//   static const Color TRANSPARENT = Colors.transparent;

//   // INPUT FIELD COLORS
//   static const Color CURSOR_COLOR = PRIMARY_COLOR;
//   static const Color LABEL_TEXT_COLOR = BLACK_TEXT_COLOR;
//   static const Color HINT_TEXT_COLOR = GREY_TEXT_COLOR;
//   static const Color BORDER_COLOR = Color(0xFF64748B);
//   static const Color ENABLED_BORDER_COLOR = BORDER_COLOR;
//   static const Color FOCUSED_BORDER_COLOR = PRIMARY_COLOR;
//   static const Color ERROR_BORDER_COLOR = Color(0xfff72832);
//   static const Color FOCUSED_ERROR_BORDER_COLOR = Color(0xffb5020b);

//   // TEXT COLORS
//   static const Color BLACK_TEXT_COLOR = BLACK_COLOR;
//   static const Color GREY_TEXT_COLOR = Color(0xFF6B7280);
//   static const Color WHITE_TEXT_COLOR = Color(0xFF6B7280);

//   // SNACKBAR COLORS
//   static const Color SUCCESS_COLOR = Color(0xFF008000);
//   static const Color ERROR_COLOR = Color(0xFFB00020);
//   static const Color WARNING_COLOR = Color(0xFFFFCC00);
//   // BACKGROUND COLORS
//   static const Color BACKGROUND_COLOR = Color(0xFFF9FAFC);
//   static const Color COLOR_TRANSPARENT = Colors.transparent;
// }


import 'package:flutter/material.dart';

class AppColors {
  // Core Colors (Neon Dark Theme)
  static const Color SCAFFOLD_BG_COLOR = Color(0xFF121212); // Dark background for dark mode
  static const Color PRIMARY_COLOR = Color(0xFF00FFAA); // Neon Green for primary actions
  static const Color SECONDARY_COLOR = Color(0xFFFF2D55); // Neon Pink for accents
  static const LinearGradient PRIMARY_GRADIENT = LinearGradient(
    colors: [
      Color(0xFF00FFAA), // Neon Green (start)
      Color(0xFFFF2D55), // Neon Pink (end)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
  static const Color BLACK_COLOR = Color(0xFF121212); // Dark background
  static const Color WHITE_COLOR = Color(0xFFFFFFFF); // Primary text
  static const Color GRAY_WHITE_COLOR = Color(0xFF1E1E1E); // Surface for cards/sheets
  static const Color BORDER_COLOR = Color(0xFFB0B0B0); // Light gray for outlines
  static const Color TRANSPARENT = Colors.transparent;

  // Additional Colors from Original
  static const Color GREEN_COLOR = Color(0xFF16833E); // For success states
  static const Color RED_COLOR = Color(0xFFDB2424); // For errors
  static const Color ORANGE_COLOR = Color(0xFFFF4500); // For warnings
  static const Color SKY_BLUE_COLOR = Color(0xFF0DA2E7); // For secondary accents if needed
  static const Color GREY_COLOR = Color(0xFFE2E8F0); // For light mode surfaces
  static const Color BACKGROUND_COLOR = Color(0xFF121212); // Dark mode background

  // Input Field Colors
  static const Color CURSOR_COLOR = PRIMARY_COLOR;
  static const Color LABEL_TEXT_COLOR = WHITE_COLOR;
  static const Color HINT_TEXT_COLOR = Color(0xFFB0B0B0); // Updated for dark mode
  static const Color ENABLED_BORDER_COLOR = BORDER_COLOR;
  static const Color FOCUSED_BORDER_COLOR = PRIMARY_COLOR;
  static const Color ERROR_BORDER_COLOR = RED_COLOR;
  static const Color FOCUSED_ERROR_BORDER_COLOR = Color(0xFFB5020B);

  // Text Colors
  static const Color BLACK_TEXT_COLOR = BLACK_COLOR;
  static const Color BUTTON_TEXT_COLOR = Color(0xFF2B2B2B); // New dark gray for button text
  static const Color GREY_TEXT_COLOR = Color(0xFFB0B0B0); // Secondary text
  static const Color WHITE_TEXT_COLOR = WHITE_COLOR;

  // Snackbar Colors
  static const Color SUCCESS_COLOR = GREEN_COLOR;
  static const Color ERROR_COLOR = RED_COLOR;
  static const Color WARNING_COLOR = ORANGE_COLOR;
}

class AppColorScheme {
  //* LIGHT COLOR SCHEME
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.PRIMARY_COLOR, // Neon Green
    onPrimary: AppColors.WHITE_COLOR,
    secondary: AppColors.SECONDARY_COLOR, // Neon Pink
    onSecondary: AppColors.WHITE_COLOR,
    error: AppColors.RED_COLOR,
    onError: AppColors.WHITE_COLOR,
    surface: AppColors.GREY_COLOR, // Light surface for light mode
    onSurface: AppColors.BLACK_COLOR,
    outline: AppColors.BORDER_COLOR,
    outlineVariant: AppColors.BORDER_COLOR,
    surfaceContainerLowest: AppColors.WHITE_COLOR,
    surfaceContainerLow: AppColors.WHITE_COLOR,
    surfaceContainer: AppColors.WHITE_COLOR,
    surfaceContainerHigh: AppColors.GRAY_WHITE_COLOR,
    surfaceContainerHighest: AppColors.GRAY_WHITE_COLOR,
    inverseSurface: AppColors.BLACK_COLOR,
    onInverseSurface: AppColors.WHITE_COLOR,
    inversePrimary: AppColors.PRIMARY_COLOR,
    shadow: Colors.black,
    scrim: Colors.black,
    surfaceTint: AppColors.PRIMARY_COLOR,
  );

  //* DARK COLOR SCHEME
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.PRIMARY_COLOR, // Neon Green
    onPrimary: AppColors.WHITE_COLOR,
    secondary: AppColors.SECONDARY_COLOR, // Neon Pink
    onSecondary: AppColors.WHITE_COLOR,
    error: AppColors.RED_COLOR,
    onError: AppColors.WHITE_COLOR,
    surface: AppColors.BLACK_COLOR, // Dark background
    onSurface: AppColors.WHITE_COLOR,
    outline: AppColors.BORDER_COLOR,
    outlineVariant: AppColors.BORDER_COLOR,
    surfaceContainerLowest: AppColors.BLACK_COLOR,
    surfaceContainerLow: AppColors.BLACK_COLOR,
    surfaceContainer: AppColors.GRAY_WHITE_COLOR, // Surface for cards
    surfaceContainerHigh: AppColors.GRAY_WHITE_COLOR,
    surfaceContainerHighest: AppColors.GRAY_WHITE_COLOR,
    inverseSurface: AppColors.WHITE_COLOR,
    onInverseSurface: AppColors.BLACK_COLOR,
    inversePrimary: AppColors.PRIMARY_COLOR,
    shadow: Colors.black,
    scrim: Colors.black,
    surfaceTint: AppColors.PRIMARY_COLOR,
  );
}