import 'package:meme_verse/app/core/theme/color/app_colors.dart';

import '../../constants/app_deimensions.dart';
import 'package:flutter/material.dart';

class DatePickerThemes {
  static DatePickerThemeData _buildTheme(ColorScheme scheme) {
    Color getForegroundColor(Set<WidgetState> states, Color selectedColor) {
      if (states.contains(WidgetState.selected)) return scheme.onPrimary;
      if (states.contains(WidgetState.disabled)) {
        return scheme.onSurface.withValues(alpha: 0.4);
      }
      return scheme.onSurface;
    }

    Color getBackgroundColor(Set<WidgetState> states, Color selectedColor) {
      if (states.contains(WidgetState.selected)) return scheme.primary;
      return AppColors.TRANSPARENT;
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
      dayForegroundColor: WidgetStateProperty.resolveWith(
        (states) => getForegroundColor(states, scheme.primary),
      ),
      dayBackgroundColor: WidgetStateProperty.resolveWith(
        (states) => getBackgroundColor(states, scheme.primary),
      ),
      yearForegroundColor: WidgetStateProperty.resolveWith(
        (states) => getForegroundColor(states, scheme.primary),
      ),
      yearBackgroundColor: WidgetStateProperty.resolveWith(
        (states) => getBackgroundColor(states, scheme.primary),
      ),
      todayForegroundColor: WidgetStateProperty.all(scheme.primary),
      todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
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
