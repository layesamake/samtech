import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Contacts, CommercialProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2; // Increased to 2 for migration test

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            // Migration from v1 to v2: Add isClient column to CommercialProfiles
            await m.addColumn(commercialProfiles, commercialProfiles.isClient);
          }
        },
        beforeOpen: (details) async {
          // Additional setups if needed. Note: foreign_keys is handled in setup.
        },
      );

  Future<void> createContactTransaction(
      Contact contact, CommercialProfile profile) {
    return transaction(() async {
      await into(contacts).insert(contact);
      await into(commercialProfiles).insert(profile);
    });
  }
}

LazyDatabase openEncryptedConnection(File file, String passphrase) {
  return LazyDatabase(() async {
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        // sqlite3mc : setting the key
        rawDb.execute("PRAGMA key = '$passphrase';");
        // Enforce foreign keys
        rawDb.execute("PRAGMA foreign_keys = ON;");
        // Verify key by running a query
        rawDb.execute("PRAGMA user_version;");
      },
    );
  });
}
