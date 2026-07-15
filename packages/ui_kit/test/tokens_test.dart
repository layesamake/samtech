import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('SamtechColors', () {
    test('brand primary light is documented value', () {
      expect(SamtechColors.primaryLight, equals(const Color(0xFF174A7E)));
    });

    test('brand secondary light is documented value', () {
      expect(SamtechColors.secondaryLight, equals(const Color(0xFF007C78)));
    });

    test('semantic danger is documented value', () {
      expect(SamtechColors.danger, equals(const Color(0xFFB42318)));
    });

    test('semantic success is documented value', () {
      expect(SamtechColors.success, equals(const Color(0xFF18794E)));
    });

    test('light content color pairs meet WCAG AA for normal text', () {
      const minimumContrast = 4.5;

      expect(
        _contrastRatio(
          SamtechColors.onPrimaryLight,
          SamtechColors.primaryLight,
        ),
        greaterThanOrEqualTo(minimumContrast),
      );
      expect(
        _contrastRatio(
          SamtechColors.onSecondaryLight,
          SamtechColors.secondaryLight,
        ),
        greaterThanOrEqualTo(minimumContrast),
      );
      expect(
        _contrastRatio(
          SamtechColors.textPrimaryLight,
          SamtechColors.surfaceLight,
        ),
        greaterThanOrEqualTo(minimumContrast),
      );
      expect(
        _contrastRatio(
          SamtechColors.textSecondaryLight,
          SamtechColors.surfaceLight,
        ),
        greaterThanOrEqualTo(minimumContrast),
      );
      expect(
        _contrastRatio(SamtechColors.danger, SamtechColors.surfaceLight),
        greaterThanOrEqualTo(minimumContrast),
      );
    });
  });

  group('SamtechSpacing', () {
    test('spacing follows 4pt base grid', () {
      expect(SamtechSpacing.space1, equals(4.0));
      expect(SamtechSpacing.space2, equals(8.0));
      expect(SamtechSpacing.space3, equals(12.0));
      expect(SamtechSpacing.space4, equals(16.0));
      expect(SamtechSpacing.space12, equals(48.0));
    });

    test('screen margin phone is space4', () {
      expect(SamtechSpacing.screenMarginPhone, equals(SamtechSpacing.space4));
    });
  });

  group('SamtechRadius', () {
    test('documented radius values', () {
      expect(SamtechRadius.small, equals(8.0));
      expect(SamtechRadius.medium, equals(12.0));
      expect(SamtechRadius.large, equals(16.0));
      expect(SamtechRadius.full, equals(999.0));
    });
  });

  group('SamtechTypography', () {
    test('body text is 16pt regular', () {
      expect(SamtechTypography.body.fontSize, equals(16.0));
      expect(SamtechTypography.body.fontWeight, equals(FontWeight.w400));
    });

    test('title1 is 24pt bold', () {
      expect(SamtechTypography.title1.fontSize, equals(24.0));
      expect(SamtechTypography.title1.fontWeight, equals(FontWeight.w700));
    });

    test('label is 14pt semibold', () {
      expect(SamtechTypography.label.fontSize, equals(14.0));
      expect(SamtechTypography.label.fontWeight, equals(FontWeight.w600));
    });

    test('tokens do not invent undocumented line heights', () {
      expect(SamtechTypography.display.height, isNull);
      expect(SamtechTypography.title1.height, isNull);
      expect(SamtechTypography.title2.height, isNull);
      expect(SamtechTypography.title3.height, isNull);
      expect(SamtechTypography.body.height, isNull);
      expect(SamtechTypography.bodyCompact.height, isNull);
      expect(SamtechTypography.label.height, isNull);
      expect(SamtechTypography.caption.height, isNull);
    });
  });
}

double _contrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}
