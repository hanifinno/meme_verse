import '../../constants/app_deimensions.dart';
import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class PopupMenuThemes {
  static PopupMenuThemeData _buildTheme(ColorScheme scheme) {
    return PopupMenuThemeData(
      color: scheme.surface,
      elevation: 3,
      shadowColor: scheme.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: BODY_LARGE,
      ),
      enableFeedback: true,
    );
  }

  static final PopupMenuThemeData lightPopupMenuTheme = _buildTheme(
    AppColorScheme.lightColorScheme,
  );

  static final PopupMenuThemeData darkPopupMenuTheme = _buildTheme(
    AppColorScheme.darkColorScheme,
  );
}
