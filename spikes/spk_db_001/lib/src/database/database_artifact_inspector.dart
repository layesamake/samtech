import 'dart:convert';
import 'dart:io';

final class DatabaseArtifactInspector {
  const DatabaseArtifactInspector();

  Future<List<File>> existingArtifacts(File databaseFile) async {
    final files = <File>[];
    for (final suffix in const ['', '-wal', '-shm', '-journal']) {
      final candidate = File('${databaseFile.path}$suffix');
      if (await candidate.exists()) {
        files.add(candidate);
      }
    }
    return files;
  }

  Future<bool> containsPlaintext({
    required File databaseFile,
    required String marker,
  }) async {
    final markerBytes = utf8.encode(marker);
    for (final artifact in await existingArtifacts(databaseFile)) {
      final bytes = await artifact.readAsBytes();
      if (_contains(bytes, markerBytes)) {
        return true;
      }
    }
    return false;
  }

  bool _contains(List<int> source, List<int> pattern) {
    if (pattern.isEmpty || pattern.length > source.length) {
      return false;
    }
    for (var offset = 0; offset <= source.length - pattern.length; offset++) {
      var matches = true;
      for (var index = 0; index < pattern.length; index++) {
        if (source[offset + index] != pattern[index]) {
          matches = false;
          break;
        }
      }
      if (matches) {
        return true;
      }
    }
    return false;
  }
}
