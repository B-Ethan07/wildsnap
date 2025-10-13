import 'package:flutter/material.dart';

class AppTheme {
  static const _green = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFF66BB6A);
  static const _amber = Color(0xFFFFD54F);

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: _green,
      secondary: _lightGreen,
      tertiary: _amber,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _green,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _green,
        foregroundColor: Colors.white,
      ),
    ),
    cardTheme: const CardThemeData(
      color: _amber,
      elevation: 4,
    ),
    switchTheme: SwitchThemeData(
      thumbIcon: WidgetStateProperty.all(
        Icon(Icons.dark_mode, size: 16, color: Colors.amber),
      ),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return Colors.black;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        return Colors.white;
      }),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: _lightGreen,
      secondary: Color(0xFF1B5E20),
      tertiary: Color(0xFFFFB300),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B5E20),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightGreen,
        foregroundColor: Colors.black,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF2A2A2A), // gris anthracite
      elevation: 4,
    ),
    switchTheme: SwitchThemeData(
      thumbIcon: WidgetStateProperty.all(
        Icon(Icons.dark_mode, size: 16, color: Colors.black),
      ),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        return Colors.black;
      }),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;
  ThemeData get theme => _isDark ? AppTheme.dark : AppTheme.light;

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
