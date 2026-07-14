import 'package:drift/drift.dart';

part 'spike_database.g.dart';

class PrototypeGroups extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text().withLength(min: 1, max: 80)();
}

class PrototypeEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get groupId =>
      integer().references(PrototypeGroups, #id, onDelete: KeyAction.cascade)();

  TextColumn get payload => text().withLength(min: 1, max: 512)();

  DateTimeColumn get createdAt => dateTime()();

  TextColumn get note => text().nullable()();
}

@DriftDatabase(tables: [PrototypeGroups, PrototypeEntries])
class SpikeDatabase extends _$SpikeDatabase {
  SpikeDatabase(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(prototypeEntries, prototypeEntries.note);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
      if (details.hadUpgrade) {
        final violations = await customSelect(
          'PRAGMA foreign_key_check;',
        ).get();
        if (violations.isNotEmpty) {
          throw StateError('Foreign-key violations found after migration.');
        }
      }
    },
  );

  Future<int> createGroup(String label) => into(
    prototypeGroups,
  ).insert(PrototypeGroupsCompanion.insert(label: label));

  Future<int> createEntry({
    required int groupId,
    required String payload,
    String? note,
  }) => into(prototypeEntries).insert(
    PrototypeEntriesCompanion.insert(
      groupId: groupId,
      payload: payload,
      createdAt: DateTime.now().toUtc(),
      note: Value(note),
    ),
  );

  Future<int> entryCount() async {
    final countExpression = prototypeEntries.id.count();
    final query = selectOnly(prototypeEntries)..addColumns([countExpression]);
    return (await query.getSingle()).read(countExpression) ?? 0;
  }
}
