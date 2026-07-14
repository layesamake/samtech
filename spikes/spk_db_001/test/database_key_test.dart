import 'package:flutter_test/flutter_test.dart';
import 'package:spk_db_001/src/security/database_key.dart';

void main() {
  test('generates independent 256-bit keys and round-trips their encoding', () {
    final generator = DatabaseKeyGenerator();
    final first = generator.generate();
    final second = generator.generate();

    expect(first.copyBytes(), hasLength(DatabaseKey.byteLength));
    expect(second.copyBytes(), hasLength(DatabaseKey.byteLength));
    expect(first.toHex(), isNot(second.toHex()));
    expect(DatabaseKey.fromHex(first.toHex()).copyBytes(), first.copyBytes());
  });

  test('rejects malformed stored values', () {
    expect(() => DatabaseKey.fromHex('not-a-key'), throwsFormatException);
  });
}
