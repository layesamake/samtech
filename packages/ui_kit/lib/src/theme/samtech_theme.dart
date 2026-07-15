import 'package:flutter/material.dart';

import '../tokens/samtech_colors.dart';
import '../tokens/samtech_typography.dart';

/// Thème Material 3 SAMTECH fondé sur les tokens documentés.
abstract final class SamtechTheme {
  /// Thème clair SAMTECH.
  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: SamtechColors.primaryLight,
      onPrimary: SamtechColors.onPrimaryLight,
      secondary: SamtechColors.secondaryLight,
      onSecondary: SamtechColors.onSecondaryLight,
      surface: SamtechColors.surfaceLight,
      onSurface: SamtechColors.textPrimaryLight,
      onSurfaceVariant: SamtechColors.textSecondaryLight,
      surfaceDim: SamtechColors.canvasLight,
      surfaceContainer: SamtechColors.surfaceLight,
      surfaceContainerHigh: SamtechColors.raisedLight,
      surfaceContainerHighest: SamtechColors.subtleLight,
      outline: SamtechColors.borderLight,
      error: SamtechColors.danger,
      onError: SamtechColors.onPrimaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SamtechColors.canvasLight,
      disabledColor: SamtechColors.textDisabledLight,
      textTheme: _lightTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: SamtechColors.primaryLight,
        foregroundColor: SamtechColors.onPrimaryLight,
        elevation: 0,
      ),
    );
  }

  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: _light(SamtechTypography.display),
    displayMedium: _light(SamtechTypography.display),
    displaySmall: _light(SamtechTypography.title1),
    headlineLarge: _light(SamtechTypography.title1),
    headlineMedium: _light(SamtechTypography.title2),
    headlineSmall: _light(SamtechTypography.title3),
    titleLarge: _light(SamtechTypography.title2),
    titleMedium: _light(SamtechTypography.title3),
    titleSmall: _light(SamtechTypography.label),
    bodyLarge: _light(SamtechTypography.body),
    bodyMedium: _light(SamtechTypography.bodyCompact),
    bodySmall: _light(SamtechTypography.caption),
    labelLarge: _light(SamtechTypography.label),
    labelMedium: _light(SamtechTypography.label),
    labelSmall: _light(SamtechTypography.caption),
  );

  static TextStyle _light(TextStyle style) =>
      style.copyWith(color: SamtechColors.textPrimaryLight);
}
