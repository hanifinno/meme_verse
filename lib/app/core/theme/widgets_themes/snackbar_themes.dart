import '../../constants/app_deimensions.dart';
import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class SnackBarThemes {
  static SnackBarThemeData _buildSnackBarTheme(ColorScheme scheme) {
    return SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: TextStyle(
        color: scheme.onInverseSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: BODY_LARGE,
      ),
      actionTextColor: scheme.inversePrimary,
      disabledActionTextColor: scheme.onInverseSurface.withValues(alpha: 0.38),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      behavior: SnackBarBehavior.fixed,
      elevation: 6,
    );
  }

  static final SnackBarThemeData lightSnackBarTheme = _buildSnackBarTheme(
    AppColorScheme.lightColorScheme,
  );

  static final SnackBarThemeData darkSnackBarTheme = _buildSnackBarTheme(
    AppColorScheme.darkColorScheme,
  );
}
