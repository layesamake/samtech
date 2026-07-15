// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spk_db_001/spk_db_001.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration - Phase A: Init, Encrypt and Insert', (
    WidgetTester tester,
  ) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(docsDir.path, 'app_integration.db'));
    // Purge only in Phase A
    if (dbFile.existsSync()) {
      dbFile.deleteSync();
    }

    // Wipe keystore at start of Phase A to be clean
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    final keyManager = KeyManager();

    // 1. Initialisation (Création et chiffrement via Keystore)
    final key = await keyManager.getOrCreateKey();

    // 2. Calculer uniquement son empreinte SHA-256
    final keyBytes = utf8.encode(key);
    final keyHash = sha256.convert(keyBytes).toString();
    print('Key SHA-256 fingerprint: $keyHash');

    // 3. Créer une base réellement chiffrée
    var dbService = DatabaseService(keyManager, dbFile);
    await dbService.initialize();

    // 9. Vérifier que SQLite3MC est actif
    final sqlite3mcRes = await dbService.db
        .customSelect("SELECT sqlite3mc_config('cipher');")
        .get();
    expect(sqlite3mcRes, isNotEmpty);
    final cipherVal = sqlite3mcRes.first.data.values.first as String;
    expect(cipherVal, isNotEmpty);
    print('SQLite3MC active: true (cipher: $cipherVal)');

    // 4. Insérer NATIVE_TEST_MARKER
    await dbService.db
        .into(dbService.db.contacts)
        .insert(
          ContactsCompanion.insert(
            id: 'NATIVE_TEST_MARKER', // THE MARKER
            organizationId: 'org1',
            phoneNormalized: '123',
            createdAt: 1000,
            updatedAt: 1000,
          ),
        );

    // 5. Effectuer une véritable lecture
    final contacts = await dbService.db.select(dbService.db.contacts).get();
    expect(contacts.any((c) => c.id == 'NATIVE_TEST_MARKER'), true);

    // 6. Fermer complètement la base
    await dbService.close();

    // 7. Vérifier que les premiers octets ne correspondent pas à SQLite format 3
    final fileBytes = await dbFile.readAsBytes();
    final headerStr = String.fromCharCodes(fileBytes.take(16));
    expect(headerStr, isNot(equals('SQLite format 3\x00')));
    print('First 16 bytes match SQLite format 3: false');

    // 8. Vérifier que NATIVE_TEST_MARKER n’apparaît pas dans le fichier brut
    // Convert bytes using latin1 to avoid utf8 decoding errors of encrypted random bytes
    final fileContentStr = latin1.decode(fileBytes);
    expect(fileContentStr.contains('NATIVE_TEST_MARKER'), false);
    print('NATIVE_TEST_MARKER found in raw file bytes: false');

    // 10. Produire le résultat PHASE_A_OK
    print('PHASE_A_OK');
  });
}
