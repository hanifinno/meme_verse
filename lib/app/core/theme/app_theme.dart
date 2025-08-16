import 'color/app_color_scheme.dart';
// import 'manager/switch_theme.dart';
import 'widgets_themes/app_text_theme.dart';
import 'widgets_themes/bottom_sheet_themes.dart';
import 'widgets_themes/button_themes.dart';
import 'widgets_themes/card_themes.dart';
import 'widgets_themes/checkbox_themes.dart';
import 'widgets_themes/date_picker_themes.dart';
import 'widgets_themes/dialog_themes.dart';
import 'widgets_themes/divider_themes.dart';
import 'widgets_themes/icon_themes.dart';
import 'widgets_themes/input_themes.dart';
import 'widgets_themes/popup_menu_themes.dart';
import 'widgets_themes/progress_indicator_themes.dart';
import 'widgets_themes/radio_themes.dart';
import 'widgets_themes/slider_themes.dart';
import 'widgets_themes/snackbar_themes.dart';
import 'widgets_themes/tab_bar_themes.dart';
import 'widgets_themes/time_picker_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  /*
     * ┏==================================================================================================┓
     * ┃                                 LIGHT THEME                                                      ┃
     * ┗==================================================================================================┛
     */
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: AppColorScheme.lightColorScheme.brightness,
    colorScheme: AppColorScheme.lightColorScheme,
    textTheme: AppTextTheme.lightTextTheme,
    scaffoldBackgroundColor: AppColorScheme.lightColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorScheme.lightColorScheme.surface,
      foregroundColor: AppColorScheme.lightColorScheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardThemes.lightCardTheme,
    iconTheme: IconThemes.lightIconTheme,
    elevatedButtonTheme: ButtonThemes.lightElevatedButtonTheme,
    outlinedButtonTheme: ButtonThemes.lightOutlinedButtonTheme,
    textButtonTheme: ButtonThemes.lightTextButtonTheme,
    inputDecorationTheme: InputThemes.lightInputDecorationTheme,
    checkboxTheme: CheckboxThemes.lightCheckboxTheme,
    dialogTheme: DialogThemes.lightDialogTheme,
    dividerTheme: DividerThemes.lightDividerTheme,
    popupMenuTheme: PopupMenuThemes.lightPopupMenuTheme,
    snackBarTheme: SnackBarThemes.lightSnackBarTheme,
    bottomSheetTheme: BottomSheetThemes.lightBottomSheetTheme,
    progressIndicatorTheme: ProgressIndicatorThemes.lightProgressIndicatorTheme,
    sliderTheme: SliderThemes.lightSliderTheme,
    datePickerTheme: DatePickerThemes.lightDatePickerTheme,
    timePickerTheme: TimePickerThemes.lightTimePickerTheme,
    primaryTextTheme: AppTextTheme.lightTextTheme,

    // bottomNavigationBarTheme: BottomNavThemes.darkBottomNavigationBarTheme,
  );

  /*
     * ┏==================================================================================================┓
     * ┃                                 DARK THEME                                                       ┃
     * ┗==================================================================================================┛
     */
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColorScheme.darkColorScheme,
    textTheme: AppTextTheme.darkTextTheme,
    scaffoldBackgroundColor: AppColorScheme.darkColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorScheme.darkColorScheme.surface,
      foregroundColor: AppColorScheme.darkColorScheme.onSurface,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    cardTheme: CardThemes.darkCardTheme,
    iconTheme: IconThemes.darkIconTheme,
    elevatedButtonTheme: ButtonThemes.darkElevatedButtonTheme,
    outlinedButtonTheme: ButtonThemes.darkOutlinedButtonTheme,
    textButtonTheme: ButtonThemes.darkTextButtonTheme,
    inputDecorationTheme: InputThemes.darkInputDecorationTheme,
    checkboxTheme: CheckboxThemes.darkCheckboxTheme,
    radioTheme: RadioThemes.darkRadioTheme,
    // switchTheme: SwitchThemes.darkSwitchTheme,
    // bottomNavigationBarTheme: BottomNavThemes.darkBottomNavigationBarTheme,
    tabBarTheme: TabBarThemes.darkTabBarTheme,
    dialogTheme: DialogThemes.darkDialogTheme,
    dividerTheme: DividerThemes.darkDividerTheme,
    popupMenuTheme: PopupMenuThemes.darkPopupMenuTheme,
    snackBarTheme: SnackBarThemes.darkSnackBarTheme,
    bottomSheetTheme: BottomSheetThemes.darkBottomSheetTheme,
    progressIndicatorTheme: ProgressIndicatorThemes.darkProgressIndicatorTheme,
    sliderTheme: SliderThemes.darkSliderTheme,
    datePickerTheme: DatePickerThemes.darkDatePickerTheme,
    timePickerTheme: TimePickerThemes.darkTimePickerTheme,
    primaryTextTheme: AppTextTheme.darkTextTheme,

    // extensions: <ThemeExtension<dynamic>>[CustomThemeExtension.dark],
  );
}
