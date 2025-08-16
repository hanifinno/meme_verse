import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class SliderThemes {
  static final SliderThemeData lightSliderTheme = SliderThemeData(
    activeTrackColor: AppColorScheme.lightColorScheme.primary,
    inactiveTrackColor: AppColorScheme.lightColorScheme.surfaceContainerHighest,
    thumbColor: AppColorScheme.lightColorScheme.primary,
    overlayColor: AppColorScheme.lightColorScheme.primary.withValues(
      alpha: 0.12,
    ),
    valueIndicatorColor: AppColorScheme.lightColorScheme.primaryContainer,
    valueIndicatorTextStyle: TextStyle(
      color: AppColorScheme.lightColorScheme.onPrimaryContainer,
    ),
    trackHeight: 4.0,
    thumbShape: const RoundSliderThumbShape(
      enabledThumbRadius: 10.0,
      elevation: 2.0,
      pressedElevation: 4.0,
    ),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
    showValueIndicator: ShowValueIndicator.onlyForDiscrete,
    tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2.0),
    activeTickMarkColor: AppColorScheme.lightColorScheme.onPrimary,
    inactiveTickMarkColor: AppColorScheme.lightColorScheme.onSurfaceVariant
        .withValues(alpha: 0.5),
    trackShape: const RoundedRectSliderTrackShape(),
  );

  static final SliderThemeData darkSliderTheme = SliderThemeData(
    activeTrackColor: AppColorScheme.darkColorScheme.primary,
    inactiveTrackColor: AppColorScheme.darkColorScheme.surfaceContainerHighest,
    thumbColor: AppColorScheme.darkColorScheme.primary,
    overlayColor: AppColorScheme.darkColorScheme.primary.withValues(
      alpha: 0.12,
    ),
    valueIndicatorColor: AppColorScheme.darkColorScheme.primaryContainer,
    valueIndicatorTextStyle: TextStyle(
      color: AppColorScheme.darkColorScheme.onPrimaryContainer,
    ),
    trackHeight: 4.0,
    thumbShape: const RoundSliderThumbShape(
      enabledThumbRadius: 10.0,
      elevation: 2.0,
      pressedElevation: 4.0,
    ),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
    showValueIndicator: ShowValueIndicator.onlyForDiscrete,
    tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2.0),
    activeTickMarkColor: AppColorScheme.darkColorScheme.onPrimary,
    inactiveTickMarkColor: AppColorScheme.darkColorScheme.onSurfaceVariant
        .withValues(alpha: 0.5),
    trackShape: const RoundedRectSliderTrackShape(),
  );
}
