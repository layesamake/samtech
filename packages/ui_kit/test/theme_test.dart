import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('SamtechTheme', () {
    test('light theme uses Material 3', () {
      final theme = SamtechTheme.light();
      expect(theme.useMaterial3, isTrue);
    });

    test('light theme uses SAMTECH primary color', () {
      final theme = SamtechTheme.light();
      expect(theme.colorScheme.primary, equals(SamtechColors.primaryLight));
    });

    test('light theme scaffold background is canvas', () {
      final theme = SamtechTheme.light();
      expect(theme.scaffoldBackgroundColor, equals(SamtechColors.canvasLight));
    });

    test('light theme maps documented surface and text tokens', () {
      final theme = SamtechTheme.light();
      expect(
        theme.colorScheme.onSurface,
        equals(SamtechColors.textPrimaryLight),
      );
      expect(
        theme.colorScheme.onSurfaceVariant,
        equals(SamtechColors.textSecondaryLight),
      );
      expect(theme.colorScheme.outline, equals(SamtechColors.borderLight));
      expect(theme.disabledColor, equals(SamtechColors.textDisabledLight));
    });

    test('light theme maps documented semantic error colors', () {
      final theme = SamtechTheme.light();
      expect(theme.colorScheme.error, equals(SamtechColors.danger));
      expect(theme.colorScheme.onError, equals(SamtechColors.onPrimaryLight));
    });

    test('light theme maps documented typography', () {
      final theme = SamtechTheme.light();
      expect(
        theme.textTheme.headlineLarge?.fontSize,
        equals(SamtechTypography.title1.fontSize),
      );
      expect(
        theme.textTheme.bodyLarge?.fontSize,
        equals(SamtechTypography.body.fontSize),
      );
      expect(
        theme.textTheme.labelLarge?.fontWeight,
        equals(SamtechTypography.label.fontWeight),
      );
      expect(
        theme.textTheme.bodyLarge?.color,
        equals(SamtechColors.textPrimaryLight),
      );
    });
  });
}
