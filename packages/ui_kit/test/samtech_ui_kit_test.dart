import 'package:flutter_test/flutter_test.dart';
import 'package:samtech_ui_kit/samtech_ui_kit.dart';

void main() {
  test('spacing tokens use the documented four-point grid', () {
    expect(SamtechSpacing.space1, 4);
    expect(SamtechSpacing.space4, 16);
    expect(SamtechSpacing.space12, 48);
  });

  test('light theme exposes the documented primary color', () {
    expect(SamtechTheme.light().colorScheme.primary.toARGB32(), 0xFF174A7E);
  });
}
