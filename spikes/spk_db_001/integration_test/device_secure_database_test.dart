import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spk_db_001/src/database/encrypted_database_factory.dart';
import 'package:spk_db_001/src/security/database_key_manager.dart';
import 'package:spk_db_001/src/security/flutter_secure_key_store.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('uses the native vault and reopens the encrypted database', (
    tester,
  ) async {
    const preserveState = bool.fromEnvironment('SPK_PRESERVE_STATE');
    const expectExistingState = bool.fromEnvironment(
      'SPK_EXPECT_EXISTING_STATE',
    );
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/spk_db_001_device_test.sqlite3');
    final store = FlutterSecureKeyStore(
      storageKey: 'database_key_device_test_v1',
    );
    final manager = DatabaseKeyManager(keyStore: store);
    const factory = EncryptedDatabaseFactory();

    final firstKey = await manager.loadOrCreate(databaseFile: file);
    var database = factory.open(file: file, key: firstKey);
    await database.customSelect('SELECT count(*) FROM sqlite_schema;').get();
    final initialCount = await database.entryCount();
    if (expectExistingState) {
      expect(initialCount, greaterThan(0));
    }
    final groupId = await database.createGroup('Exécution mobile fictive');
    await database.createEntry(
      groupId: groupId,
      payload: 'Donnée fictive de validation native',
    );
    final expectedCount = initialCount + 1;
    expect(await database.entryCount(), expectedCount);
    await database.close();

    final secondKey = await DatabaseKeyManager(
      keyStore: store,
    ).loadOrCreate(databaseFile: file);
    expect(secondKey.copyBytes(), firstKey.copyBytes());

    database = factory.open(file: file, key: secondKey);
    expect(await database.entryCount(), expectedCount);
    await database.close();

    if (!preserveState) {
      for (final suffix in const ['', '-wal', '-shm', '-journal']) {
        final artifact = File('${file.path}$suffix');
        if (await artifact.exists()) {
          await artifact.delete();
        }
      }
      await store.delete();
    }
  });
}
