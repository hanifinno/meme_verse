import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class IconThemes {
  static IconThemeData lightIconTheme = IconThemeData(
    size: 24,
    color: AppColorScheme.lightColorScheme.onSurface,
  );

  static IconThemeData darkIconTheme = IconThemeData(
    size: 24,
    color: AppColorScheme.darkColorScheme.onSurface,
  );
}
