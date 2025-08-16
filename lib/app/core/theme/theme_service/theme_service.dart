import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../app_theme.dart';

enum ThemeType { light, dark, system }

class ThemeService extends GetxService {
  static const String _themeKey = 'theme_preference';
  final GetStorage _storage = GetStorage();

  // Observable
  final _themeType = ThemeType.system.obs;
  final _themeData = AppTheme.lightTheme.obs;
  final _isDark = false.obs;

  ThemeType get themeType => _themeType.value;
  ThemeData get themeData => _themeData.value;
  bool get isDark => _isDark.value;

  Future<ThemeService> init() async {
    _loadThemePreference();

    // Listen to system brightness changes
    WidgetsBinding
        .instance
        .platformDispatcher
        .onPlatformBrightnessChanged = () {
      handleSystemThemeChange();
    };

    return this;
  }

  // Load saved theme
  void _loadThemePreference() {
    final savedTheme = _storage.read<String>(_themeKey);
    _themeType.value = ThemeType.values.firstWhere(
      (e) => e.name == savedTheme,
      orElse: () => ThemeType.system,
    );
    _updateTheme();
  }

  // Save preference
  void _saveThemePreference() {
    _storage.write(_themeKey, _themeType.value.name);
  }

  // Update theme
  void _updateTheme() {
    switch (_themeType.value) {
      case ThemeType.light:
        _themeData.value = AppTheme.lightTheme;
        _isDark.value = false;
        _updateSystemUI(false);
        break;
      case ThemeType.dark:
        _themeData.value = AppTheme.darkTheme;
        _isDark.value = true;
        _updateSystemUI(true);
        break;
      case ThemeType.system:
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        _isDark.value = brightness == Brightness.dark;
        _themeData.value =
            _isDark.value ? AppTheme.darkTheme : AppTheme.lightTheme;
        _updateSystemUI(_isDark.value);
        break;
    }
  }

  // Update system overlay
  void _updateSystemUI(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }

  // Set theme type
  void setThemeType(ThemeType type) {
    if (_themeType.value != type) {
      _themeType.value = type;
      _saveThemePreference();
      _updateTheme();
    }
  }

  // Toggle theme
  void toggleTheme() {
    switch (_themeType.value) {
      case ThemeType.light:
        setThemeType(ThemeType.dark);
        break;
      case ThemeType.dark:
        setThemeType(ThemeType.light);
        break;
      case ThemeType.system:
        setThemeType(_isDark.value ? ThemeType.light : ThemeType.dark);
        break;
    }
  }

  // Handle system changes
  void handleSystemThemeChange() {
    if (_themeType.value == ThemeType.system) {
      _updateTheme();
    }
  }
}
