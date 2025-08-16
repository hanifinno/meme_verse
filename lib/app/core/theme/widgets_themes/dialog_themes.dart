import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class DialogThemes {
  static final DialogThemeData lightDialogTheme = DialogThemeData(
    backgroundColor: AppColorScheme.lightColorScheme.surface,
    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    alignment: Alignment.center,
  );

  static final DialogThemeData darkDialogTheme = DialogThemeData(
    backgroundColor: AppColorScheme.darkColorScheme.surface,
    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    alignment: Alignment.center,
  );
}
