import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class DividerThemes {
  static final DividerThemeData lightDividerTheme = DividerThemeData(
    color: AppColorScheme.lightColorScheme.outline,
    thickness: 1,
    space: 1,
    indent: 0,
    endIndent: 0,
  );

  static final DividerThemeData darkDividerTheme = DividerThemeData(
    color: AppColorScheme.darkColorScheme.outline,
    thickness: 1,
    space: 1,
    indent: 0,
    endIndent: 0,
  );
}
