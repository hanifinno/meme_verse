import 'package:flutter/material.dart';

import '../../constants/app_deimensions.dart';
import '../color/app_color_scheme.dart';

class DatePickerThemes {
  static DatePickerThemeData _buildTheme(ColorScheme scheme) {
    Color getForegroundColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) return scheme.onPrimary;
      if (states.contains(WidgetState.disabled)) {
        return scheme.onSurface.withOpacity(0.4);
      }
      return scheme.onSurface;
    }

    Color getBackgroundColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) return scheme.primary;
      return Colors.transparent;
    }

    return DatePickerThemeData(
      backgroundColor: scheme.surface,
      headerBackgroundColor: scheme.primary,
      headerForegroundColor: scheme.onPrimary,
      headerHeadlineStyle: TextStyle(
        color: scheme.onPrimary,
        fontFamily: FONT_FAMILY,
        fontWeight: BOLD_WEIGHT,
        fontSize: HEADLINE_SMALL,
      ),
      headerHelpStyle: TextStyle(
        color: scheme.onPrimary,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: BODY_LARGE,
      ),
      dayStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: BODY_LARGE,
      ),
      yearStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: BODY_LARGE,
      ),
      weekdayStyle: TextStyle(
        color: scheme.onSurfaceVariant,
        fontFamily: FONT_FAMILY,
        fontWeight: MEDIUM_WEIGHT,
        fontSize: BODY_LARGE,
      ),

      // ✅ FIXED: use MaterialStateProperty
      dayForegroundColor: WidgetStateProperty.resolveWith(getForegroundColor),
      dayBackgroundColor: WidgetStateProperty.resolveWith(getBackgroundColor),
      yearForegroundColor: WidgetStateProperty.resolveWith(getForegroundColor),
      yearBackgroundColor: WidgetStateProperty.resolveWith(getBackgroundColor),

      todayForegroundColor: WidgetStateProperty.all(scheme.primary),
      todayBackgroundColor: WidgetStateProperty.all(scheme.primary),
      todayBorder: BorderSide(color: scheme.primary, width: 1),

      dayShape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static final DatePickerThemeData lightDatePickerTheme = _buildTheme(
    AppColorScheme.lightColorScheme,
  );

  static final DatePickerThemeData darkDatePickerTheme = _buildTheme(
    AppColorScheme.darkColorScheme,
  );
}
