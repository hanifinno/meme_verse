import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class CheckboxThemes {
  static CheckboxThemeData _buildTheme(ColorScheme scheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.surface.withValues(alpha: 0.4);
        }
        if (states.contains(WidgetState.selected)) {
          return scheme.primary;
        }
        return scheme.surface;
      }),
      checkColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withValues(alpha: 0.4);
        }
        if (states.contains(WidgetState.selected)) {
          return scheme.onPrimary;
        }
        return scheme.onSurface;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      side: BorderSide(color: scheme.outline, width: 1),
    );
  }

  static final CheckboxThemeData lightCheckboxTheme = _buildTheme(
    AppColorScheme.lightColorScheme,
  );

  static final CheckboxThemeData darkCheckboxTheme = _buildTheme(
    AppColorScheme.darkColorScheme,
  );
}
