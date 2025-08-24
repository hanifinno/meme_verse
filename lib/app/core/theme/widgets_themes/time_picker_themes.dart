import '../../constants/app_deimensions.dart';
import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class TimePickerThemes {
  static TimePickerThemeData _buildTheme(ColorScheme scheme) {
    final inputDecoration = InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.03),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    );

    return TimePickerThemeData(
      backgroundColor: scheme.surface,
      hourMinuteTextColor: scheme.onSurface,
      hourMinuteColor: scheme.surfaceContainer, // darker in dark mode
      dayPeriodTextColor: scheme.onSurface,
      dayPeriodColor: scheme.surfaceContainer,
      dialHandColor: scheme.primary,

      dialBackgroundColor: scheme.surfaceContainer,
      dialTextColor: scheme.onSurface,
      dialTextStyle: TextStyle(
        fontFamily: FONT_FAMILY,
        fontWeight: MEDIUM_WEIGHT,
        fontSize: BODY_LARGE,
        color: scheme.surface,
      ),

      entryModeIconColor: scheme.onSurface,
      hourMinuteTextStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: DISPLAY_MEDIUM,
      ),
      dayPeriodTextStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: BODY_LARGE,
      ),
      helpTextStyle: TextStyle(
        color: scheme.onSurfaceVariant,
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: BODY_MEDIUM,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      dayPeriodBorderSide: BorderSide(color: scheme.outlineVariant, width: 1),
      inputDecorationTheme: inputDecoration,
    );
  }

  static final TimePickerThemeData lightTimePickerTheme = _buildTheme(
    AppColorScheme.lightColorScheme,
  );

  static final TimePickerThemeData darkTimePickerTheme = _buildTheme(
    AppColorScheme.darkColorScheme,
  );
}
