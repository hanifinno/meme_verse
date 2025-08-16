import 'package:flutter/material.dart';

class AppColors {
  static const Color SCAFFOLD_BG_COLOR = Color(0xffF8FAFC);

  static const Color PRIMARY_COLOR = Color(0xff192D6B);
  static const LinearGradient PRIMARY_GRADIENT = LinearGradient(
    colors: [
      Color(0xffFFA500), // Yellowish-orange (start)
      Color(0xffFF4500), // Orange-red (middle)
      Color(0xffDC143C), // Red (end)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  static const Color BLACK_COLOR = Color(0xff2b2b2b);
  static const Color WHITE_COLOR = Color(0xffFFFFFF);
  static const Color GREEN_COLOR = Color(0xff16833e);
  static const Color RED_COLOR = Color(0xffdb2424);
  static const Color ORANGE_COLOR = Color(0xffFF4500);
  static const Color Sky_BLUE_COLOR = Color(0xff0da2e7);
  static const GREY_COLOR = Color(0xffE2E8F0);
  static const Color GRAY_WHITE_COLOR = Color(0xFFF3F2F7);
  static const Color TRANSPARENT = Colors.transparent;

  // INPUT FIELD COLORS
  static const Color CURSOR_COLOR = PRIMARY_COLOR;
  static const Color LABEL_TEXT_COLOR = BLACK_TEXT_COLOR;
  static const Color HINT_TEXT_COLOR = GREY_TEXT_COLOR;
  static const Color BORDER_COLOR = Color(0xFF64748B);
  static const Color ENABLED_BORDER_COLOR = BORDER_COLOR;
  static const Color FOCUSED_BORDER_COLOR = PRIMARY_COLOR;
  static const Color ERROR_BORDER_COLOR = Color(0xfff72832);
  static const Color FOCUSED_ERROR_BORDER_COLOR = Color(0xffb5020b);

  // TEXT COLORS
  static const Color BLACK_TEXT_COLOR = BLACK_COLOR;
  static const Color GREY_TEXT_COLOR = Color(0xFF6B7280);
  static const Color WHITE_TEXT_COLOR = Color(0xFF6B7280);

  // SNACKBAR COLORS
  static const Color SUCCESS_COLOR = Color(0xFF008000);
  static const Color ERROR_COLOR = Color(0xFFB00020);
  static const Color WARNING_COLOR = Color(0xFFFFCC00);
  // BACKGROUND COLORS
  static const Color BACKGROUND_COLOR = Color(0xFFF9FAFC);
  static const Color COLOR_TRANSPARENT = Colors.transparent;
}
