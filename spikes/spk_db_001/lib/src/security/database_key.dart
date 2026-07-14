import 'dart:math';
import 'dart:typed_data';

final class DatabaseKey {
  DatabaseKey(Uint8List bytes) : _bytes = Uint8List.fromList(bytes) {
    if (_bytes.length != byteLength) {
      throw ArgumentError.value(
        _bytes.length,
        'bytes.length',
        'A database key must contain exactly $byteLength bytes.',
      );
    }
  }

  static const int byteLength = 32;

  final Uint8List _bytes;

  Uint8List copyBytes() => Uint8List.fromList(_bytes);

  String toHex() {
    final buffer = StringBuffer();
    for (final byte in _bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  static DatabaseKey fromHex(String value) {
    if (value.length != byteLength * 2 ||
        !RegExp(r'^[0-9a-fA-F]+$').hasMatch(value)) {
      throw const FormatException('Invalid database key encoding.');
    }

    final bytes = Uint8List(byteLength);
    for (var index = 0; index < byteLength; index++) {
      bytes[index] = int.parse(
        value.substring(index * 2, index * 2 + 2),
        radix: 16,
      );
    }
    return DatabaseKey(bytes);
  }
}

final class DatabaseKeyGenerator {
  DatabaseKey generate() {
    final random = Random.secure();
    final bytes = Uint8List(DatabaseKey.byteLength);
    for (var index = 0; index < bytes.length; index++) {
      bytes[index] = random.nextInt(256);
    }
    return DatabaseKey(bytes);
  }
}
