import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Default mengikuti pengaturan tema sistem operasi (komputer/HP)
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light || _themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners(); // Beritahu MaterialApp untuk mengubah UI
  }
}