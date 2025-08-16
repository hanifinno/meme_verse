import '../../constants/app_deimensions.dart';
import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class InputThemes {
  static InputDecorationTheme _buildTheme(
    ColorScheme scheme, {
    bool isDark = false,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface, // better contrast for dark mode
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      hintStyle: TextStyle(
        color: scheme.onSurface.withValues(alpha: 0.6),
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
      ),
      labelStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: MEDIUM_WEIGHT,
      ),
      errorStyle: TextStyle(
        color: scheme.error,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: BODY_MEDIUM,
      ),
      helperStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: BODY_MEDIUM,
      ),
      prefixStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
      ),
      suffixStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.outline, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: HSVColor.fromColor(scheme.primary).withValue(0.8).toColor(),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: scheme.outline.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
    );
  }

  static final InputDecorationTheme lightInputDecorationTheme = _buildTheme(
    AppColorScheme.lightColorScheme,
  );

  static final InputDecorationTheme darkInputDecorationTheme = _buildTheme(
    AppColorScheme.darkColorScheme,
    isDark: true,
  );
}
