import '../color/app_color_scheme.dart';
import 'package:flutter/material.dart';

class BottomSheetThemes {
  static BottomSheetThemeData _buildTheme(ColorScheme scheme) {
    return BottomSheetThemeData(
      backgroundColor: scheme.surface,
      modalBackgroundColor: scheme.surface,
      elevation: 8,
      modalElevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(minWidth: double.infinity),
      showDragHandle: true,
    );
  }

  static final BottomSheetThemeData lightBottomSheetTheme = _buildTheme(
    AppColorScheme.lightColorScheme,
  );

  static final BottomSheetThemeData darkBottomSheetTheme = _buildTheme(
    AppColorScheme.darkColorScheme,
  );
}
