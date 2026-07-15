// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNormalizedMeta = const VerificationMeta(
    'phoneNormalized',
  );
  @override
  late final GeneratedColumn<String> phoneNormalized = GeneratedColumn<String>(
    'phone_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordVersionMeta = const VerificationMeta(
    'recordVersion',
  );
  @override
  late final GeneratedColumn<int> recordVersion = GeneratedColumn<int>(
    'record_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizationId,
    phoneNormalized,
    displayName,
    createdAt,
    updatedAt,
    recordVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('phone_normalized')) {
      context.handle(
        _phoneNormalizedMeta,
        phoneNormalized.isAcceptableOrUnknown(
          data['phone_normalized']!,
          _phoneNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNormalizedMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('record_version')) {
      context.handle(
        _recordVersionMeta,
        recordVersion.isAcceptableOrUnknown(
          data['record_version']!,
          _recordVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      )!,
      phoneNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_normalized'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      recordVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_version'],
      )!,
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final String id;
  final String organizationId;
  final String phoneNormalized;
  final String? displayName;
  final int createdAt;
  final int updatedAt;
  final int recordVersion;
  const Contact({
    required this.id,
    required this.organizationId,
    required this.phoneNormalized,
    this.displayName,
    required this.createdAt,
    required this.updatedAt,
    required this.recordVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['organization_id'] = Variable<String>(organizationId);
    map['phone_normalized'] = Variable<String>(phoneNormalized);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['record_version'] = Variable<int>(recordVersion);
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      organizationId: Value(organizationId),
      phoneNormalized: Value(phoneNormalized),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      recordVersion: Value(recordVersion),
    );
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<String>(json['id']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      phoneNormalized: serializer.fromJson<String>(json['phoneNormalized']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      recordVersion: serializer.fromJson<int>(json['recordVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'organizationId': serializer.toJson<String>(organizationId),
      'phoneNormalized': serializer.toJson<String>(phoneNormalized),
      'displayName': serializer.toJson<String?>(displayName),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'recordVersion': serializer.toJson<int>(recordVersion),
    };
  }

  Contact copyWith({
    String? id,
    String? organizationId,
    String? phoneNormalized,
    Value<String?> displayName = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    int? recordVersion,
  }) => Contact(
    id: id ?? this.id,
    organizationId: organizationId ?? this.organizationId,
    phoneNormalized: phoneNormalized ?? this.phoneNormalized,
    displayName: displayName.present ? displayName.value : this.displayName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    recordVersion: recordVersion ?? this.recordVersion,
  );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      phoneNormalized: data.phoneNormalized.present
          ? data.phoneNormalized.value
          : this.phoneNormalized,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      recordVersion: data.recordVersion.present
          ? data.recordVersion.value
          : this.recordVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('phoneNormalized: $phoneNormalized, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('recordVersion: $recordVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizationId,
    phoneNormalized,
    displayName,
    createdAt,
    updatedAt,
    recordVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.phoneNormalized == this.phoneNormalized &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.recordVersion == this.recordVersion);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<String> id;
  final Value<String> organizationId;
  final Value<String> phoneNormalized;
  final Value<String?> displayName;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> recordVersion;
  final Value<int> rowid;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.phoneNormalized = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.recordVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactsCompanion.insert({
    required String id,
    required String organizationId,
    required String phoneNormalized,
    this.displayName = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.recordVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       organizationId = Value(organizationId),
       phoneNormalized = Value(phoneNormalized),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Contact> custom({
    Expression<String>? id,
    Expression<String>? organizationId,
    Expression<String>? phoneNormalized,
    Expression<String>? displayName,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? recordVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (phoneNormalized != null) 'phone_normalized': phoneNormalized,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (recordVersion != null) 'record_version': recordVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactsCompanion copyWith({
    Value<String>? id,
    Value<String>? organizationId,
    Value<String>? phoneNormalized,
    Value<String?>? displayName,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? recordVersion,
    Value<int>? rowid,
  }) {
    return ContactsCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      phoneNormalized: phoneNormalized ?? this.phoneNormalized,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      recordVersion: recordVersion ?? this.recordVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (phoneNormalized.present) {
      map['phone_normalized'] = Variable<String>(phoneNormalized.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (recordVersion.present) {
      map['record_version'] = Variable<int>(recordVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('phoneNormalized: $phoneNormalized, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('recordVersion: $recordVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommercialProfilesTable extends CommercialProfiles
    with TableInfo<$CommercialProfilesTable, CommercialProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommercialProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactIdMeta = const VerificationMeta(
    'contactId',
  );
  @override
  late final GeneratedColumn<String> contactId = GeneratedColumn<String>(
    'contact_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL REFERENCES contacts(id) ON UPDATE RESTRICT ON DELETE CASCADE',
  );
  static const VerificationMeta _prospectStatusMeta = const VerificationMeta(
    'prospectStatus',
  );
  @override
  late final GeneratedColumn<String> prospectStatus = GeneratedColumn<String>(
    'prospect_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstContactAtMeta = const VerificationMeta(
    'firstContactAt',
  );
  @override
  late final GeneratedColumn<int> firstContactAt = GeneratedColumn<int>(
    'first_contact_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isClientMeta = const VerificationMeta(
    'isClient',
  );
  @override
  late final GeneratedColumn<bool> isClient = GeneratedColumn<bool>(
    'is_client',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_client" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordVersionMeta = const VerificationMeta(
    'recordVersion',
  );
  @override
  late final GeneratedColumn<int> recordVersion = GeneratedColumn<int>(
    'record_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizationId,
    contactId,
    prospectStatus,
    firstContactAt,
    isClient,
    createdAt,
    updatedAt,
    recordVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'commercial_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommercialProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('contact_id')) {
      context.handle(
        _contactIdMeta,
        contactId.isAcceptableOrUnknown(data['contact_id']!, _contactIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contactIdMeta);
    }
    if (data.containsKey('prospect_status')) {
      context.handle(
        _prospectStatusMeta,
        prospectStatus.isAcceptableOrUnknown(
          data['prospect_status']!,
          _prospectStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prospectStatusMeta);
    }
    if (data.containsKey('first_contact_at')) {
      context.handle(
        _firstContactAtMeta,
        firstContactAt.isAcceptableOrUnknown(
          data['first_contact_at']!,
          _firstContactAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstContactAtMeta);
    }
    if (data.containsKey('is_client')) {
      context.handle(
        _isClientMeta,
        isClient.isAcceptableOrUnknown(data['is_client']!, _isClientMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('record_version')) {
      context.handle(
        _recordVersionMeta,
        recordVersion.isAcceptableOrUnknown(
          data['record_version']!,
          _recordVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommercialProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommercialProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      )!,
      contactId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_id'],
      )!,
      prospectStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prospect_status'],
      )!,
      firstContactAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_contact_at'],
      )!,
      isClient: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_client'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      recordVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_version'],
      )!,
    );
  }

  @override
  $CommercialProfilesTable createAlias(String alias) {
    return $CommercialProfilesTable(attachedDatabase, alias);
  }
}

class CommercialProfile extends DataClass
    implements Insertable<CommercialProfile> {
  final String id;
  final String organizationId;
  final String contactId;
  final String prospectStatus;
  final int firstContactAt;
  final bool isClient;
  final int createdAt;
  final int updatedAt;
  final int recordVersion;
  const CommercialProfile({
    required this.id,
    required this.organizationId,
    required this.contactId,
    required this.prospectStatus,
    required this.firstContactAt,
    required this.isClient,
    required this.createdAt,
    required this.updatedAt,
    required this.recordVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['organization_id'] = Variable<String>(organizationId);
    map['contact_id'] = Variable<String>(contactId);
    map['prospect_status'] = Variable<String>(prospectStatus);
    map['first_contact_at'] = Variable<int>(firstContactAt);
    map['is_client'] = Variable<bool>(isClient);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['record_version'] = Variable<int>(recordVersion);
    return map;
  }

  CommercialProfilesCompanion toCompanion(bool nullToAbsent) {
    return CommercialProfilesCompanion(
      id: Value(id),
      organizationId: Value(organizationId),
      contactId: Value(contactId),
      prospectStatus: Value(prospectStatus),
      firstContactAt: Value(firstContactAt),
      isClient: Value(isClient),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      recordVersion: Value(recordVersion),
    );
  }

  factory CommercialProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommercialProfile(
      id: serializer.fromJson<String>(json['id']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      contactId: serializer.fromJson<String>(json['contactId']),
      prospectStatus: serializer.fromJson<String>(json['prospectStatus']),
      firstContactAt: serializer.fromJson<int>(json['firstContactAt']),
      isClient: serializer.fromJson<bool>(json['isClient']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      recordVersion: serializer.fromJson<int>(json['recordVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'organizationId': serializer.toJson<String>(organizationId),
      'contactId': serializer.toJson<String>(contactId),
      'prospectStatus': serializer.toJson<String>(prospectStatus),
      'firstContactAt': serializer.toJson<int>(firstContactAt),
      'isClient': serializer.toJson<bool>(isClient),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'recordVersion': serializer.toJson<int>(recordVersion),
    };
  }

  CommercialProfile copyWith({
    String? id,
    String? organizationId,
    String? contactId,
    String? prospectStatus,
    int? firstContactAt,
    bool? isClient,
    int? createdAt,
    int? updatedAt,
    int? recordVersion,
  }) => CommercialProfile(
    id: id ?? this.id,
    organizationId: organizationId ?? this.organizationId,
    contactId: contactId ?? this.contactId,
    prospectStatus: prospectStatus ?? this.prospectStatus,
    firstContactAt: firstContactAt ?? this.firstContactAt,
    isClient: isClient ?? this.isClient,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    recordVersion: recordVersion ?? this.recordVersion,
  );
  CommercialProfile copyWithCompanion(CommercialProfilesCompanion data) {
    return CommercialProfile(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      contactId: data.contactId.present ? data.contactId.value : this.contactId,
      prospectStatus: data.prospectStatus.present
          ? data.prospectStatus.value
          : this.prospectStatus,
      firstContactAt: data.firstContactAt.present
          ? data.firstContactAt.value
          : this.firstContactAt,
      isClient: data.isClient.present ? data.isClient.value : this.isClient,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      recordVersion: data.recordVersion.present
          ? data.recordVersion.value
          : this.recordVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommercialProfile(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('contactId: $contactId, ')
          ..write('prospectStatus: $prospectStatus, ')
          ..write('firstContactAt: $firstContactAt, ')
          ..write('isClient: $isClient, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('recordVersion: $recordVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizationId,
    contactId,
    prospectStatus,
    firstContactAt,
    isClient,
    createdAt,
    updatedAt,
    recordVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommercialProfile &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.contactId == this.contactId &&
          other.prospectStatus == this.prospectStatus &&
          other.firstContactAt == this.firstContactAt &&
          other.isClient == this.isClient &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.recordVersion == this.recordVersion);
}

class CommercialProfilesCompanion extends UpdateCompanion<CommercialProfile> {
  final Value<String> id;
  final Value<String> organizationId;
  final Value<String> contactId;
  final Value<String> prospectStatus;
  final Value<int> firstContactAt;
  final Value<bool> isClient;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> recordVersion;
  final Value<int> rowid;
  const CommercialProfilesCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.contactId = const Value.absent(),
    this.prospectStatus = const Value.absent(),
    this.firstContactAt = const Value.absent(),
    this.isClient = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.recordVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommercialProfilesCompanion.insert({
    required String id,
    required String organizationId,
    required String contactId,
    required String prospectStatus,
    required int firstContactAt,
    this.isClient = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.recordVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       organizationId = Value(organizationId),
       contactId = Value(contactId),
       prospectStatus = Value(prospectStatus),
       firstContactAt = Value(firstContactAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CommercialProfile> custom({
    Expression<String>? id,
    Expression<String>? organizationId,
    Expression<String>? contactId,
    Expression<String>? prospectStatus,
    Expression<int>? firstContactAt,
    Expression<bool>? isClient,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? recordVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (contactId != null) 'contact_id': contactId,
      if (prospectStatus != null) 'prospect_status': prospectStatus,
      if (firstContactAt != null) 'first_contact_at': firstContactAt,
      if (isClient != null) 'is_client': isClient,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (recordVersion != null) 'record_version': recordVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommercialProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? organizationId,
    Value<String>? contactId,
    Value<String>? prospectStatus,
    Value<int>? firstContactAt,
    Value<bool>? isClient,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? recordVersion,
    Value<int>? rowid,
  }) {
    return CommercialProfilesCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      contactId: contactId ?? this.contactId,
      prospectStatus: prospectStatus ?? this.prospectStatus,
      firstContactAt: firstContactAt ?? this.firstContactAt,
      isClient: isClient ?? this.isClient,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      recordVersion: recordVersion ?? this.recordVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (contactId.present) {
      map['contact_id'] = Variable<String>(contactId.value);
    }
    if (prospectStatus.present) {
      map['prospect_status'] = Variable<String>(prospectStatus.value);
    }
    if (firstContactAt.present) {
      map['first_contact_at'] = Variable<int>(firstContactAt.value);
    }
    if (isClient.present) {
      map['is_client'] = Variable<bool>(isClient.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (recordVersion.present) {
      map['record_version'] = Variable<int>(recordVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommercialProfilesCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('contactId: $contactId, ')
          ..write('prospectStatus: $prospectStatus, ')
          ..write('firstContactAt: $firstContactAt, ')
          ..write('isClient: $isClient, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('recordVersion: $recordVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $CommercialProfilesTable commercialProfiles =
      $CommercialProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    contacts,
    commercialProfiles,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contacts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('commercial_profiles', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ContactsTableCreateCompanionBuilder =
    ContactsCompanion Function({
      required String id,
      required String organizationId,
      required String phoneNormalized,
      Value<String?> displayName,
      required int createdAt,
      required int updatedAt,
      Value<int> recordVersion,
      Value<int> rowid,
    });
typedef $$ContactsTableUpdateCompanionBuilder =
    ContactsCompanion Function({
      Value<String> id,
      Value<String> organizationId,
      Value<String> phoneNormalized,
      Value<String?> displayName,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> recordVersion,
      Value<int> rowid,
    });

final class $$ContactsTableReferences
    extends BaseReferences<_$AppDatabase, $ContactsTable, Contact> {
  $$ContactsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CommercialProfilesTable, List<CommercialProfile>>
  _commercialProfilesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.commercialProfiles,
        aliasName: 'contacts__id__commercial_profiles__contact_id',
      );

  $$CommercialProfilesTableProcessedTableManager get commercialProfilesRefs {
    final manager = $$CommercialProfilesTableTableManager(
      $_db,
      $_db.commercialProfiles,
    ).filter((f) => f.contactId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _commercialProfilesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNormalized => $composableBuilder(
    column: $table.phoneNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> commercialProfilesRefs(
    Expression<bool> Function($$CommercialProfilesTableFilterComposer f) f,
  ) {
    final $$CommercialProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.commercialProfiles,
      getReferencedColumn: (t) => t.contactId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommercialProfilesTableFilterComposer(
            $db: $db,
            $table: $db.commercialProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNormalized => $composableBuilder(
    column: $table.phoneNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneNormalized => $composableBuilder(
    column: $table.phoneNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => column,
  );

  Expression<T> commercialProfilesRefs<T extends Object>(
    Expression<T> Function($$CommercialProfilesTableAnnotationComposer a) f,
  ) {
    final $$CommercialProfilesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.commercialProfiles,
          getReferencedColumn: (t) => t.contactId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CommercialProfilesTableAnnotationComposer(
                $db: $db,
                $table: $db.commercialProfiles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, $$ContactsTableReferences),
          Contact,
          PrefetchHooks Function({bool commercialProfilesRefs})
        > {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> organizationId = const Value.absent(),
                Value<String> phoneNormalized = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> recordVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion(
                id: id,
                organizationId: organizationId,
                phoneNormalized: phoneNormalized,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                recordVersion: recordVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String organizationId,
                required String phoneNormalized,
                Value<String?> displayName = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> recordVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion.insert(
                id: id,
                organizationId: organizationId,
                phoneNormalized: phoneNormalized,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                recordVersion: recordVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({commercialProfilesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (commercialProfilesRefs) db.commercialProfiles,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (commercialProfilesRefs)
                    await $_getPrefetchedData<
                      Contact,
                      $ContactsTable,
                      CommercialProfile
                    >(
                      currentTable: table,
                      referencedTable: $$ContactsTableReferences
                          ._commercialProfilesRefsTable(db),
                      managerFromTypedResult: (p0) => $$ContactsTableReferences(
                        db,
                        table,
                        p0,
                      ).commercialProfilesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.contactId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, $$ContactsTableReferences),
      Contact,
      PrefetchHooks Function({bool commercialProfilesRefs})
    >;
typedef $$CommercialProfilesTableCreateCompanionBuilder =
    CommercialProfilesCompanion Function({
      required String id,
      required String organizationId,
      required String contactId,
      required String prospectStatus,
      required int firstContactAt,
      Value<bool> isClient,
      required int createdAt,
      required int updatedAt,
      Value<int> recordVersion,
      Value<int> rowid,
    });
typedef $$CommercialProfilesTableUpdateCompanionBuilder =
    CommercialProfilesCompanion Function({
      Value<String> id,
      Value<String> organizationId,
      Value<String> contactId,
      Value<String> prospectStatus,
      Value<int> firstContactAt,
      Value<bool> isClient,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> recordVersion,
      Value<int> rowid,
    });

final class $$CommercialProfilesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CommercialProfilesTable,
          CommercialProfile
        > {
  $$CommercialProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContactsTable _contactIdTable(_$AppDatabase db) =>
      db.contacts.createAlias('commercial_profiles__contact_id__contacts__id');

  $$ContactsTableProcessedTableManager get contactId {
    final $_column = $_itemColumn<String>('contact_id')!;

    final manager = $$ContactsTableTableManager(
      $_db,
      $_db.contacts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contactIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CommercialProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $CommercialProfilesTable> {
  $$CommercialProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prospectStatus => $composableBuilder(
    column: $table.prospectStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstContactAt => $composableBuilder(
    column: $table.firstContactAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClient => $composableBuilder(
    column: $table.isClient,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => ColumnFilters(column),
  );

  $$ContactsTableFilterComposer get contactId {
    final $$ContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableFilterComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CommercialProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CommercialProfilesTable> {
  $$CommercialProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prospectStatus => $composableBuilder(
    column: $table.prospectStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstContactAt => $composableBuilder(
    column: $table.firstContactAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClient => $composableBuilder(
    column: $table.isClient,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContactsTableOrderingComposer get contactId {
    final $$ContactsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableOrderingComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CommercialProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommercialProfilesTable> {
  $$CommercialProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prospectStatus => $composableBuilder(
    column: $table.prospectStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstContactAt => $composableBuilder(
    column: $table.firstContactAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isClient =>
      $composableBuilder(column: $table.isClient, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get recordVersion => $composableBuilder(
    column: $table.recordVersion,
    builder: (column) => column,
  );

  $$ContactsTableAnnotationComposer get contactId {
    final $$ContactsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableAnnotationComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CommercialProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CommercialProfilesTable,
          CommercialProfile,
          $$CommercialProfilesTableFilterComposer,
          $$CommercialProfilesTableOrderingComposer,
          $$CommercialProfilesTableAnnotationComposer,
          $$CommercialProfilesTableCreateCompanionBuilder,
          $$CommercialProfilesTableUpdateCompanionBuilder,
          (CommercialProfile, $$CommercialProfilesTableReferences),
          CommercialProfile,
          PrefetchHooks Function({bool contactId})
        > {
  $$CommercialProfilesTableTableManager(
    _$AppDatabase db,
    $CommercialProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommercialProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommercialProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommercialProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> organizationId = const Value.absent(),
                Value<String> contactId = const Value.absent(),
                Value<String> prospectStatus = const Value.absent(),
                Value<int> firstContactAt = const Value.absent(),
                Value<bool> isClient = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> recordVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommercialProfilesCompanion(
                id: id,
                organizationId: organizationId,
                contactId: contactId,
                prospectStatus: prospectStatus,
                firstContactAt: firstContactAt,
                isClient: isClient,
                createdAt: createdAt,
                updatedAt: updatedAt,
                recordVersion: recordVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String organizationId,
                required String contactId,
                required String prospectStatus,
                required int firstContactAt,
                Value<bool> isClient = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> recordVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommercialProfilesCompanion.insert(
                id: id,
                organizationId: organizationId,
                contactId: contactId,
                prospectStatus: prospectStatus,
                firstContactAt: firstContactAt,
                isClient: isClient,
                createdAt: createdAt,
                updatedAt: updatedAt,
                recordVersion: recordVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CommercialProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contactId = false}) {
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
                    if (contactId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.contactId,
                                referencedTable:
                                    $$CommercialProfilesTableReferences
                                        ._contactIdTable(db),
                                referencedColumn:
                                    $$CommercialProfilesTableReferences
                                        ._contactIdTable(db)
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

typedef $$CommercialProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CommercialProfilesTable,
      CommercialProfile,
      $$CommercialProfilesTableFilterComposer,
      $$CommercialProfilesTableOrderingComposer,
      $$CommercialProfilesTableAnnotationComposer,
      $$CommercialProfilesTableCreateCompanionBuilder,
      $$CommercialProfilesTableUpdateCompanionBuilder,
      (CommercialProfile, $$CommercialProfilesTableReferences),
      CommercialProfile,
      PrefetchHooks Function({bool contactId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$CommercialProfilesTableTableManager get commercialProfiles =>
      $$CommercialProfilesTableTableManager(_db, _db.commercialProfiles);
}
