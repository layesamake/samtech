import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spk_db_001/spk_db_001.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart' as drift;
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  late Directory tempDir;
  late File dbFile;
  late KeyManager keyManager;
  late DatabaseService dbService;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('spk_db_001_test_trans');
    dbFile = File(p.join(tempDir.path, 'app.db'));
    keyManager = KeyManager();
    dbService = DatabaseService(keyManager, dbFile);
  });

  tearDown(() async {
    await dbService.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('Foreign key constraints are enforced', () async {
    await dbService.initialize();

    // Attempt to insert profile without existing contact
    expect(
      () async => await dbService.db
          .into(dbService.db.commercialProfiles)
          .insert(
            CommercialProfilesCompanion.insert(
              id: 'p1',
              organizationId: 'org1',
              contactId: 'c1', // Non-existent
              prospectStatus: 'new',
              firstContactAt: 1000,
              createdAt: 1000,
              updatedAt: 1000,
            ),
          ),
      throwsA(anything),
    );
  });

  test('Transactions can be rolled back on error', () async {
    await dbService.initialize();

    final contact = Contact(
      id: 'c1',
      organizationId: 'org1',
      phoneNormalized: '123',
      createdAt: 1000,
      updatedAt: 1000,
      recordVersion: 1,
    );

    // Profile with invalid FK to trigger failure
    final profile = CommercialProfile(
      id: 'p1',
      organizationId: 'org1',
      contactId: 'c2', // Non-existent
      prospectStatus: 'new',
      firstContactAt: 1000,
      createdAt: 1000,
      updatedAt: 1000,
      isClient: false,
      recordVersion: 1,
    );

    try {
      await dbService.db.createContactTransaction(contact, profile);
    } catch (_) {}

    final contacts = await dbService.db.select(dbService.db.contacts).get();
    expect(
      contacts,
      isEmpty,
      reason:
          'Contact should not have been inserted because transaction rolled back',
    );
  });

  test('Migration from schema v1 to v2', () async {
    // 1. Create a raw SQLite v1 database directly
    final key = await keyManager.getOrCreateKey();

    final rawDb = sqlite.sqlite3.open(dbFile.path);
    rawDb.execute("PRAGMA key = '$key';");
    rawDb.execute(
      'CREATE TABLE contacts (id TEXT NOT NULL, organization_id TEXT NOT NULL, phone_normalized TEXT NOT NULL, display_name TEXT, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, record_version INTEGER NOT NULL DEFAULT 1, PRIMARY KEY (id));',
    );
    rawDb.execute(
      'CREATE TABLE commercial_profiles (id TEXT NOT NULL, organization_id TEXT NOT NULL, contact_id TEXT NOT NULL REFERENCES contacts(id) ON UPDATE RESTRICT ON DELETE CASCADE, prospect_status TEXT NOT NULL, first_contact_at INTEGER NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, record_version INTEGER NOT NULL DEFAULT 1, PRIMARY KEY (id));',
    );
    rawDb.execute('PRAGMA user_version = 1;');
    rawDb.close();

    // 2. Open via AppDatabase (which is v2 and handles migration)
    final appDb = AppDatabase(openEncryptedConnection(dbFile, key));

    // Test that we can insert a profile with the new column
    await appDb
        .into(appDb.contacts)
        .insert(
          ContactsCompanion.insert(
            id: 'c1',
            organizationId: 'org1',
            phoneNormalized: '123',
            createdAt: 1,
            updatedAt: 1,
          ),
        );
    await appDb
        .into(appDb.commercialProfiles)
        .insert(
          CommercialProfilesCompanion.insert(
            id: 'p1',
            organizationId: 'org1',
            contactId: 'c1',
            prospectStatus: 'new',
            firstContactAt: 1,
            isClient: const drift.Value(true),
            createdAt: 1,
            updatedAt: 1,
          ),
        );

    final profiles = await appDb.select(appDb.commercialProfiles).get();
    expect(profiles.length, 1);
    expect(profiles.first.isClient, true);

    await appDb.close();
  });
}
