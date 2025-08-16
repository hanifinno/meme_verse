import 'app_colors.dart';
import 'package:flutter/material.dart';

class AppColorScheme {
  //* LIGHT COLOR SCHEME
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.PRIMARY_COLOR,
    onPrimary: AppColors.WHITE_COLOR,
    secondary: AppColors.TRANSPARENT,
    onSecondary: AppColors.BLACK_COLOR,
    error: AppColors.RED_COLOR,
    onError: AppColors.WHITE_COLOR,
    surface: AppColors.SCAFFOLD_BG_COLOR,
    onSurface: AppColors.BLACK_COLOR,
    // background: AppColors.SCAFFOLD_BG_COLOR,
    // onBackground: AppColors.BLACK_COLOR,
    outline: AppColors.BORDER_COLOR,
    outlineVariant: AppColors.GRAY_WHITE_COLOR,

    // Optional but recommended for Material 3
    surfaceContainerLowest: AppColors.WHITE_COLOR,
    surfaceContainerLow: AppColors.WHITE_COLOR,
    surfaceContainer: AppColors.WHITE_COLOR,
    surfaceContainerHigh: AppColors.GRAY_WHITE_COLOR,
    surfaceContainerHighest: AppColors.GRAY_WHITE_COLOR,

    // Neutral
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
    primary: AppColors.PRIMARY_COLOR,
    onPrimary: AppColors.WHITE_COLOR,
    secondary: AppColors.TRANSPARENT,
    onSecondary: AppColors.WHITE_COLOR,
    error: AppColors.RED_COLOR,
    onError: AppColors.WHITE_COLOR,
    surface: AppColors.BLACK_COLOR,
    onSurface: AppColors.WHITE_COLOR,
    // background: AppColors.BLACK_COLOR,
    // onBackground: AppColors.WHITE_COLOR,
    outline: AppColors.BORDER_COLOR,
    outlineVariant: AppColors.GRAY_WHITE_COLOR,

    // Optional but recommended for Material 3
    surfaceContainerLowest: Colors.black,
    surfaceContainerLow: Colors.black,
    surfaceContainer: Colors.black,
    surfaceContainerHigh: AppColors.GRAY_WHITE_COLOR,
    surfaceContainerHighest: AppColors.GRAY_WHITE_COLOR,

    // Neutral
    inverseSurface: AppColors.WHITE_COLOR,
    onInverseSurface: AppColors.BLACK_COLOR,
    inversePrimary: AppColors.PRIMARY_COLOR,
    shadow: Colors.black,
    scrim: Colors.black,
    surfaceTint: AppColors.PRIMARY_COLOR,
  );
}
