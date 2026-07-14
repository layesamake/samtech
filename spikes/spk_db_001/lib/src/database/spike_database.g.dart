// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spike_database.dart';

// ignore_for_file: type=lint
class $PrototypeGroupsTable extends PrototypeGroups
    with TableInfo<$PrototypeGroupsTable, PrototypeGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrototypeGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prototype_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrototypeGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrototypeGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrototypeGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $PrototypeGroupsTable createAlias(String alias) {
    return $PrototypeGroupsTable(attachedDatabase, alias);
  }
}

class PrototypeGroup extends DataClass implements Insertable<PrototypeGroup> {
  final int id;
  final String label;
  const PrototypeGroup({required this.id, required this.label});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    return map;
  }

  PrototypeGroupsCompanion toCompanion(bool nullToAbsent) {
    return PrototypeGroupsCompanion(id: Value(id), label: Value(label));
  }

  factory PrototypeGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrototypeGroup(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
    };
  }

  PrototypeGroup copyWith({int? id, String? label}) =>
      PrototypeGroup(id: id ?? this.id, label: label ?? this.label);
  PrototypeGroup copyWithCompanion(PrototypeGroupsCompanion data) {
    return PrototypeGroup(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrototypeGroup(')
          ..write('id: $id, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrototypeGroup &&
          other.id == this.id &&
          other.label == this.label);
}

class PrototypeGroupsCompanion extends UpdateCompanion<PrototypeGroup> {
  final Value<int> id;
  final Value<String> label;
  const PrototypeGroupsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
  });
  PrototypeGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String label,
  }) : label = Value(label);
  static Insertable<PrototypeGroup> custom({
    Expression<int>? id,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
    });
  }

  PrototypeGroupsCompanion copyWith({Value<int>? id, Value<String>? label}) {
    return PrototypeGroupsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrototypeGroupsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $PrototypeEntriesTable extends PrototypeEntries
    with TableInfo<$PrototypeEntriesTable, PrototypeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrototypeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prototype_groups (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 512,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, groupId, payload, createdAt, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prototype_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrototypeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrototypeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrototypeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PrototypeEntriesTable createAlias(String alias) {
    return $PrototypeEntriesTable(attachedDatabase, alias);
  }
}

class PrototypeEntry extends DataClass implements Insertable<PrototypeEntry> {
  final int id;
  final int groupId;
  final String payload;
  final DateTime createdAt;
  final String? note;
  const PrototypeEntry({
    required this.id,
    required this.groupId,
    required this.payload,
    required this.createdAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PrototypeEntriesCompanion toCompanion(bool nullToAbsent) {
    return PrototypeEntriesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      payload: Value(payload),
      createdAt: Value(createdAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PrototypeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrototypeEntry(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  PrototypeEntry copyWith({
    int? id,
    int? groupId,
    String? payload,
    DateTime? createdAt,
    Value<String?> note = const Value.absent(),
  }) => PrototypeEntry(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    note: note.present ? note.value : this.note,
  );
  PrototypeEntry copyWithCompanion(PrototypeEntriesCompanion data) {
    return PrototypeEntry(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrototypeEntry(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, payload, createdAt, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrototypeEntry &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.note == this.note);
}

class PrototypeEntriesCompanion extends UpdateCompanion<PrototypeEntry> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<String?> note;
  const PrototypeEntriesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.note = const Value.absent(),
  });
  PrototypeEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String payload,
    required DateTime createdAt,
    this.note = const Value.absent(),
  }) : groupId = Value(groupId),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<PrototypeEntry> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (note != null) 'note': note,
    });
  }

  PrototypeEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<String?>? note,
  }) {
    return PrototypeEntriesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrototypeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$SpikeDatabase extends GeneratedDatabase {
  _$SpikeDatabase(QueryExecutor e) : super(e);
  $SpikeDatabaseManager get managers => $SpikeDatabaseManager(this);
  late final $PrototypeGroupsTable prototypeGroups = $PrototypeGroupsTable(
    this,
  );
  late final $PrototypeEntriesTable prototypeEntries = $PrototypeEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    prototypeGroups,
    prototypeEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'prototype_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('prototype_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PrototypeGroupsTableCreateCompanionBuilder =
    PrototypeGroupsCompanion Function({Value<int> id, required String label});
typedef $$PrototypeGroupsTableUpdateCompanionBuilder =
    PrototypeGroupsCompanion Function({Value<int> id, Value<String> label});

final class $$PrototypeGroupsTableReferences
    extends
        BaseReferences<_$SpikeDatabase, $PrototypeGroupsTable, PrototypeGroup> {
  $$PrototypeGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PrototypeEntriesTable, List<PrototypeEntry>>
  _prototypeEntriesRefsTable(_$SpikeDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.prototypeEntries,
        aliasName: 'prototype_groups__id__prototype_entries__group_id',
      );

  $$PrototypeEntriesTableProcessedTableManager get prototypeEntriesRefs {
    final manager = $$PrototypeEntriesTableTableManager(
      $_db,
      $_db.prototypeEntries,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _prototypeEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PrototypeGroupsTableFilterComposer
    extends Composer<_$SpikeDatabase, $PrototypeGroupsTable> {
  $$PrototypeGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> prototypeEntriesRefs(
    Expression<bool> Function($$PrototypeEntriesTableFilterComposer f) f,
  ) {
    final $$PrototypeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.prototypeEntries,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrototypeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.prototypeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrototypeGroupsTableOrderingComposer
    extends Composer<_$SpikeDatabase, $PrototypeGroupsTable> {
  $$PrototypeGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrototypeGroupsTableAnnotationComposer
    extends Composer<_$SpikeDatabase, $PrototypeGroupsTable> {
  $$PrototypeGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  Expression<T> prototypeEntriesRefs<T extends Object>(
    Expression<T> Function($$PrototypeEntriesTableAnnotationComposer a) f,
  ) {
    final $$PrototypeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.prototypeEntries,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrototypeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.prototypeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrototypeGroupsTableTableManager
    extends
        RootTableManager<
          _$SpikeDatabase,
          $PrototypeGroupsTable,
          PrototypeGroup,
          $$PrototypeGroupsTableFilterComposer,
          $$PrototypeGroupsTableOrderingComposer,
          $$PrototypeGroupsTableAnnotationComposer,
          $$PrototypeGroupsTableCreateCompanionBuilder,
          $$PrototypeGroupsTableUpdateCompanionBuilder,
          (PrototypeGroup, $$PrototypeGroupsTableReferences),
          PrototypeGroup,
          PrefetchHooks Function({bool prototypeEntriesRefs})
        > {
  $$PrototypeGroupsTableTableManager(
    _$SpikeDatabase db,
    $PrototypeGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrototypeGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrototypeGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrototypeGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
              }) => PrototypeGroupsCompanion(id: id, label: label),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String label}) =>
                  PrototypeGroupsCompanion.insert(id: id, label: label),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrototypeGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({prototypeEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (prototypeEntriesRefs) db.prototypeEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (prototypeEntriesRefs)
                    await $_getPrefetchedData<
                      PrototypeGroup,
                      $PrototypeGroupsTable,
                      PrototypeEntry
                    >(
                      currentTable: table,
                      referencedTable: $$PrototypeGroupsTableReferences
                          ._prototypeEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PrototypeGroupsTableReferences(
                            db,
                            table,
                            p0,
                          ).prototypeEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PrototypeGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$SpikeDatabase,
      $PrototypeGroupsTable,
      PrototypeGroup,
      $$PrototypeGroupsTableFilterComposer,
      $$PrototypeGroupsTableOrderingComposer,
      $$PrototypeGroupsTableAnnotationComposer,
      $$PrototypeGroupsTableCreateCompanionBuilder,
      $$PrototypeGroupsTableUpdateCompanionBuilder,
      (PrototypeGroup, $$PrototypeGroupsTableReferences),
      PrototypeGroup,
      PrefetchHooks Function({bool prototypeEntriesRefs})
    >;
typedef $$PrototypeEntriesTableCreateCompanionBuilder =
    PrototypeEntriesCompanion Function({
      Value<int> id,
      required int groupId,
      required String payload,
      required DateTime createdAt,
      Value<String?> note,
    });
typedef $$PrototypeEntriesTableUpdateCompanionBuilder =
    PrototypeEntriesCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<String?> note,
    });

final class $$PrototypeEntriesTableReferences
    extends
        BaseReferences<
          _$SpikeDatabase,
          $PrototypeEntriesTable,
          PrototypeEntry
        > {
  $$PrototypeEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PrototypeGroupsTable _groupIdTable(_$SpikeDatabase db) => db
      .prototypeGroups
      .createAlias('prototype_entries__group_id__prototype_groups__id');

  $$PrototypeGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$PrototypeGroupsTableTableManager(
      $_db,
      $_db.prototypeGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PrototypeEntriesTableFilterComposer
    extends Composer<_$SpikeDatabase, $PrototypeEntriesTable> {
  $$PrototypeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PrototypeGroupsTableFilterComposer get groupId {
    final $$PrototypeGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.prototypeGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrototypeGroupsTableFilterComposer(
            $db: $db,
            $table: $db.prototypeGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrototypeEntriesTableOrderingComposer
    extends Composer<_$SpikeDatabase, $PrototypeEntriesTable> {
  $$PrototypeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PrototypeGroupsTableOrderingComposer get groupId {
    final $$PrototypeGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.prototypeGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrototypeGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.prototypeGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrototypeEntriesTableAnnotationComposer
    extends Composer<_$SpikeDatabase, $PrototypeEntriesTable> {
  $$PrototypeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PrototypeGroupsTableAnnotationComposer get groupId {
    final $$PrototypeGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.prototypeGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrototypeGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.prototypeGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrototypeEntriesTableTableManager
    extends
        RootTableManager<
          _$SpikeDatabase,
          $PrototypeEntriesTable,
          PrototypeEntry,
          $$PrototypeEntriesTableFilterComposer,
          $$PrototypeEntriesTableOrderingComposer,
          $$PrototypeEntriesTableAnnotationComposer,
          $$PrototypeEntriesTableCreateCompanionBuilder,
          $$PrototypeEntriesTableUpdateCompanionBuilder,
          (PrototypeEntry, $$PrototypeEntriesTableReferences),
          PrototypeEntry,
          PrefetchHooks Function({bool groupId})
        > {
  $$PrototypeEntriesTableTableManager(
    _$SpikeDatabase db,
    $PrototypeEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrototypeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrototypeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrototypeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => PrototypeEntriesCompanion(
                id: id,
                groupId: groupId,
                payload: payload,
                createdAt: createdAt,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required String payload,
                required DateTime createdAt,
                Value<String?> note = const Value.absent(),
              }) => PrototypeEntriesCompanion.insert(
                id: id,
                groupId: groupId,
                payload: payload,
                createdAt: createdAt,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrototypeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable:
                                    $$PrototypeEntriesTableReferences
                                        ._groupIdTable(db),
                                referencedColumn:
                                    $$PrototypeEntriesTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PrototypeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$SpikeDatabase,
      $PrototypeEntriesTable,
      PrototypeEntry,
      $$PrototypeEntriesTableFilterComposer,
      $$PrototypeEntriesTableOrderingComposer,
      $$PrototypeEntriesTableAnnotationComposer,
      $$PrototypeEntriesTableCreateCompanionBuilder,
      $$PrototypeEntriesTableUpdateCompanionBuilder,
      (PrototypeEntry, $$PrototypeEntriesTableReferences),
      PrototypeEntry,
      PrefetchHooks Function({bool groupId})
    >;

class $SpikeDatabaseManager {
  final _$SpikeDatabase _db;
  $SpikeDatabaseManager(this._db);
  $$PrototypeGroupsTableTableManager get prototypeGroups =>
      $$PrototypeGroupsTableTableManager(_db, _db.prototypeGroups);
  $$PrototypeEntriesTableTableManager get prototypeEntries =>
      $$PrototypeEntriesTableTableManager(_db, _db.prototypeEntries);
}
