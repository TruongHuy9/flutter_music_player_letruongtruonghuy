import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String darkModeKey = 'dark_mode';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider({required bool initialDarkMode}) {
    _isDarkMode = initialDarkMode;
    debugPrint('🎨 ThemeProvider initialized: isDarkMode = $_isDarkMode');
  }

  Future<void> setDarkMode(bool value) async {
    debugPrint('🎨 setDarkMode called with value: $value, current: $_isDarkMode');
    
    if (_isDarkMode == value) {
      debugPrint('🎨 Value unchanged, returning');
      return;
    }

    _isDarkMode = value;
    debugPrint('🎨 _isDarkMode updated to: $_isDarkMode');
    
    notifyListeners();
    debugPrint('🎨 notifyListeners() called');

    await _saveTheme();
  }

  /// Save theme preference immediately
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(darkModeKey, _isDarkMode);
      debugPrint('🎨 SharedPreferences saved: $darkModeKey = $_isDarkMode');
    } catch (e) {
      debugPrint('❌ Error saving dark mode to SharedPreferences: $e');
    }
  }

  /// Ensure theme is persisted (called on app close)
  Future<void> savePersistence() async {
    debugPrint('💾 ThemeProvider.savePersistence() called');
    await _saveTheme();
  }

  ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      useMaterial3: true,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      useMaterial3: true,
    );
  }
}
