import 'package:drift/drift.dart';

class Contacts extends Table {
  TextColumn get id => text()();
  TextColumn get organizationId => text()();
  TextColumn get phoneNormalized => text()();
  TextColumn get displayName => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get recordVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

class CommercialProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get organizationId => text()();
  TextColumn get contactId => text().customConstraint(
    'NOT NULL REFERENCES contacts(id) ON UPDATE RESTRICT ON DELETE CASCADE',
  )();
  TextColumn get prospectStatus => text()();
  IntColumn get firstContactAt => integer()();
  BoolColumn get isClient => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get recordVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
