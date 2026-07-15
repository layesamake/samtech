import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spk_db_001/spk_db_001.dart';
import 'package:path/path.dart' as p;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  late Directory tempDir;
  late File dbFile;
  late KeyManager keyManager;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('spk_db_001_test_rot');
    dbFile = File(p.join(tempDir.path, 'app.db'));
    keyManager = KeyManager();
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('Normal key rotation', () async {
    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    
    final oldKey = await keyManager.getMainKey();
    await dbService.rotateKey();
    final newKey = await keyManager.getMainKey();
    
    expect(oldKey, isNot(equals(newKey)));
    await dbService.close();
  });

  test('Recover from interruption during preparation (temp key ignored)', () async {
    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    await dbService.close();

    // Simuler crash avant PRAGMA rekey
    await keyManager.setRotationState(KeyRotationState.preparing);
    await keyManager.saveTempKey('temp_key');

    // Redémarrage
    final newService = DatabaseService(keyManager, dbFile);
    await newService.initialize();

    final state = await keyManager.getRotationState();
    expect(state, KeyRotationState.idle);
    await newService.close();
  });

  test('Recover from interruption after rekey but before vault update', () async {
    if (Platform.isWindows) return; // PRAGMA rekey works natively on Android/iOS via sqlite3mc

    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    
    final newKey = keyManager.generateNewKey();
    await keyManager.setRotationState(KeyRotationState.rekeying);
    await keyManager.saveTempKey(newKey);
    await dbService.db.customStatement("PRAGMA rekey = '$newKey';");
    
    // Crash simulé (dbService ne met pas à jour le vault principal)
    await dbService.close();

    // Redémarrage
    final newService = DatabaseService(keyManager, dbFile);
    await newService.initialize();

    final state = await keyManager.getRotationState();
    expect(state, KeyRotationState.idle);
    
    final currentKey = await keyManager.getMainKey();
    expect(currentKey, newKey); // Le vault a été mis à jour avec la clé temporaire
    await newService.close();
  });

  test('Recover from interruption during updatingVault', () async {
    if (Platform.isWindows) return;

    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    
    final newKey = keyManager.generateNewKey();
    await dbService.db.customStatement("PRAGMA rekey = '$newKey';");
    await dbService.close();

    // Crash simulé (Etat: updatingVault, db rekey ok)
    await keyManager.setRotationState(KeyRotationState.updatingVault);
    await keyManager.saveTempKey(newKey);

    final newService = DatabaseService(keyManager, dbFile);
    await newService.initialize();

    final state = await keyManager.getRotationState();
    expect(state, KeyRotationState.idle);
    expect(await keyManager.getMainKey(), newKey);
    await newService.close();
  });

  test('Recover from interruption during cleanup', () async {
    if (Platform.isWindows) return;

    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    
    final newKey = keyManager.generateNewKey();
    await dbService.db.customStatement("PRAGMA rekey = '$newKey';");
    await dbService.close();

    await keyManager.saveTempKey(newKey);
    await keyManager.commitTempKeyToMain(); // Déjà commité
    await keyManager.setRotationState(KeyRotationState.cleanup);

    final newService = DatabaseService(keyManager, dbFile);
    await newService.initialize();

    final state = await keyManager.getRotationState();
    expect(state, KeyRotationState.idle);
    expect(await keyManager.getMainKey(), newKey);
    await newService.close();
  });

  test('Interruption with temp key absent (Blind clear should not corrupt if DB rekey failed)', () async {
    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    await dbService.close();

    final oldKey = await keyManager.getMainKey();

    // Crash simulé avec state rekeying, MAIS la clé temporaire a été effacée
    await keyManager.setRotationState(KeyRotationState.rekeying);
    // tempKey n'est pas sauvegardée

    final newService = DatabaseService(keyManager, dbFile);
    await newService.initialize(); // DB still uses oldKey, so it should recover using mainKey!
    
    expect(await keyManager.getMainKey(), oldKey);
    await newService.close();
  });

  test('Neither key valid throws exception during recovery', () async {
    if (Platform.isWindows) return;
    final dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    await dbService.close(); // DB is encrypted with original mainKey

    // Simuler qu'un pirate a modifié la DB avec une 3eme clé
    // Impossible à simuler facilement avec drift sans sqlite3mc, on teste que si les deux clés dans le vault ne marchent pas, ça throw
    // Pour simuler cela, on change les deux clés du vault!
    await keyManager.setRotationState(KeyRotationState.rekeying);
    
    // Corrompre le vault en modifiant les deux clés
    final fakeMainKey = keyManager.generateNewKey();
    final fakeTempKey = keyManager.generateNewKey();
    
    FlutterSecureStorage.setMockInitialValues({
      'samtech_db_key_v1': fakeMainKey,
      'samtech_db_key_temp_v1': fakeTempKey,
      'samtech_db_key_state_v1': KeyRotationState.rekeying.name,
    });

    final newService = DatabaseService(keyManager, dbFile);
    expect(
      () async => await newService.initialize(),
      throwsA(anything) // Devrait throw l'erreur sqlite3mc vu qu'aucune clé ne marche
    );
  });
}
