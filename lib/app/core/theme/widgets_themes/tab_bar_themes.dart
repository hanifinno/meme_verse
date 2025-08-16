import '../../constants/app_deimensions.dart';
import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class TabBarThemes {
  static TabBarThemeData _buildTheme(ColorScheme scheme) {
    final bool isDark = scheme.brightness == Brightness.dark;

    return TabBarThemeData(
      // Use onPrimary for dark mode to ensure contrast
      labelColor: isDark ? scheme.inversePrimary : scheme.primary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      indicatorColor: isDark ? scheme.onPrimary : scheme.primary,
      labelStyle: TextStyle(
        fontFamily: FONT_FAMILY,
        fontWeight: MEDIUM_WEIGHT,
        fontSize: LABEL_MEDIUM,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: FONT_FAMILY,
        fontWeight: REGULAR_WEIGHT,
        fontSize: LABEL_MEDIUM,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  static final TabBarThemeData lightTabBarTheme = _buildTheme(
    AppColorScheme.lightColorScheme,
  );

  static final TabBarThemeData darkTabBarTheme = _buildTheme(
    AppColorScheme.darkColorScheme,
  );
}
