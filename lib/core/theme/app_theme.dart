import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0D0A1C),
    scaffoldBackgroundColor: const Color(0xFF0D0A1C),
    canvasColor: const Color(0xFF0D0A1C),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D0A1C),
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0D0A1C),
      secondary: Color(0xFF00E5FF),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // Define default elevated button style, etc., as needed
  );
}
