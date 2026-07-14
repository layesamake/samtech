import 'dart:convert';
import 'dart:io';

import 'package:spk_db_001/src/bootstrap/spike_bootstrap.dart';
import 'package:spk_db_001/src/security/secure_key_store.dart';

Future<void> main() async {
  final directory = await Directory.systemTemp.createTemp('spk-db-benchmark-');
  try {
    final report = await SpikeBootstrap(
      supportDirectory: directory,
      keyStore: _EphemeralKeyStore(),
    ).run();

    stdout.writeln(
      jsonEncode({
        'rows': report.insertedRows,
        'open_ms': report.openDuration.inMicroseconds / 1000,
        'write_ms': report.writeDuration.inMicroseconds / 1000,
        'read_ms': report.readDuration.inMicroseconds / 1000,
        'foreign_keys': report.foreignKeysEnabled,
        'journal_mode': report.journalMode,
        'cipher': report.cipher,
      }),
    );
  } finally {
    await directory.delete(recursive: true);
  }
}

final class _EphemeralKeyStore implements SecureKeyStore {
  String? _value;

  @override
  Future<void> delete() async => _value = null;

  @override
  Future<String?> read() async => _value;

  @override
  Future<void> write(String encodedKey) async => _value = encodedKey;
}
