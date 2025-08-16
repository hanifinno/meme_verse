import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class CardThemes {
  static CardThemeData _buildCardTheme({
    required Color backgroundColor,
    required Color shadowColor,
    required Color borderColor,
    double elevation = 1,
    double borderRadius = 12,
  }) {
    return CardThemeData(
      color: backgroundColor,
      shadowColor: shadowColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor, width: 1),
      ),
    );
  }

  static final CardThemeData lightCardTheme = _buildCardTheme(
    backgroundColor: AppColorScheme.lightColorScheme.surface,
    shadowColor: AppColorScheme.lightColorScheme.shadow,
    borderColor: AppColorScheme.lightColorScheme.outline,
  );

  static final CardThemeData darkCardTheme = _buildCardTheme(
    backgroundColor: AppColorScheme.darkColorScheme.surface,
    shadowColor: AppColorScheme.darkColorScheme.shadow,
    borderColor: AppColorScheme.darkColorScheme.outline,
  );
}
