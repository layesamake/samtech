final class SpikeReport {
  const SpikeReport({
    required this.openDuration,
    required this.writeDuration,
    required this.readDuration,
    required this.insertedRows,
    required this.foreignKeysEnabled,
    required this.journalMode,
    required this.cipher,
  });

  final Duration openDuration;
  final Duration writeDuration;
  final Duration readDuration;
  final int insertedRows;
  final bool foreignKeysEnabled;
  final String journalMode;
  final String cipher;
}
