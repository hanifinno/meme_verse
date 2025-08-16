import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorThemes {
  static final ProgressIndicatorThemeData
  lightProgressIndicatorTheme = ProgressIndicatorThemeData(
    color: AppColorScheme.lightColorScheme.primary,
    linearTrackColor: AppColorScheme.lightColorScheme.surfaceContainerHighest,
    linearMinHeight: 4.0,
    circularTrackColor: AppColorScheme.lightColorScheme.surfaceContainerHighest,
    refreshBackgroundColor: AppColorScheme.lightColorScheme.surface,
  );

  static final ProgressIndicatorThemeData
  darkProgressIndicatorTheme = ProgressIndicatorThemeData(
    color: AppColorScheme.darkColorScheme.primary,
    linearTrackColor: AppColorScheme.darkColorScheme.surfaceContainerHighest,
    linearMinHeight: 4.0,
    circularTrackColor: AppColorScheme.darkColorScheme.surfaceContainerHighest,
    refreshBackgroundColor: AppColorScheme.darkColorScheme.surface,
  );
}
