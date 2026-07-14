import 'package:flutter/material.dart';

/// SAMTECH theme built from the provisional documented brand tokens.
abstract final class SamtechTheme {
  static ThemeData light() {
    const primary = Color(0xFF174A7E);
    const secondary = Color(0xFF007C78);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: const Color(0xFFF6F8FB),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(minimumSize: WidgetStatePropertyAll(Size(48, 48))),
      ),
    );
  }
}
