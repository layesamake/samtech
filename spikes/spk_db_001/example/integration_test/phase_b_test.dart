// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spk_db_001/spk_db_001.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration - Phase B: Open and Check Persistence', (
    WidgetTester tester,
  ) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(docsDir.path, 'app_integration.db'));

    expect(
      dbFile.existsSync(),
      true,
      reason: 'La base de la Phase A devrait exister.',
    );

    final keyManager = KeyManager();
    final mainKey = await keyManager.getMainKey();
    expect(
      mainKey,
      isNotNull,
      reason: 'La clé de la Phase A devrait exister dans le Keystore.',
    );

    final keyBytes = utf8.encode(mainKey!);
    final keyHash = sha256.convert(keyBytes).toString();
    print('Key SHA-256 fingerprint: $keyHash');

    // 1. Initialisation
    var dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize(); // Ne doit pas générer de nouvelle clé

    // Vérification du marqueur de la phase A
    final contacts = await dbService.db.select(dbService.db.contacts).get();
    expect(
      contacts.any((c) => c.id == 'NATIVE_TEST_MARKER'),
      true,
      reason: 'Le marqueur de la Phase A doit être présent.',
    );

    // Test transaction & rollback
    try {
      await dbService.db.createContactTransaction(
        Contact(
          id: 'c2',
          organizationId: 'org1',
          phoneNormalized: '456',
          createdAt: 1,
          updatedAt: 1,
          recordVersion: 1,
        ),
        // CommercialProfile with DIFFERENT contactId to trigger Foreign Key error
        CommercialProfile(
          id: 'p2',
          organizationId: 'org1',
          contactId: 'UNKNOWN',
          prospectStatus: 'new',
          firstContactAt: 1,
          isClient: true,
          createdAt: 1,
          updatedAt: 1,
          recordVersion: 1,
        ),
      );
      fail('Devrait throw FK constraint error');
    } catch (e) {
      expect(e.toString(), contains('FOREIGN KEY constraint failed'));
    }

    final rolledBack = await dbService.db.select(dbService.db.contacts).get();
    expect(
      rolledBack.any((c) => c.id == 'c2'),
      false,
      reason: 'Transaction doit être rolled back',
    );

    await dbService.close();

    // Test refus d'ouverture avec mauvaise clé
    final wrongDb = AppDatabase(openEncryptedConnection(dbFile, 'wrong_key'));
    await expectLater(
      () async => await wrongDb.customSelect('SELECT 1').get(),
      throwsA(anything),
    );
    await wrongDb.close();

    // Test refus fermé lorsque clé est absente
    // On simule une perte de clé en supprimant temporairement l'entrée du vault.
    // SÉCURITÉ : oldKey contient la valeur brute — ne jamais l'afficher (print/log).
    // Seule son empreinte SHA-256 peut être tracée.
    const storage = FlutterSecureStorage();
    final oldKey = await storage.read(key: 'samtech_db_key_v1');
    expect(oldKey, isNotNull);
    await storage.delete(key: 'samtech_db_key_v1');
    final checkKeyInStorage = await storage.read(key: 'samtech_db_key_v1');
    expect(checkKeyInStorage, isNull);
    final checkKeyInKM = await keyManager.getMainKey();
    expect(checkKeyInKM, isNull);
    print('KEY_LOSS_FAIL_SAFE_OK');

    final failingDbService = DatabaseService(keyManager, dbFile);
    await expectLater(
      () async => await failingDbService.initialize(),
      throwsException, // DatabaseKeyLostException
    );

    // Restaurer la clé pour la suite
    // SÉCURITÉ : oldKey n'est utilisé qu'en interne, jamais affiché.
    await storage.write(key: 'samtech_db_key_v1', value: oldKey);

    // Rotation réelle
    dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    await dbService.rotateKey();
    await dbService.close();

    final newKey = await keyManager.getMainKey();
    // SÉCURITÉ : newKey contient la valeur brute — ne jamais l'afficher.
    // On vérifie uniquement que la rotation a produit une clé non nulle et différente.
    expect(newKey, isNotNull);
    expect(newKey, isNot(equals(oldKey)));

    // Tracer uniquement l'empreinte SHA-256 de la nouvelle clé
    final newKeyBytes = utf8.encode(newKey!);
    final newKeyHash = sha256.convert(newKeyBytes).toString();
    print('New key SHA-256 fingerprint (post-rotation): $newKeyHash');

    // Rejet de l'ancienne clé
    final oldDb = AppDatabase(openEncryptedConnection(dbFile, oldKey!));
    await expectLater(
      () async => await oldDb.customSelect('SELECT 1').get(),
      throwsA(anything),
    );
    await oldDb.close();

    // Ouverture avec la nouvelle clé
    dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();
    final contactsAfterRotation = await dbService.db
        .select(dbService.db.contacts)
        .get();
    expect(
      contactsAfterRotation.any((c) => c.id == 'NATIVE_TEST_MARKER'),
      true,
    );
    await dbService.close();

    print('PHASE_B_OK');
  });
}
