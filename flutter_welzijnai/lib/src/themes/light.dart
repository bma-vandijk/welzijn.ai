import 'package:flutter/material.dart';

/// Light mode
/// Specifies the colourscheme for the light mode theme
/// Filepath: lib/src/themes/light.dart

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
    primary: Color(0xFF8BABF1),
    secondary: Color(0xFFE8E8E8),
    tertiary: Color(0xFFB3C8F7),
    inversePrimary: Color(0xFF959595),
  ),
);
