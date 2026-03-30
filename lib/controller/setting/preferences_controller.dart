import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesController extends GetxController {
  static const _themeKey = 'theme_mode'; // 0=system, 1=light, 2=dark

  final themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_themeKey);

    final mode = _fromInt(saved ?? 0);
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    // If first time, persist default (system)
    if (saved == null) {
      await prefs.setInt(_themeKey, 0);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _toInt(mode));
  }

  void back() => Get.back();

  // Helpers
  int _toInt(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 0;
      case ThemeMode.light:
        return 1;
      case ThemeMode.dark:
        return 2;
    }
  }

  ThemeMode _fromInt(int v) {
    switch (v) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
