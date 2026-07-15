// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spk_db_001/spk_db_001.dart';
import 'package:path/path.dart' as p;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  late Directory tempDir;
  late File dbFile;
  late KeyManager keyManager;
  late DatabaseService dbService;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('spk_db_001_benchmark');
    dbFile = File(p.join(tempDir.path, 'benchmark.db'));
    keyManager = KeyManager();
    dbService = DatabaseService(keyManager, dbFile);
  });

  tearDown(() async {
    await dbService.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('Benchmark - Insert 5000 rows in transaction', () async {
    final sw = Stopwatch()..start();
    await dbService.initialize();
    print('Open DB: ${sw.elapsedMilliseconds} ms');

    sw.reset();
    await dbService.db.transaction(() async {
      for (int i = 0; i < 5000; i++) {
        await dbService.db.into(dbService.db.contacts).insert(
              ContactsCompanion.insert(
                id: 'c_$i',
                organizationId: 'org1',
                phoneNormalized: '123$i',
                createdAt: 1000,
                updatedAt: 1000,
              ),
            );
      }
    });
    print('Insert 5000 rows in transaction: ${sw.elapsedMilliseconds} ms');

    sw.reset();
    final count = await dbService.db.customSelect('SELECT COUNT(*) as c FROM contacts').getSingle();
    expect(count.read<int>('c'), 5000);
    print('Read 5000 rows count: ${sw.elapsedMilliseconds} ms');

    sw.reset();
    await dbService.rotateKey();
    print('Rotate key (rekey + restart): ${sw.elapsedMilliseconds} ms');
  });
}
