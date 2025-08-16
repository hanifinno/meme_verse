import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class RadioThemes {
  static final RadioThemeData lightRadioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return AppColorScheme.lightColorScheme.onSurface.withValues(
          alpha: 0.38,
        );
      }
      if (states.contains(WidgetState.selected)) {
        return AppColorScheme.lightColorScheme.primary;
      }
      return AppColorScheme.lightColorScheme.onSurfaceVariant;
    }),
    overlayColor: WidgetStateProperty.resolveWith<Color>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.pressed)) {
        return AppColorScheme.lightColorScheme.primary.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColorScheme.lightColorScheme.primary.withValues(alpha: 0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return AppColorScheme.lightColorScheme.primary.withValues(alpha: 0.12);
      }
      return Colors.transparent;
    }),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.standard,
  );

  static final RadioThemeData darkRadioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return AppColorScheme.darkColorScheme.onSurface.withValues(alpha: 0.38);
      }
      if (states.contains(WidgetState.selected)) {
        return AppColorScheme.darkColorScheme.primary;
      }
      return AppColorScheme.darkColorScheme.onSurfaceVariant;
    }),
    overlayColor: WidgetStateProperty.resolveWith<Color>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.pressed)) {
        return AppColorScheme.darkColorScheme.primary.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColorScheme.darkColorScheme.primary.withValues(alpha: 0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return AppColorScheme.darkColorScheme.primary.withValues(alpha: 0.12);
      }
      return Colors.transparent;
    }),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.standard,
  );
}
