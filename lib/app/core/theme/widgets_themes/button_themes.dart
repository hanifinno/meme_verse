import '../../constants/app_deimensions.dart';
import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonThemes {
  // ===== COMMON STYLES =====
  static const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const _borderRadius = 8.0;
  static const _fontWeight = MEDIUM_WEIGHT;
  static const _fontSize = LABEL_MEDIUM;

  // ===== GENERIC BUTTON STYLES =====

  static ButtonStyle elevatedStyle({
    required Color background,
    required Color foreground,
    required Color disabledBackground,
    required Color disabledForeground,
  }) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: background,
      foregroundColor: foreground,
      disabledBackgroundColor: disabledBackground,
      disabledForegroundColor: disabledForeground,
      padding: _padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      textStyle: GoogleFonts.inter(
        fontWeight: _fontWeight,
        fontSize: _fontSize,
      ),
    );
  }

  static ButtonStyle outlinedStyle({
    required Color background,
    required Color foreground,
    required Color disabledForeground,
    required Color borderColor,
  }) {
    return OutlinedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      disabledForegroundColor: disabledForeground,
      side: BorderSide(color: borderColor, width: 1),
      padding: _padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      textStyle: GoogleFonts.inter(
        fontWeight: _fontWeight,
        fontSize: _fontSize,
      ),
    );
  }

  static ButtonStyle textStyle({
    required Color background,
    required Color foreground,
    required Color disabledForeground,
  }) {
    return TextButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      disabledForegroundColor: disabledForeground,
      padding: _padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      textStyle: GoogleFonts.inter(
        fontWeight: _fontWeight,
        fontSize: _fontSize,
      ),
    );
  }

  // ===== LIGHT THEME =====
  static final ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: elevatedStyle(
          background: AppColorScheme.lightColorScheme.primary,
          foreground: AppColorScheme.lightColorScheme.onPrimary,
          disabledBackground: AppColorScheme.lightColorScheme.primary
              .withValues(alpha: 0.2),
          disabledForeground: AppColorScheme.lightColorScheme.onPrimary
              .withValues(alpha: 0.6),
        ),
      );

  static final OutlinedButtonThemeData lightOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: outlinedStyle(
          background: AppColorScheme.lightColorScheme.surface,
          foreground: AppColorScheme.lightColorScheme.onSurface,
          disabledForeground: AppColorScheme.lightColorScheme.onSurface
              .withValues(alpha: 0.4),
          borderColor: AppColorScheme.lightColorScheme.outline,
        ),
      );

  static final TextButtonThemeData lightTextButtonTheme = TextButtonThemeData(
    style: textStyle(
      background: AppColorScheme.lightColorScheme.surface,
      foreground: AppColorScheme.lightColorScheme.onSurface,
      disabledForeground: AppColorScheme.lightColorScheme.onSurface.withValues(
        alpha: 0.4,
      ),
    ),
  );

  // ===== DARK THEME =====
  static final ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: elevatedStyle(
          background: AppColorScheme.darkColorScheme.primary,
          foreground: AppColorScheme.darkColorScheme.onPrimary,
          disabledBackground: AppColorScheme.darkColorScheme.primary.withValues(
            alpha: 0.2,
          ),
          disabledForeground: AppColorScheme.darkColorScheme.onPrimary
              .withValues(alpha: 0.6),
        ),
      );

  static final OutlinedButtonThemeData darkOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: outlinedStyle(
          background: AppColorScheme.darkColorScheme.surface,
          foreground: AppColorScheme.darkColorScheme.onSurface,
          disabledForeground: AppColorScheme.darkColorScheme.onSurface
              .withValues(alpha: 0.4),
          borderColor: AppColorScheme.darkColorScheme.outline,
        ),
      );

  static final TextButtonThemeData darkTextButtonTheme = TextButtonThemeData(
    style: textStyle(
      background: AppColorScheme.darkColorScheme.surface,
      foreground: AppColorScheme.darkColorScheme.onSurface,
      disabledForeground: AppColorScheme.darkColorScheme.onSurface.withValues(
        alpha: 0.4,
      ),
    ),
  );
}
