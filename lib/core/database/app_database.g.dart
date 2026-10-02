// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _memorizationLevelMeta = const VerificationMeta(
    'memorizationLevel',
  );
  @override
  late final GeneratedColumn<String> memorizationLevel =
      GeneratedColumn<String>(
        'memorization_level',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('debutant'),
      );
  static const VerificationMeta _availableDaysMaskMeta = const VerificationMeta(
    'availableDaysMask',
  );
  @override
  late final GeneratedColumn<int> availableDaysMask = GeneratedColumn<int>(
    'available_days_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _dailyTargetMinutesMeta =
      const VerificationMeta('dailyTargetMinutes');
  @override
  late final GeneratedColumn<int> dailyTargetMinutes = GeneratedColumn<int>(
    'daily_target_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _preferredQariIdMeta = const VerificationMeta(
    'preferredQariId',
  );
  @override
  late final GeneratedColumn<String> preferredQariId = GeneratedColumn<String>(
    'preferred_qari_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scriptModeMeta = const VerificationMeta(
    'scriptMode',
  );
  @override
  late final GeneratedColumn<String> scriptMode = GeneratedColumn<String>(
    'script_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('hafs'),
  );
  static const VerificationMeta _hasCompletedOnboardingMeta =
      const VerificationMeta('hasCompletedOnboarding');
  @override
  late final GeneratedColumn<bool> hasCompletedOnboarding =
      GeneratedColumn<bool>(
        'has_completed_onboarding',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_completed_onboarding" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    memorizationLevel,
    availableDaysMask,
    dailyTargetMinutes,
    preferredQariId,
    scriptMode,
    hasCompletedOnboarding,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('memorization_level')) {
      context.handle(
        _memorizationLevelMeta,
        memorizationLevel.isAcceptableOrUnknown(
          data['memorization_level']!,
          _memorizationLevelMeta,
        ),
      );
    }
    if (data.containsKey('available_days_mask')) {
      context.handle(
        _availableDaysMaskMeta,
        availableDaysMask.isAcceptableOrUnknown(
          data['available_days_mask']!,
          _availableDaysMaskMeta,
        ),
      );
    }
    if (data.containsKey('daily_target_minutes')) {
      context.handle(
        _dailyTargetMinutesMeta,
        dailyTargetMinutes.isAcceptableOrUnknown(
          data['daily_target_minutes']!,
          _dailyTargetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('preferred_qari_id')) {
      context.handle(
        _preferredQariIdMeta,
        preferredQariId.isAcceptableOrUnknown(
          data['preferred_qari_id']!,
          _preferredQariIdMeta,
        ),
      );
    }
    if (data.containsKey('script_mode')) {
      context.handle(
        _scriptModeMeta,
        scriptMode.isAcceptableOrUnknown(data['script_mode']!, _scriptModeMeta),
      );
    }
    if (data.containsKey('has_completed_onboarding')) {
      context.handle(
        _hasCompletedOnboardingMeta,
        hasCompletedOnboarding.isAcceptableOrUnknown(
          data['has_completed_onboarding']!,
          _hasCompletedOnboardingMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      memorizationLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memorization_level'],
      )!,
      availableDaysMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}available_days_mask'],
      )!,
      dailyTargetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_target_minutes'],
      )!,
      preferredQariId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_qari_id'],
      ),
      scriptMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}script_mode'],
      )!,
      hasCompletedOnboarding: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_completed_onboarding'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final String displayName;

  /// 'debutant' | 'en_cours' | 'hafiz' — set by the Onboarding level test.
  final String memorizationLevel;

  /// Bitmask over the 7 days of the week (bit 0 = Monday) for availability.
  final int availableDaysMask;
  final int dailyTargetMinutes;
  final String? preferredQariId;

  /// 'hafs' | 'warsh' — Mushaf script/riwaya.
  final String scriptMode;

  /// Whether the Onboarding (Brique 2) flow has been completed — gates
  /// whether the app shows it again on the next launch.
  final bool hasCompletedOnboarding;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.memorizationLevel,
    required this.availableDaysMask,
    required this.dailyTargetMinutes,
    this.preferredQariId,
    required this.scriptMode,
    required this.hasCompletedOnboarding,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['memorization_level'] = Variable<String>(memorizationLevel);
    map['available_days_mask'] = Variable<int>(availableDaysMask);
    map['daily_target_minutes'] = Variable<int>(dailyTargetMinutes);
    if (!nullToAbsent || preferredQariId != null) {
      map['preferred_qari_id'] = Variable<String>(preferredQariId);
    }
    map['script_mode'] = Variable<String>(scriptMode);
    map['has_completed_onboarding'] = Variable<bool>(hasCompletedOnboarding);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      memorizationLevel: Value(memorizationLevel),
      availableDaysMask: Value(availableDaysMask),
      dailyTargetMinutes: Value(dailyTargetMinutes),
      preferredQariId: preferredQariId == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredQariId),
      scriptMode: Value(scriptMode),
      hasCompletedOnboarding: Value(hasCompletedOnboarding),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      memorizationLevel: serializer.fromJson<String>(json['memorizationLevel']),
      availableDaysMask: serializer.fromJson<int>(json['availableDaysMask']),
      dailyTargetMinutes: serializer.fromJson<int>(json['dailyTargetMinutes']),
      preferredQariId: serializer.fromJson<String?>(json['preferredQariId']),
      scriptMode: serializer.fromJson<String>(json['scriptMode']),
      hasCompletedOnboarding: serializer.fromJson<bool>(
        json['hasCompletedOnboarding'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'memorizationLevel': serializer.toJson<String>(memorizationLevel),
      'availableDaysMask': serializer.toJson<int>(availableDaysMask),
      'dailyTargetMinutes': serializer.toJson<int>(dailyTargetMinutes),
      'preferredQariId': serializer.toJson<String?>(preferredQariId),
      'scriptMode': serializer.toJson<String>(scriptMode),
      'hasCompletedOnboarding': serializer.toJson<bool>(hasCompletedOnboarding),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? memorizationLevel,
    int? availableDaysMask,
    int? dailyTargetMinutes,
    Value<String?> preferredQariId = const Value.absent(),
    String? scriptMode,
    bool? hasCompletedOnboarding,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfile(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    memorizationLevel: memorizationLevel ?? this.memorizationLevel,
    availableDaysMask: availableDaysMask ?? this.availableDaysMask,
    dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
    preferredQariId: preferredQariId.present
        ? preferredQariId.value
        : this.preferredQariId,
    scriptMode: scriptMode ?? this.scriptMode,
    hasCompletedOnboarding:
        hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      memorizationLevel: data.memorizationLevel.present
          ? data.memorizationLevel.value
          : this.memorizationLevel,
      availableDaysMask: data.availableDaysMask.present
          ? data.availableDaysMask.value
          : this.availableDaysMask,
      dailyTargetMinutes: data.dailyTargetMinutes.present
          ? data.dailyTargetMinutes.value
          : this.dailyTargetMinutes,
      preferredQariId: data.preferredQariId.present
          ? data.preferredQariId.value
          : this.preferredQariId,
      scriptMode: data.scriptMode.present
          ? data.scriptMode.value
          : this.scriptMode,
      hasCompletedOnboarding: data.hasCompletedOnboarding.present
          ? data.hasCompletedOnboarding.value
          : this.hasCompletedOnboarding,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('memorizationLevel: $memorizationLevel, ')
          ..write('availableDaysMask: $availableDaysMask, ')
          ..write('dailyTargetMinutes: $dailyTargetMinutes, ')
          ..write('preferredQariId: $preferredQariId, ')
          ..write('scriptMode: $scriptMode, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    memorizationLevel,
    availableDaysMask,
    dailyTargetMinutes,
    preferredQariId,
    scriptMode,
    hasCompletedOnboarding,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.memorizationLevel == this.memorizationLevel &&
          other.availableDaysMask == this.availableDaysMask &&
          other.dailyTargetMinutes == this.dailyTargetMinutes &&
          other.preferredQariId == this.preferredQariId &&
          other.scriptMode == this.scriptMode &&
          other.hasCompletedOnboarding == this.hasCompletedOnboarding &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> memorizationLevel;
  final Value<int> availableDaysMask;
  final Value<int> dailyTargetMinutes;
  final Value<String?> preferredQariId;
  final Value<String> scriptMode;
  final Value<bool> hasCompletedOnboarding;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.memorizationLevel = const Value.absent(),
    this.availableDaysMask = const Value.absent(),
    this.dailyTargetMinutes = const Value.absent(),
    this.preferredQariId = const Value.absent(),
    this.scriptMode = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    this.displayName = const Value.absent(),
    this.memorizationLevel = const Value.absent(),
    this.availableDaysMask = const Value.absent(),
    this.dailyTargetMinutes = const Value.absent(),
    this.preferredQariId = const Value.absent(),
    this.scriptMode = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? memorizationLevel,
    Expression<int>? availableDaysMask,
    Expression<int>? dailyTargetMinutes,
    Expression<String>? preferredQariId,
    Expression<String>? scriptMode,
    Expression<bool>? hasCompletedOnboarding,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (memorizationLevel != null) 'memorization_level': memorizationLevel,
      if (availableDaysMask != null) 'available_days_mask': availableDaysMask,
      if (dailyTargetMinutes != null)
        'daily_target_minutes': dailyTargetMinutes,
      if (preferredQariId != null) 'preferred_qari_id': preferredQariId,
      if (scriptMode != null) 'script_mode': scriptMode,
      if (hasCompletedOnboarding != null)
        'has_completed_onboarding': hasCompletedOnboarding,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? memorizationLevel,
    Value<int>? availableDaysMask,
    Value<int>? dailyTargetMinutes,
    Value<String?>? preferredQariId,
    Value<String>? scriptMode,
    Value<bool>? hasCompletedOnboarding,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      memorizationLevel: memorizationLevel ?? this.memorizationLevel,
      availableDaysMask: availableDaysMask ?? this.availableDaysMask,
      dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
      preferredQariId: preferredQariId ?? this.preferredQariId,
      scriptMode: scriptMode ?? this.scriptMode,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (memorizationLevel.present) {
      map['memorization_level'] = Variable<String>(memorizationLevel.value);
    }
    if (availableDaysMask.present) {
      map['available_days_mask'] = Variable<int>(availableDaysMask.value);
    }
    if (dailyTargetMinutes.present) {
      map['daily_target_minutes'] = Variable<int>(dailyTargetMinutes.value);
    }
    if (preferredQariId.present) {
      map['preferred_qari_id'] = Variable<String>(preferredQariId.value);
    }
    if (scriptMode.present) {
      map['script_mode'] = Variable<String>(scriptMode.value);
    }
    if (hasCompletedOnboarding.present) {
      map['has_completed_onboarding'] = Variable<bool>(
        hasCompletedOnboarding.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('memorizationLevel: $memorizationLevel, ')
          ..write('availableDaysMask: $availableDaysMask, ')
          ..write('dailyTargetMinutes: $dailyTargetMinutes, ')
          ..write('preferredQariId: $preferredQariId, ')
          ..write('scriptMode: $scriptMode, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PassagesTable extends Passages with TableInfo<$PassagesTable, Passage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PassagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahStartMeta = const VerificationMeta(
    'ayahStart',
  );
  @override
  late final GeneratedColumn<int> ayahStart = GeneratedColumn<int>(
    'ayah_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahEndMeta = const VerificationMeta(
    'ayahEnd',
  );
  @override
  late final GeneratedColumn<int> ayahEnd = GeneratedColumn<int>(
    'ayah_end',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    surahNumber,
    ayahStart,
    ayahEnd,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'passages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Passage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_start')) {
      context.handle(
        _ayahStartMeta,
        ayahStart.isAcceptableOrUnknown(data['ayah_start']!, _ayahStartMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahStartMeta);
    }
    if (data.containsKey('ayah_end')) {
      context.handle(
        _ayahEndMeta,
        ayahEnd.isAcceptableOrUnknown(data['ayah_end']!, _ayahEndMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahEndMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Passage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Passage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_start'],
      )!,
      ayahEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_end'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PassagesTable createAlias(String alias) {
    return $PassagesTable(attachedDatabase, alias);
  }
}

class Passage extends DataClass implements Insertable<Passage> {
  final String id;
  final String profileId;
  final int surahNumber;
  final int ayahStart;
  final int ayahEnd;
  final DateTime createdAt;
  const Passage({
    required this.id,
    required this.profileId,
    required this.surahNumber,
    required this.ayahStart,
    required this.ayahEnd,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_start'] = Variable<int>(ayahStart);
    map['ayah_end'] = Variable<int>(ayahEnd);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PassagesCompanion toCompanion(bool nullToAbsent) {
    return PassagesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      surahNumber: Value(surahNumber),
      ayahStart: Value(ayahStart),
      ayahEnd: Value(ayahEnd),
      createdAt: Value(createdAt),
    );
  }

  factory Passage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Passage(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahStart: serializer.fromJson<int>(json['ayahStart']),
      ayahEnd: serializer.fromJson<int>(json['ayahEnd']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahStart': serializer.toJson<int>(ayahStart),
      'ayahEnd': serializer.toJson<int>(ayahEnd),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Passage copyWith({
    String? id,
    String? profileId,
    int? surahNumber,
    int? ayahStart,
    int? ayahEnd,
    DateTime? createdAt,
  }) => Passage(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahStart: ayahStart ?? this.ayahStart,
    ayahEnd: ayahEnd ?? this.ayahEnd,
    createdAt: createdAt ?? this.createdAt,
  );
  Passage copyWithCompanion(PassagesCompanion data) {
    return Passage(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahStart: data.ayahStart.present ? data.ayahStart.value : this.ayahStart,
      ayahEnd: data.ayahEnd.present ? data.ayahEnd.value : this.ayahEnd,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Passage(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahStart: $ayahStart, ')
          ..write('ayahEnd: $ayahEnd, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, surahNumber, ayahStart, ayahEnd, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Passage &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.surahNumber == this.surahNumber &&
          other.ayahStart == this.ayahStart &&
          other.ayahEnd == this.ayahEnd &&
          other.createdAt == this.createdAt);
}

class PassagesCompanion extends UpdateCompanion<Passage> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int> surahNumber;
  final Value<int> ayahStart;
  final Value<int> ayahEnd;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PassagesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahStart = const Value.absent(),
    this.ayahEnd = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PassagesCompanion.insert({
    required String id,
    required String profileId,
    required int surahNumber,
    required int ayahStart,
    required int ayahEnd,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       surahNumber = Value(surahNumber),
       ayahStart = Value(ayahStart),
       ayahEnd = Value(ayahEnd),
       createdAt = Value(createdAt);
  static Insertable<Passage> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? surahNumber,
    Expression<int>? ayahStart,
    Expression<int>? ayahEnd,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahStart != null) 'ayah_start': ayahStart,
      if (ayahEnd != null) 'ayah_end': ayahEnd,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PassagesCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int>? surahNumber,
    Value<int>? ayahStart,
    Value<int>? ayahEnd,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PassagesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahStart: ayahStart ?? this.ayahStart,
      ayahEnd: ayahEnd ?? this.ayahEnd,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahStart.present) {
      map['ayah_start'] = Variable<int>(ayahStart.value);
    }
    if (ayahEnd.present) {
      map['ayah_end'] = Variable<int>(ayahEnd.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PassagesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahStart: $ayahStart, ')
          ..write('ayahEnd: $ayahEnd, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionProgressEntriesTable extends SessionProgressEntries
    with TableInfo<$SessionProgressEntriesTable, SessionProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passageIdMeta = const VerificationMeta(
    'passageId',
  );
  @override
  late final GeneratedColumn<String> passageId = GeneratedColumn<String>(
    'passage_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES passages (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _currentStepIndexMeta = const VerificationMeta(
    'currentStepIndex',
  );
  @override
  late final GeneratedColumn<int> currentStepIndex = GeneratedColumn<int>(
    'current_step_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentAyahMeta = const VerificationMeta(
    'currentAyah',
  );
  @override
  late final GeneratedColumn<int> currentAyah = GeneratedColumn<int>(
    'current_ayah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maskLevelMeta = const VerificationMeta(
    'maskLevel',
  );
  @override
  late final GeneratedColumn<String> maskLevel = GeneratedColumn<String>(
    'mask_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    passageId,
    currentStepIndex,
    currentAyah,
    maskLevel,
    startedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('passage_id')) {
      context.handle(
        _passageIdMeta,
        passageId.isAcceptableOrUnknown(data['passage_id']!, _passageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_passageIdMeta);
    }
    if (data.containsKey('current_step_index')) {
      context.handle(
        _currentStepIndexMeta,
        currentStepIndex.isAcceptableOrUnknown(
          data['current_step_index']!,
          _currentStepIndexMeta,
        ),
      );
    }
    if (data.containsKey('current_ayah')) {
      context.handle(
        _currentAyahMeta,
        currentAyah.isAcceptableOrUnknown(
          data['current_ayah']!,
          _currentAyahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentAyahMeta);
    }
    if (data.containsKey('mask_level')) {
      context.handle(
        _maskLevelMeta,
        maskLevel.isAcceptableOrUnknown(data['mask_level']!, _maskLevelMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {passageId},
  ];
  @override
  SessionProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      passageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}passage_id'],
      )!,
      currentStepIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_step_index'],
      )!,
      currentAyah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_ayah'],
      )!,
      maskLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mask_level'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SessionProgressEntriesTable createAlias(String alias) {
    return $SessionProgressEntriesTable(attachedDatabase, alias);
  }
}

class SessionProgressEntry extends DataClass
    implements Insertable<SessionProgressEntry> {
  final String id;
  final String passageId;

  /// 0=Découvrir, 1=Répéter, 2=Masquer, 3=Réciter, 4=Enchaîner.
  final int currentStepIndex;
  final int currentAyah;

  /// 'light' | 'medium' | 'full' — only meaningful during Masquer.
  final String? maskLevel;
  final DateTime startedAt;
  final DateTime updatedAt;
  const SessionProgressEntry({
    required this.id,
    required this.passageId,
    required this.currentStepIndex,
    required this.currentAyah,
    this.maskLevel,
    required this.startedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['passage_id'] = Variable<String>(passageId);
    map['current_step_index'] = Variable<int>(currentStepIndex);
    map['current_ayah'] = Variable<int>(currentAyah);
    if (!nullToAbsent || maskLevel != null) {
      map['mask_level'] = Variable<String>(maskLevel);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SessionProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return SessionProgressEntriesCompanion(
      id: Value(id),
      passageId: Value(passageId),
      currentStepIndex: Value(currentStepIndex),
      currentAyah: Value(currentAyah),
      maskLevel: maskLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(maskLevel),
      startedAt: Value(startedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SessionProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionProgressEntry(
      id: serializer.fromJson<String>(json['id']),
      passageId: serializer.fromJson<String>(json['passageId']),
      currentStepIndex: serializer.fromJson<int>(json['currentStepIndex']),
      currentAyah: serializer.fromJson<int>(json['currentAyah']),
      maskLevel: serializer.fromJson<String?>(json['maskLevel']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'passageId': serializer.toJson<String>(passageId),
      'currentStepIndex': serializer.toJson<int>(currentStepIndex),
      'currentAyah': serializer.toJson<int>(currentAyah),
      'maskLevel': serializer.toJson<String?>(maskLevel),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SessionProgressEntry copyWith({
    String? id,
    String? passageId,
    int? currentStepIndex,
    int? currentAyah,
    Value<String?> maskLevel = const Value.absent(),
    DateTime? startedAt,
    DateTime? updatedAt,
  }) => SessionProgressEntry(
    id: id ?? this.id,
    passageId: passageId ?? this.passageId,
    currentStepIndex: currentStepIndex ?? this.currentStepIndex,
    currentAyah: currentAyah ?? this.currentAyah,
    maskLevel: maskLevel.present ? maskLevel.value : this.maskLevel,
    startedAt: startedAt ?? this.startedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SessionProgressEntry copyWithCompanion(SessionProgressEntriesCompanion data) {
    return SessionProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      passageId: data.passageId.present ? data.passageId.value : this.passageId,
      currentStepIndex: data.currentStepIndex.present
          ? data.currentStepIndex.value
          : this.currentStepIndex,
      currentAyah: data.currentAyah.present
          ? data.currentAyah.value
          : this.currentAyah,
      maskLevel: data.maskLevel.present ? data.maskLevel.value : this.maskLevel,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionProgressEntry(')
          ..write('id: $id, ')
          ..write('passageId: $passageId, ')
          ..write('currentStepIndex: $currentStepIndex, ')
          ..write('currentAyah: $currentAyah, ')
          ..write('maskLevel: $maskLevel, ')
          ..write('startedAt: $startedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    passageId,
    currentStepIndex,
    currentAyah,
    maskLevel,
    startedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionProgressEntry &&
          other.id == this.id &&
          other.passageId == this.passageId &&
          other.currentStepIndex == this.currentStepIndex &&
          other.currentAyah == this.currentAyah &&
          other.maskLevel == this.maskLevel &&
          other.startedAt == this.startedAt &&
          other.updatedAt == this.updatedAt);
}

class SessionProgressEntriesCompanion
    extends UpdateCompanion<SessionProgressEntry> {
  final Value<String> id;
  final Value<String> passageId;
  final Value<int> currentStepIndex;
  final Value<int> currentAyah;
  final Value<String?> maskLevel;
  final Value<DateTime> startedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SessionProgressEntriesCompanion({
    this.id = const Value.absent(),
    this.passageId = const Value.absent(),
    this.currentStepIndex = const Value.absent(),
    this.currentAyah = const Value.absent(),
    this.maskLevel = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionProgressEntriesCompanion.insert({
    required String id,
    required String passageId,
    this.currentStepIndex = const Value.absent(),
    required int currentAyah,
    this.maskLevel = const Value.absent(),
    required DateTime startedAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       passageId = Value(passageId),
       currentAyah = Value(currentAyah),
       startedAt = Value(startedAt),
       updatedAt = Value(updatedAt);
  static Insertable<SessionProgressEntry> custom({
    Expression<String>? id,
    Expression<String>? passageId,
    Expression<int>? currentStepIndex,
    Expression<int>? currentAyah,
    Expression<String>? maskLevel,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (passageId != null) 'passage_id': passageId,
      if (currentStepIndex != null) 'current_step_index': currentStepIndex,
      if (currentAyah != null) 'current_ayah': currentAyah,
      if (maskLevel != null) 'mask_level': maskLevel,
      if (startedAt != null) 'started_at': startedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionProgressEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? passageId,
    Value<int>? currentStepIndex,
    Value<int>? currentAyah,
    Value<String?>? maskLevel,
    Value<DateTime>? startedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SessionProgressEntriesCompanion(
      id: id ?? this.id,
      passageId: passageId ?? this.passageId,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentAyah: currentAyah ?? this.currentAyah,
      maskLevel: maskLevel ?? this.maskLevel,
      startedAt: startedAt ?? this.startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (passageId.present) {
      map['passage_id'] = Variable<String>(passageId.value);
    }
    if (currentStepIndex.present) {
      map['current_step_index'] = Variable<int>(currentStepIndex.value);
    }
    if (currentAyah.present) {
      map['current_ayah'] = Variable<int>(currentAyah.value);
    }
    if (maskLevel.present) {
      map['mask_level'] = Variable<String>(maskLevel.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionProgressEntriesCompanion(')
          ..write('id: $id, ')
          ..write('passageId: $passageId, ')
          ..write('currentStepIndex: $currentStepIndex, ')
          ..write('currentAyah: $currentAyah, ')
          ..write('maskLevel: $maskLevel, ')
          ..write('startedAt: $startedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AyahProgressEntriesTable extends AyahProgressEntries
    with TableInfo<$AyahProgressEntriesTable, AyahProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOutcomeMeta = const VerificationMeta(
    'lastOutcome',
  );
  @override
  late final GeneratedColumn<String> lastOutcome = GeneratedColumn<String>(
    'last_outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fragileWordIndicesMeta =
      const VerificationMeta('fragileWordIndices');
  @override
  late final GeneratedColumn<String> fragileWordIndices =
      GeneratedColumn<String>(
        'fragile_word_indices',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _reviewCycleStepMeta = const VerificationMeta(
    'reviewCycleStep',
  );
  @override
  late final GeneratedColumn<int> reviewCycleStep = GeneratedColumn<int>(
    'review_cycle_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _memorizedAtMeta = const VerificationMeta(
    'memorizedAt',
  );
  @override
  late final GeneratedColumn<DateTime> memorizedAt = GeneratedColumn<DateTime>(
    'memorized_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextReviewAtMeta = const VerificationMeta(
    'nextReviewAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
    'next_review_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    surahNumber,
    ayahNumber,
    lastOutcome,
    fragileWordIndices,
    reviewCycleStep,
    memorizedAt,
    nextReviewAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayah_progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AyahProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('last_outcome')) {
      context.handle(
        _lastOutcomeMeta,
        lastOutcome.isAcceptableOrUnknown(
          data['last_outcome']!,
          _lastOutcomeMeta,
        ),
      );
    }
    if (data.containsKey('fragile_word_indices')) {
      context.handle(
        _fragileWordIndicesMeta,
        fragileWordIndices.isAcceptableOrUnknown(
          data['fragile_word_indices']!,
          _fragileWordIndicesMeta,
        ),
      );
    }
    if (data.containsKey('review_cycle_step')) {
      context.handle(
        _reviewCycleStepMeta,
        reviewCycleStep.isAcceptableOrUnknown(
          data['review_cycle_step']!,
          _reviewCycleStepMeta,
        ),
      );
    }
    if (data.containsKey('memorized_at')) {
      context.handle(
        _memorizedAtMeta,
        memorizedAt.isAcceptableOrUnknown(
          data['memorized_at']!,
          _memorizedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_memorizedAtMeta);
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
        _nextReviewAtMeta,
        nextReviewAt.isAcceptableOrUnknown(
          data['next_review_at']!,
          _nextReviewAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextReviewAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, surahNumber, ayahNumber},
  ];
  @override
  AyahProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AyahProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      lastOutcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_outcome'],
      ),
      fragileWordIndices: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fragile_word_indices'],
      )!,
      reviewCycleStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_cycle_step'],
      )!,
      memorizedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}memorized_at'],
      )!,
      nextReviewAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AyahProgressEntriesTable createAlias(String alias) {
    return $AyahProgressEntriesTable(attachedDatabase, alias);
  }
}

class AyahProgressEntry extends DataClass
    implements Insertable<AyahProgressEntry> {
  final String id;
  final String profileId;
  final int surahNumber;
  final int ayahNumber;

  /// 'clean' | 'hesitant' | 'redo' — the last "Réciter" self-assessment.
  final String? lastOutcome;

  /// JSON-encoded list of word indices tapped during Masquer (revealed
  /// early) — feeds ReviewScheduler's `hasFragileWords`.
  final String fragileWordIndices;

  /// How many successful reviews so far — ReviewScheduler's `cycleStep`.
  final int reviewCycleStep;
  final DateTime memorizedAt;
  final DateTime nextReviewAt;
  final DateTime updatedAt;
  const AyahProgressEntry({
    required this.id,
    required this.profileId,
    required this.surahNumber,
    required this.ayahNumber,
    this.lastOutcome,
    required this.fragileWordIndices,
    required this.reviewCycleStep,
    required this.memorizedAt,
    required this.nextReviewAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    if (!nullToAbsent || lastOutcome != null) {
      map['last_outcome'] = Variable<String>(lastOutcome);
    }
    map['fragile_word_indices'] = Variable<String>(fragileWordIndices);
    map['review_cycle_step'] = Variable<int>(reviewCycleStep);
    map['memorized_at'] = Variable<DateTime>(memorizedAt);
    map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AyahProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return AyahProgressEntriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      lastOutcome: lastOutcome == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOutcome),
      fragileWordIndices: Value(fragileWordIndices),
      reviewCycleStep: Value(reviewCycleStep),
      memorizedAt: Value(memorizedAt),
      nextReviewAt: Value(nextReviewAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AyahProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AyahProgressEntry(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      lastOutcome: serializer.fromJson<String?>(json['lastOutcome']),
      fragileWordIndices: serializer.fromJson<String>(
        json['fragileWordIndices'],
      ),
      reviewCycleStep: serializer.fromJson<int>(json['reviewCycleStep']),
      memorizedAt: serializer.fromJson<DateTime>(json['memorizedAt']),
      nextReviewAt: serializer.fromJson<DateTime>(json['nextReviewAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'lastOutcome': serializer.toJson<String?>(lastOutcome),
      'fragileWordIndices': serializer.toJson<String>(fragileWordIndices),
      'reviewCycleStep': serializer.toJson<int>(reviewCycleStep),
      'memorizedAt': serializer.toJson<DateTime>(memorizedAt),
      'nextReviewAt': serializer.toJson<DateTime>(nextReviewAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AyahProgressEntry copyWith({
    String? id,
    String? profileId,
    int? surahNumber,
    int? ayahNumber,
    Value<String?> lastOutcome = const Value.absent(),
    String? fragileWordIndices,
    int? reviewCycleStep,
    DateTime? memorizedAt,
    DateTime? nextReviewAt,
    DateTime? updatedAt,
  }) => AyahProgressEntry(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    lastOutcome: lastOutcome.present ? lastOutcome.value : this.lastOutcome,
    fragileWordIndices: fragileWordIndices ?? this.fragileWordIndices,
    reviewCycleStep: reviewCycleStep ?? this.reviewCycleStep,
    memorizedAt: memorizedAt ?? this.memorizedAt,
    nextReviewAt: nextReviewAt ?? this.nextReviewAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AyahProgressEntry copyWithCompanion(AyahProgressEntriesCompanion data) {
    return AyahProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      lastOutcome: data.lastOutcome.present
          ? data.lastOutcome.value
          : this.lastOutcome,
      fragileWordIndices: data.fragileWordIndices.present
          ? data.fragileWordIndices.value
          : this.fragileWordIndices,
      reviewCycleStep: data.reviewCycleStep.present
          ? data.reviewCycleStep.value
          : this.reviewCycleStep,
      memorizedAt: data.memorizedAt.present
          ? data.memorizedAt.value
          : this.memorizedAt,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AyahProgressEntry(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('lastOutcome: $lastOutcome, ')
          ..write('fragileWordIndices: $fragileWordIndices, ')
          ..write('reviewCycleStep: $reviewCycleStep, ')
          ..write('memorizedAt: $memorizedAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    surahNumber,
    ayahNumber,
    lastOutcome,
    fragileWordIndices,
    reviewCycleStep,
    memorizedAt,
    nextReviewAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AyahProgressEntry &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.lastOutcome == this.lastOutcome &&
          other.fragileWordIndices == this.fragileWordIndices &&
          other.reviewCycleStep == this.reviewCycleStep &&
          other.memorizedAt == this.memorizedAt &&
          other.nextReviewAt == this.nextReviewAt &&
          other.updatedAt == this.updatedAt);
}

class AyahProgressEntriesCompanion extends UpdateCompanion<AyahProgressEntry> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String?> lastOutcome;
  final Value<String> fragileWordIndices;
  final Value<int> reviewCycleStep;
  final Value<DateTime> memorizedAt;
  final Value<DateTime> nextReviewAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AyahProgressEntriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.lastOutcome = const Value.absent(),
    this.fragileWordIndices = const Value.absent(),
    this.reviewCycleStep = const Value.absent(),
    this.memorizedAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AyahProgressEntriesCompanion.insert({
    required String id,
    required String profileId,
    required int surahNumber,
    required int ayahNumber,
    this.lastOutcome = const Value.absent(),
    this.fragileWordIndices = const Value.absent(),
    this.reviewCycleStep = const Value.absent(),
    required DateTime memorizedAt,
    required DateTime nextReviewAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       memorizedAt = Value(memorizedAt),
       nextReviewAt = Value(nextReviewAt),
       updatedAt = Value(updatedAt);
  static Insertable<AyahProgressEntry> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? lastOutcome,
    Expression<String>? fragileWordIndices,
    Expression<int>? reviewCycleStep,
    Expression<DateTime>? memorizedAt,
    Expression<DateTime>? nextReviewAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (lastOutcome != null) 'last_outcome': lastOutcome,
      if (fragileWordIndices != null)
        'fragile_word_indices': fragileWordIndices,
      if (reviewCycleStep != null) 'review_cycle_step': reviewCycleStep,
      if (memorizedAt != null) 'memorized_at': memorizedAt,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AyahProgressEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<String?>? lastOutcome,
    Value<String>? fragileWordIndices,
    Value<int>? reviewCycleStep,
    Value<DateTime>? memorizedAt,
    Value<DateTime>? nextReviewAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AyahProgressEntriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      lastOutcome: lastOutcome ?? this.lastOutcome,
      fragileWordIndices: fragileWordIndices ?? this.fragileWordIndices,
      reviewCycleStep: reviewCycleStep ?? this.reviewCycleStep,
      memorizedAt: memorizedAt ?? this.memorizedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (lastOutcome.present) {
      map['last_outcome'] = Variable<String>(lastOutcome.value);
    }
    if (fragileWordIndices.present) {
      map['fragile_word_indices'] = Variable<String>(fragileWordIndices.value);
    }
    if (reviewCycleStep.present) {
      map['review_cycle_step'] = Variable<int>(reviewCycleStep.value);
    }
    if (memorizedAt.present) {
      map['memorized_at'] = Variable<DateTime>(memorizedAt.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahProgressEntriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('lastOutcome: $lastOutcome, ')
          ..write('fragileWordIndices: $fragileWordIndices, ')
          ..write('reviewCycleStep: $reviewCycleStep, ')
          ..write('memorizedAt: $memorizedAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SurahProgressEntriesTable extends SurahProgressEntries
    with TableInfo<$SurahProgressEntriesTable, SurahProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memorizedAyahCountMeta =
      const VerificationMeta('memorizedAyahCount');
  @override
  late final GeneratedColumn<int> memorizedAyahCount = GeneratedColumn<int>(
    'memorized_ayah_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalAyahCountMeta = const VerificationMeta(
    'totalAyahCount',
  );
  @override
  late final GeneratedColumn<int> totalAyahCount = GeneratedColumn<int>(
    'total_ayah_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    surahNumber,
    memorizedAyahCount,
    totalAyahCount,
    completedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surah_progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurahProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('memorized_ayah_count')) {
      context.handle(
        _memorizedAyahCountMeta,
        memorizedAyahCount.isAcceptableOrUnknown(
          data['memorized_ayah_count']!,
          _memorizedAyahCountMeta,
        ),
      );
    }
    if (data.containsKey('total_ayah_count')) {
      context.handle(
        _totalAyahCountMeta,
        totalAyahCount.isAcceptableOrUnknown(
          data['total_ayah_count']!,
          _totalAyahCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAyahCountMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, surahNumber},
  ];
  @override
  SurahProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurahProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      memorizedAyahCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}memorized_ayah_count'],
      )!,
      totalAyahCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_ayah_count'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SurahProgressEntriesTable createAlias(String alias) {
    return $SurahProgressEntriesTable(attachedDatabase, alias);
  }
}

class SurahProgressEntry extends DataClass
    implements Insertable<SurahProgressEntry> {
  final String id;
  final String profileId;
  final int surahNumber;
  final int memorizedAyahCount;
  final int totalAyahCount;
  final DateTime? completedAt;
  final DateTime updatedAt;
  const SurahProgressEntry({
    required this.id,
    required this.profileId,
    required this.surahNumber,
    required this.memorizedAyahCount,
    required this.totalAyahCount,
    this.completedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['surah_number'] = Variable<int>(surahNumber);
    map['memorized_ayah_count'] = Variable<int>(memorizedAyahCount);
    map['total_ayah_count'] = Variable<int>(totalAyahCount);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SurahProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return SurahProgressEntriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      surahNumber: Value(surahNumber),
      memorizedAyahCount: Value(memorizedAyahCount),
      totalAyahCount: Value(totalAyahCount),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SurahProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurahProgressEntry(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      memorizedAyahCount: serializer.fromJson<int>(json['memorizedAyahCount']),
      totalAyahCount: serializer.fromJson<int>(json['totalAyahCount']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'memorizedAyahCount': serializer.toJson<int>(memorizedAyahCount),
      'totalAyahCount': serializer.toJson<int>(totalAyahCount),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SurahProgressEntry copyWith({
    String? id,
    String? profileId,
    int? surahNumber,
    int? memorizedAyahCount,
    int? totalAyahCount,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => SurahProgressEntry(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    surahNumber: surahNumber ?? this.surahNumber,
    memorizedAyahCount: memorizedAyahCount ?? this.memorizedAyahCount,
    totalAyahCount: totalAyahCount ?? this.totalAyahCount,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SurahProgressEntry copyWithCompanion(SurahProgressEntriesCompanion data) {
    return SurahProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      memorizedAyahCount: data.memorizedAyahCount.present
          ? data.memorizedAyahCount.value
          : this.memorizedAyahCount,
      totalAyahCount: data.totalAyahCount.present
          ? data.totalAyahCount.value
          : this.totalAyahCount,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurahProgressEntry(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('memorizedAyahCount: $memorizedAyahCount, ')
          ..write('totalAyahCount: $totalAyahCount, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    surahNumber,
    memorizedAyahCount,
    totalAyahCount,
    completedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahProgressEntry &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.surahNumber == this.surahNumber &&
          other.memorizedAyahCount == this.memorizedAyahCount &&
          other.totalAyahCount == this.totalAyahCount &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class SurahProgressEntriesCompanion
    extends UpdateCompanion<SurahProgressEntry> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int> surahNumber;
  final Value<int> memorizedAyahCount;
  final Value<int> totalAyahCount;
  final Value<DateTime?> completedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SurahProgressEntriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.memorizedAyahCount = const Value.absent(),
    this.totalAyahCount = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SurahProgressEntriesCompanion.insert({
    required String id,
    required String profileId,
    required int surahNumber,
    this.memorizedAyahCount = const Value.absent(),
    required int totalAyahCount,
    this.completedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       surahNumber = Value(surahNumber),
       totalAyahCount = Value(totalAyahCount),
       updatedAt = Value(updatedAt);
  static Insertable<SurahProgressEntry> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? surahNumber,
    Expression<int>? memorizedAyahCount,
    Expression<int>? totalAyahCount,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (memorizedAyahCount != null)
        'memorized_ayah_count': memorizedAyahCount,
      if (totalAyahCount != null) 'total_ayah_count': totalAyahCount,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SurahProgressEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int>? surahNumber,
    Value<int>? memorizedAyahCount,
    Value<int>? totalAyahCount,
    Value<DateTime?>? completedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SurahProgressEntriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      surahNumber: surahNumber ?? this.surahNumber,
      memorizedAyahCount: memorizedAyahCount ?? this.memorizedAyahCount,
      totalAyahCount: totalAyahCount ?? this.totalAyahCount,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (memorizedAyahCount.present) {
      map['memorized_ayah_count'] = Variable<int>(memorizedAyahCount.value);
    }
    if (totalAyahCount.present) {
      map['total_ayah_count'] = Variable<int>(totalAyahCount.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahProgressEntriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('memorizedAyahCount: $memorizedAyahCount, ')
          ..write('totalAyahCount: $totalAyahCount, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    surahNumber,
    ayahNumber,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final String id;
  final String profileId;
  final int surahNumber;
  final int ayahNumber;
  final String? note;
  final DateTime createdAt;
  const Bookmark({
    required this.id,
    required this.profileId,
    required this.surahNumber,
    required this.ayahNumber,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bookmark copyWith({
    String? id,
    String? profileId,
    int? surahNumber,
    int? ayahNumber,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Bookmark(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, surahNumber, ayahNumber, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required String id,
    required String profileId,
    required int surahNumber,
    required int ayahNumber,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       createdAt = Value(createdAt);
  static Insertable<Bookmark> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogEntriesTable extends ReviewLogEntries
    with TableInfo<$ReviewLogEntriesTable, ReviewLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    surahNumber,
    ayahNumber,
    kind,
    outcome,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_log_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $ReviewLogEntriesTable createAlias(String alias) {
    return $ReviewLogEntriesTable(attachedDatabase, alias);
  }
}

class ReviewLogEntry extends DataClass implements Insertable<ReviewLogEntry> {
  final String id;
  final String profileId;
  final int surahNumber;
  final int ayahNumber;

  /// 'memorize' | 'review'.
  final String kind;

  /// 'clean' | 'hesitant' | 'redo' — same values as
  /// [AyahProgressEntries.lastOutcome].
  final String outcome;
  final DateTime occurredAt;
  const ReviewLogEntry({
    required this.id,
    required this.profileId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.kind,
    required this.outcome,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['kind'] = Variable<String>(kind);
    map['outcome'] = Variable<String>(outcome);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  ReviewLogEntriesCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogEntriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      kind: Value(kind),
      outcome: Value(outcome),
      occurredAt: Value(occurredAt),
    );
  }

  factory ReviewLogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLogEntry(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      kind: serializer.fromJson<String>(json['kind']),
      outcome: serializer.fromJson<String>(json['outcome']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'kind': serializer.toJson<String>(kind),
      'outcome': serializer.toJson<String>(outcome),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  ReviewLogEntry copyWith({
    String? id,
    String? profileId,
    int? surahNumber,
    int? ayahNumber,
    String? kind,
    String? outcome,
    DateTime? occurredAt,
  }) => ReviewLogEntry(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    kind: kind ?? this.kind,
    outcome: outcome ?? this.outcome,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  ReviewLogEntry copyWithCompanion(ReviewLogEntriesCompanion data) {
    return ReviewLogEntry(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      kind: data.kind.present ? data.kind.value : this.kind,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogEntry(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('kind: $kind, ')
          ..write('outcome: $outcome, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    surahNumber,
    ayahNumber,
    kind,
    outcome,
    occurredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLogEntry &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.kind == this.kind &&
          other.outcome == this.outcome &&
          other.occurredAt == this.occurredAt);
}

class ReviewLogEntriesCompanion extends UpdateCompanion<ReviewLogEntry> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String> kind;
  final Value<String> outcome;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const ReviewLogEntriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.kind = const Value.absent(),
    this.outcome = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewLogEntriesCompanion.insert({
    required String id,
    required String profileId,
    required int surahNumber,
    required int ayahNumber,
    required String kind,
    required String outcome,
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       kind = Value(kind),
       outcome = Value(outcome),
       occurredAt = Value(occurredAt);
  static Insertable<ReviewLogEntry> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? kind,
    Expression<String>? outcome,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (kind != null) 'kind': kind,
      if (outcome != null) 'outcome': outcome,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewLogEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<String>? kind,
    Value<String>? outcome,
    Value<DateTime>? occurredAt,
    Value<int>? rowid,
  }) {
    return ReviewLogEntriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      kind: kind ?? this.kind,
      outcome: outcome ?? this.outcome,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('kind: $kind, ')
          ..write('outcome: $outcome, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudySessionEntriesTable extends StudySessionEntries
    with TableInfo<$StudySessionEntriesTable, StudySessionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahCountMeta = const VerificationMeta(
    'ayahCount',
  );
  @override
  late final GeneratedColumn<int> ayahCount = GeneratedColumn<int>(
    'ayah_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    kind,
    startedAt,
    durationSeconds,
    ayahCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_session_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudySessionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('ayah_count')) {
      context.handle(
        _ayahCountMeta,
        ayahCount.isAcceptableOrUnknown(data['ayah_count']!, _ayahCountMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySessionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySessionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      ayahCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_count'],
      )!,
    );
  }

  @override
  $StudySessionEntriesTable createAlias(String alias) {
    return $StudySessionEntriesTable(attachedDatabase, alias);
  }
}

class StudySessionEntry extends DataClass
    implements Insertable<StudySessionEntry> {
  final String id;
  final String profileId;

  /// 'memorization' | 'revision'.
  final String kind;
  final DateTime startedAt;
  final int durationSeconds;
  final int ayahCount;
  const StudySessionEntry({
    required this.id,
    required this.profileId,
    required this.kind,
    required this.startedAt,
    required this.durationSeconds,
    required this.ayahCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['kind'] = Variable<String>(kind);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['ayah_count'] = Variable<int>(ayahCount);
    return map;
  }

  StudySessionEntriesCompanion toCompanion(bool nullToAbsent) {
    return StudySessionEntriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      kind: Value(kind),
      startedAt: Value(startedAt),
      durationSeconds: Value(durationSeconds),
      ayahCount: Value(ayahCount),
    );
  }

  factory StudySessionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySessionEntry(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      kind: serializer.fromJson<String>(json['kind']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      ayahCount: serializer.fromJson<int>(json['ayahCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'kind': serializer.toJson<String>(kind),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'ayahCount': serializer.toJson<int>(ayahCount),
    };
  }

  StudySessionEntry copyWith({
    String? id,
    String? profileId,
    String? kind,
    DateTime? startedAt,
    int? durationSeconds,
    int? ayahCount,
  }) => StudySessionEntry(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    kind: kind ?? this.kind,
    startedAt: startedAt ?? this.startedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    ayahCount: ayahCount ?? this.ayahCount,
  );
  StudySessionEntry copyWithCompanion(StudySessionEntriesCompanion data) {
    return StudySessionEntry(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      kind: data.kind.present ? data.kind.value : this.kind,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      ayahCount: data.ayahCount.present ? data.ayahCount.value : this.ayahCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionEntry(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('kind: $kind, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('ayahCount: $ayahCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, kind, startedAt, durationSeconds, ayahCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySessionEntry &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.kind == this.kind &&
          other.startedAt == this.startedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.ayahCount == this.ayahCount);
}

class StudySessionEntriesCompanion extends UpdateCompanion<StudySessionEntry> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> kind;
  final Value<DateTime> startedAt;
  final Value<int> durationSeconds;
  final Value<int> ayahCount;
  final Value<int> rowid;
  const StudySessionEntriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.kind = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.ayahCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudySessionEntriesCompanion.insert({
    required String id,
    required String profileId,
    required String kind,
    required DateTime startedAt,
    required int durationSeconds,
    required int ayahCount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       kind = Value(kind),
       startedAt = Value(startedAt),
       durationSeconds = Value(durationSeconds),
       ayahCount = Value(ayahCount);
  static Insertable<StudySessionEntry> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? kind,
    Expression<DateTime>? startedAt,
    Expression<int>? durationSeconds,
    Expression<int>? ayahCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (kind != null) 'kind': kind,
      if (startedAt != null) 'started_at': startedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (ayahCount != null) 'ayah_count': ayahCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudySessionEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? kind,
    Value<DateTime>? startedAt,
    Value<int>? durationSeconds,
    Value<int>? ayahCount,
    Value<int>? rowid,
  }) {
    return StudySessionEntriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      kind: kind ?? this.kind,
      startedAt: startedAt ?? this.startedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      ayahCount: ayahCount ?? this.ayahCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (ayahCount.present) {
      map['ayah_count'] = Variable<int>(ayahCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('kind: $kind, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('ayahCount: $ayahCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $PassagesTable passages = $PassagesTable(this);
  late final $SessionProgressEntriesTable sessionProgressEntries =
      $SessionProgressEntriesTable(this);
  late final $AyahProgressEntriesTable ayahProgressEntries =
      $AyahProgressEntriesTable(this);
  late final $SurahProgressEntriesTable surahProgressEntries =
      $SurahProgressEntriesTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $ReviewLogEntriesTable reviewLogEntries = $ReviewLogEntriesTable(
    this,
  );
  late final $StudySessionEntriesTable studySessionEntries =
      $StudySessionEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    passages,
    sessionProgressEntries,
    ayahProgressEntries,
    surahProgressEntries,
    bookmarks,
    reviewLogEntries,
    studySessionEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('passages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'passages',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('session_progress_entries', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ayah_progress_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('surah_progress_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmarks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('review_log_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_session_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      Value<String> displayName,
      Value<String> memorizationLevel,
      Value<int> availableDaysMask,
      Value<int> dailyTargetMinutes,
      Value<String?> preferredQariId,
      Value<String> scriptMode,
      Value<bool> hasCompletedOnboarding,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<String> memorizationLevel,
      Value<int> availableDaysMask,
      Value<int> dailyTargetMinutes,
      Value<String?> preferredQariId,
      Value<String> scriptMode,
      Value<bool> hasCompletedOnboarding,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$UserProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile> {
  $$UserProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PassagesTable, List<Passage>> _passagesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.passages,
    aliasName: 'user_profiles__id__passages__profile_id',
  );

  $$PassagesTableProcessedTableManager get passagesRefs {
    final manager = $$PassagesTableTableManager(
      $_db,
      $_db.passages,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_passagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AyahProgressEntriesTable, List<AyahProgressEntry>>
  _ayahProgressEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ayahProgressEntries,
        aliasName: 'user_profiles__id__ayah_progress_entries__profile_id',
      );

  $$AyahProgressEntriesTableProcessedTableManager get ayahProgressEntriesRefs {
    final manager = $$AyahProgressEntriesTableTableManager(
      $_db,
      $_db.ayahProgressEntries,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ayahProgressEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $SurahProgressEntriesTable,
    List<SurahProgressEntry>
  >
  _surahProgressEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.surahProgressEntries,
        aliasName: 'user_profiles__id__surah_progress_entries__profile_id',
      );

  $$SurahProgressEntriesTableProcessedTableManager
  get surahProgressEntriesRefs {
    final manager = $$SurahProgressEntriesTableTableManager(
      $_db,
      $_db.surahProgressEntries,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _surahProgressEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookmarksTable, List<Bookmark>>
  _bookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookmarks,
    aliasName: 'user_profiles__id__bookmarks__profile_id',
  );

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager(
      $_db,
      $_db.bookmarks,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewLogEntriesTable, List<ReviewLogEntry>>
  _reviewLogEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewLogEntries,
    aliasName: 'user_profiles__id__review_log_entries__profile_id',
  );

  $$ReviewLogEntriesTableProcessedTableManager get reviewLogEntriesRefs {
    final manager = $$ReviewLogEntriesTableTableManager(
      $_db,
      $_db.reviewLogEntries,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reviewLogEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudySessionEntriesTable, List<StudySessionEntry>>
  _studySessionEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studySessionEntries,
        aliasName: 'user_profiles__id__study_session_entries__profile_id',
      );

  $$StudySessionEntriesTableProcessedTableManager get studySessionEntriesRefs {
    final manager = $$StudySessionEntriesTableTableManager(
      $_db,
      $_db.studySessionEntries,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studySessionEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
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

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memorizationLevel => $composableBuilder(
    column: $table.memorizationLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get availableDaysMask => $composableBuilder(
    column: $table.availableDaysMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyTargetMinutes => $composableBuilder(
    column: $table.dailyTargetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredQariId => $composableBuilder(
    column: $table.preferredQariId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scriptMode => $composableBuilder(
    column: $table.scriptMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> passagesRefs(
    Expression<bool> Function($$PassagesTableFilterComposer f) f,
  ) {
    final $$PassagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passages,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassagesTableFilterComposer(
            $db: $db,
            $table: $db.passages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ayahProgressEntriesRefs(
    Expression<bool> Function($$AyahProgressEntriesTableFilterComposer f) f,
  ) {
    final $$AyahProgressEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayahProgressEntries,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AyahProgressEntriesTableFilterComposer(
            $db: $db,
            $table: $db.ayahProgressEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> surahProgressEntriesRefs(
    Expression<bool> Function($$SurahProgressEntriesTableFilterComposer f) f,
  ) {
    final $$SurahProgressEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.surahProgressEntries,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahProgressEntriesTableFilterComposer(
            $db: $db,
            $table: $db.surahProgressEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookmarksRefs(
    Expression<bool> Function($$BookmarksTableFilterComposer f) f,
  ) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableFilterComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewLogEntriesRefs(
    Expression<bool> Function($$ReviewLogEntriesTableFilterComposer f) f,
  ) {
    final $$ReviewLogEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogEntries,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogEntriesTableFilterComposer(
            $db: $db,
            $table: $db.reviewLogEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studySessionEntriesRefs(
    Expression<bool> Function($$StudySessionEntriesTableFilterComposer f) f,
  ) {
    final $$StudySessionEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studySessionEntries,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionEntriesTableFilterComposer(
            $db: $db,
            $table: $db.studySessionEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memorizationLevel => $composableBuilder(
    column: $table.memorizationLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get availableDaysMask => $composableBuilder(
    column: $table.availableDaysMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyTargetMinutes => $composableBuilder(
    column: $table.dailyTargetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredQariId => $composableBuilder(
    column: $table.preferredQariId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scriptMode => $composableBuilder(
    column: $table.scriptMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memorizationLevel => $composableBuilder(
    column: $table.memorizationLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get availableDaysMask => $composableBuilder(
    column: $table.availableDaysMask,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyTargetMinutes => $composableBuilder(
    column: $table.dailyTargetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredQariId => $composableBuilder(
    column: $table.preferredQariId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scriptMode => $composableBuilder(
    column: $table.scriptMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> passagesRefs<T extends Object>(
    Expression<T> Function($$PassagesTableAnnotationComposer a) f,
  ) {
    final $$PassagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passages,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassagesTableAnnotationComposer(
            $db: $db,
            $table: $db.passages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ayahProgressEntriesRefs<T extends Object>(
    Expression<T> Function($$AyahProgressEntriesTableAnnotationComposer a) f,
  ) {
    final $$AyahProgressEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ayahProgressEntries,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AyahProgressEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.ayahProgressEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> surahProgressEntriesRefs<T extends Object>(
    Expression<T> Function($$SurahProgressEntriesTableAnnotationComposer a) f,
  ) {
    final $$SurahProgressEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.surahProgressEntries,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SurahProgressEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.surahProgressEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> bookmarksRefs<T extends Object>(
    Expression<T> Function($$BookmarksTableAnnotationComposer a) f,
  ) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableAnnotationComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewLogEntriesRefs<T extends Object>(
    Expression<T> Function($$ReviewLogEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReviewLogEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogEntries,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewLogEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studySessionEntriesRefs<T extends Object>(
    Expression<T> Function($$StudySessionEntriesTableAnnotationComposer a) f,
  ) {
    final $$StudySessionEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.studySessionEntries,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudySessionEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.studySessionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (UserProfile, $$UserProfilesTableReferences),
          UserProfile,
          PrefetchHooks Function({
            bool passagesRefs,
            bool ayahProgressEntriesRefs,
            bool surahProgressEntriesRefs,
            bool bookmarksRefs,
            bool reviewLogEntriesRefs,
            bool studySessionEntriesRefs,
          })
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> memorizationLevel = const Value.absent(),
                Value<int> availableDaysMask = const Value.absent(),
                Value<int> dailyTargetMinutes = const Value.absent(),
                Value<String?> preferredQariId = const Value.absent(),
                Value<String> scriptMode = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                displayName: displayName,
                memorizationLevel: memorizationLevel,
                availableDaysMask: availableDaysMask,
                dailyTargetMinutes: dailyTargetMinutes,
                preferredQariId: preferredQariId,
                scriptMode: scriptMode,
                hasCompletedOnboarding: hasCompletedOnboarding,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> displayName = const Value.absent(),
                Value<String> memorizationLevel = const Value.absent(),
                Value<int> availableDaysMask = const Value.absent(),
                Value<int> dailyTargetMinutes = const Value.absent(),
                Value<String?> preferredQariId = const Value.absent(),
                Value<String> scriptMode = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                memorizationLevel: memorizationLevel,
                availableDaysMask: availableDaysMask,
                dailyTargetMinutes: dailyTargetMinutes,
                preferredQariId: preferredQariId,
                scriptMode: scriptMode,
                hasCompletedOnboarding: hasCompletedOnboarding,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  $$UserProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                passagesRefs = false,
                ayahProgressEntriesRefs = false,
                surahProgressEntriesRefs = false,
                bookmarksRefs = false,
                reviewLogEntriesRefs = false,
                studySessionEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (passagesRefs) db.passages,
                    if (ayahProgressEntriesRefs) db.ayahProgressEntries,
                    if (surahProgressEntriesRefs) db.surahProgressEntries,
                    if (bookmarksRefs) db.bookmarks,
                    if (reviewLogEntriesRefs) db.reviewLogEntries,
                    if (studySessionEntriesRefs) db.studySessionEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (passagesRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          Passage
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._passagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).passagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ayahProgressEntriesRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          AyahProgressEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._ayahProgressEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).ayahProgressEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (surahProgressEntriesRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          SurahProgressEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._surahProgressEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).surahProgressEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookmarksRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          Bookmark
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._bookmarksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).bookmarksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewLogEntriesRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          ReviewLogEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._reviewLogEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewLogEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studySessionEntriesRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          StudySessionEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._studySessionEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).studySessionEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (UserProfile, $$UserProfilesTableReferences),
      UserProfile,
      PrefetchHooks Function({
        bool passagesRefs,
        bool ayahProgressEntriesRefs,
        bool surahProgressEntriesRefs,
        bool bookmarksRefs,
        bool reviewLogEntriesRefs,
        bool studySessionEntriesRefs,
      })
    >;
typedef $$PassagesTableCreateCompanionBuilder = PassagesCompanion Function({
  required String id,
  required String profileId,
  required int surahNumber,
  required int ayahStart,
  required int ayahEnd,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PassagesTableUpdateCompanionBuilder = PassagesCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<int> surahNumber,
  Value<int> ayahStart,
  Value<int> ayahEnd,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PassagesTableReferences
    extends BaseReferences<_$AppDatabase, $PassagesTable, Passage> {
  $$PassagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.userProfiles.createAlias('passages__profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $SessionProgressEntriesTable,
    List<SessionProgressEntry>
  >
  _sessionProgressEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sessionProgressEntries,
        aliasName: 'passages__id__session_progress_entries__passage_id',
      );

  $$SessionProgressEntriesTableProcessedTableManager
  get sessionProgressEntriesRefs {
    final manager = $$SessionProgressEntriesTableTableManager(
      $_db,
      $_db.sessionProgressEntries,
    ).filter((f) => f.passageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionProgressEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PassagesTableFilterComposer
    extends Composer<_$AppDatabase, $PassagesTable> {
  $$PassagesTableFilterComposer({
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

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahStart => $composableBuilder(
    column: $table.ayahStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahEnd => $composableBuilder(
    column: $table.ayahEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get profileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionProgressEntriesRefs(
    Expression<bool> Function($$SessionProgressEntriesTableFilterComposer f) f,
  ) {
    final $$SessionProgressEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.sessionProgressEntries,
          getReferencedColumn: (t) => t.passageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SessionProgressEntriesTableFilterComposer(
                $db: $db,
                $table: $db.sessionProgressEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PassagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PassagesTable> {
  $$PassagesTableOrderingComposer({
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

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahStart => $composableBuilder(
    column: $table.ayahStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahEnd => $composableBuilder(
    column: $table.ayahEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get profileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PassagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PassagesTable> {
  $$PassagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahStart =>
      $composableBuilder(column: $table.ayahStart, builder: (column) => column);

  GeneratedColumn<int> get ayahEnd =>
      $composableBuilder(column: $table.ayahEnd, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get profileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionProgressEntriesRefs<T extends Object>(
    Expression<T> Function($$SessionProgressEntriesTableAnnotationComposer a) f,
  ) {
    final $$SessionProgressEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.sessionProgressEntries,
          getReferencedColumn: (t) => t.passageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SessionProgressEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.sessionProgressEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PassagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PassagesTable,
          Passage,
          $$PassagesTableFilterComposer,
          $$PassagesTableOrderingComposer,
          $$PassagesTableAnnotationComposer,
          $$PassagesTableCreateCompanionBuilder,
          $$PassagesTableUpdateCompanionBuilder,
          (Passage, $$PassagesTableReferences),
          Passage,
          PrefetchHooks Function({
            bool profileId,
            bool sessionProgressEntriesRefs,
          })
        > {
  $$PassagesTableTableManager(_$AppDatabase db, $PassagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PassagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PassagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PassagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahStart = const Value.absent(),
                Value<int> ayahEnd = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PassagesCompanion(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                ayahStart: ayahStart,
                ayahEnd: ayahEnd,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required int surahNumber,
                required int ayahStart,
                required int ayahEnd,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PassagesCompanion.insert(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                ayahStart: ayahStart,
                ayahEnd: ayahEnd,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PassagesTable, Passage>(table),
                  $$PassagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, sessionProgressEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionProgressEntriesRefs) db.sessionProgressEntries,
                  ],
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
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$PassagesTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$PassagesTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionProgressEntriesRefs)
                        await $_getPrefetchedData<
                          Passage,
                          $PassagesTable,
                          SessionProgressEntry
                        >(
                          currentTable: table,
                          referencedTable: $$PassagesTableReferences
                              ._sessionProgressEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PassagesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionProgressEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.passageId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PassagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PassagesTable,
      Passage,
      $$PassagesTableFilterComposer,
      $$PassagesTableOrderingComposer,
      $$PassagesTableAnnotationComposer,
      $$PassagesTableCreateCompanionBuilder,
      $$PassagesTableUpdateCompanionBuilder,
      (Passage, $$PassagesTableReferences),
      Passage,
      PrefetchHooks Function({bool profileId, bool sessionProgressEntriesRefs})
    >;
typedef $$SessionProgressEntriesTableCreateCompanionBuilder =
    SessionProgressEntriesCompanion Function({
      required String id,
      required String passageId,
      Value<int> currentStepIndex,
      required int currentAyah,
      Value<String?> maskLevel,
      required DateTime startedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SessionProgressEntriesTableUpdateCompanionBuilder =
    SessionProgressEntriesCompanion Function({
      Value<String> id,
      Value<String> passageId,
      Value<int> currentStepIndex,
      Value<int> currentAyah,
      Value<String?> maskLevel,
      Value<DateTime> startedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SessionProgressEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SessionProgressEntriesTable,
          SessionProgressEntry
        > {
  $$SessionProgressEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PassagesTable _passageIdTable(_$AppDatabase db) => db.passages
      .createAlias('session_progress_entries__passage_id__passages__id');

  $$PassagesTableProcessedTableManager get passageId {
    final $_column = $_itemColumn<String>('passage_id')!;

    final manager = $$PassagesTableTableManager(
      $_db,
      $_db.passages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_passageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionProgressEntriesTable> {
  $$SessionProgressEntriesTableFilterComposer({
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

  ColumnFilters<int> get currentStepIndex => $composableBuilder(
    column: $table.currentStepIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentAyah => $composableBuilder(
    column: $table.currentAyah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maskLevel => $composableBuilder(
    column: $table.maskLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PassagesTableFilterComposer get passageId {
    final $$PassagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.passageId,
      referencedTable: $db.passages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassagesTableFilterComposer(
            $db: $db,
            $table: $db.passages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionProgressEntriesTable> {
  $$SessionProgressEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get currentStepIndex => $composableBuilder(
    column: $table.currentStepIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentAyah => $composableBuilder(
    column: $table.currentAyah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maskLevel => $composableBuilder(
    column: $table.maskLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PassagesTableOrderingComposer get passageId {
    final $$PassagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.passageId,
      referencedTable: $db.passages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassagesTableOrderingComposer(
            $db: $db,
            $table: $db.passages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionProgressEntriesTable> {
  $$SessionProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentStepIndex => $composableBuilder(
    column: $table.currentStepIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentAyah => $composableBuilder(
    column: $table.currentAyah,
    builder: (column) => column,
  );

  GeneratedColumn<String> get maskLevel =>
      $composableBuilder(column: $table.maskLevel, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PassagesTableAnnotationComposer get passageId {
    final $$PassagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.passageId,
      referencedTable: $db.passages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassagesTableAnnotationComposer(
            $db: $db,
            $table: $db.passages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionProgressEntriesTable,
          SessionProgressEntry,
          $$SessionProgressEntriesTableFilterComposer,
          $$SessionProgressEntriesTableOrderingComposer,
          $$SessionProgressEntriesTableAnnotationComposer,
          $$SessionProgressEntriesTableCreateCompanionBuilder,
          $$SessionProgressEntriesTableUpdateCompanionBuilder,
          (SessionProgressEntry, $$SessionProgressEntriesTableReferences),
          SessionProgressEntry,
          PrefetchHooks Function({bool passageId})
        > {
  $$SessionProgressEntriesTableTableManager(
    _$AppDatabase db,
    $SessionProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionProgressEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SessionProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SessionProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> passageId = const Value.absent(),
                Value<int> currentStepIndex = const Value.absent(),
                Value<int> currentAyah = const Value.absent(),
                Value<String?> maskLevel = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionProgressEntriesCompanion(
                id: id,
                passageId: passageId,
                currentStepIndex: currentStepIndex,
                currentAyah: currentAyah,
                maskLevel: maskLevel,
                startedAt: startedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String passageId,
                Value<int> currentStepIndex = const Value.absent(),
                required int currentAyah,
                Value<String?> maskLevel = const Value.absent(),
                required DateTime startedAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SessionProgressEntriesCompanion.insert(
                id: id,
                passageId: passageId,
                currentStepIndex: currentStepIndex,
                currentAyah: currentAyah,
                maskLevel: maskLevel,
                startedAt: startedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $SessionProgressEntriesTable,
                    SessionProgressEntry
                  >(table),
                  $$SessionProgressEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({passageId = false}) {
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
                    if (passageId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.passageId,
                        referencedTable: $$SessionProgressEntriesTableReferences
                            ._passageIdTable(db),
                        referencedColumn:
                            $$SessionProgressEntriesTableReferences
                                ._passageIdTable(db)
                                .id,
                      ) as T;
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

typedef $$SessionProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionProgressEntriesTable,
      SessionProgressEntry,
      $$SessionProgressEntriesTableFilterComposer,
      $$SessionProgressEntriesTableOrderingComposer,
      $$SessionProgressEntriesTableAnnotationComposer,
      $$SessionProgressEntriesTableCreateCompanionBuilder,
      $$SessionProgressEntriesTableUpdateCompanionBuilder,
      (SessionProgressEntry, $$SessionProgressEntriesTableReferences),
      SessionProgressEntry,
      PrefetchHooks Function({bool passageId})
    >;
typedef $$AyahProgressEntriesTableCreateCompanionBuilder =
    AyahProgressEntriesCompanion Function({
      required String id,
      required String profileId,
      required int surahNumber,
      required int ayahNumber,
      Value<String?> lastOutcome,
      Value<String> fragileWordIndices,
      Value<int> reviewCycleStep,
      required DateTime memorizedAt,
      required DateTime nextReviewAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AyahProgressEntriesTableUpdateCompanionBuilder =
    AyahProgressEntriesCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<String?> lastOutcome,
      Value<String> fragileWordIndices,
      Value<int> reviewCycleStep,
      Value<DateTime> memorizedAt,
      Value<DateTime> nextReviewAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AyahProgressEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AyahProgressEntriesTable,
          AyahProgressEntry
        > {
  $$AyahProgressEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTable _profileIdTable(_$AppDatabase db) => db.userProfiles
      .createAlias('ayah_progress_entries__profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AyahProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AyahProgressEntriesTable> {
  $$AyahProgressEntriesTableFilterComposer({
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

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastOutcome => $composableBuilder(
    column: $table.lastOutcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fragileWordIndices => $composableBuilder(
    column: $table.fragileWordIndices,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewCycleStep => $composableBuilder(
    column: $table.reviewCycleStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get memorizedAt => $composableBuilder(
    column: $table.memorizedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get profileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AyahProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AyahProgressEntriesTable> {
  $$AyahProgressEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastOutcome => $composableBuilder(
    column: $table.lastOutcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fragileWordIndices => $composableBuilder(
    column: $table.fragileWordIndices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewCycleStep => $composableBuilder(
    column: $table.reviewCycleStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get memorizedAt => $composableBuilder(
    column: $table.memorizedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get profileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AyahProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AyahProgressEntriesTable> {
  $$AyahProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastOutcome => $composableBuilder(
    column: $table.lastOutcome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fragileWordIndices => $composableBuilder(
    column: $table.fragileWordIndices,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewCycleStep => $composableBuilder(
    column: $table.reviewCycleStep,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get memorizedAt => $composableBuilder(
    column: $table.memorizedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get profileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AyahProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AyahProgressEntriesTable,
          AyahProgressEntry,
          $$AyahProgressEntriesTableFilterComposer,
          $$AyahProgressEntriesTableOrderingComposer,
          $$AyahProgressEntriesTableAnnotationComposer,
          $$AyahProgressEntriesTableCreateCompanionBuilder,
          $$AyahProgressEntriesTableUpdateCompanionBuilder,
          (AyahProgressEntry, $$AyahProgressEntriesTableReferences),
          AyahProgressEntry,
          PrefetchHooks Function({bool profileId})
        > {
  $$AyahProgressEntriesTableTableManager(
    _$AppDatabase db,
    $AyahProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AyahProgressEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AyahProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AyahProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<String?> lastOutcome = const Value.absent(),
                Value<String> fragileWordIndices = const Value.absent(),
                Value<int> reviewCycleStep = const Value.absent(),
                Value<DateTime> memorizedAt = const Value.absent(),
                Value<DateTime> nextReviewAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AyahProgressEntriesCompanion(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                lastOutcome: lastOutcome,
                fragileWordIndices: fragileWordIndices,
                reviewCycleStep: reviewCycleStep,
                memorizedAt: memorizedAt,
                nextReviewAt: nextReviewAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required int surahNumber,
                required int ayahNumber,
                Value<String?> lastOutcome = const Value.absent(),
                Value<String> fragileWordIndices = const Value.absent(),
                Value<int> reviewCycleStep = const Value.absent(),
                required DateTime memorizedAt,
                required DateTime nextReviewAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AyahProgressEntriesCompanion.insert(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                lastOutcome: lastOutcome,
                fragileWordIndices: fragileWordIndices,
                reviewCycleStep: reviewCycleStep,
                memorizedAt: memorizedAt,
                nextReviewAt: nextReviewAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AyahProgressEntriesTable, AyahProgressEntry>(
                    table,
                  ),
                  $$AyahProgressEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$AyahProgressEntriesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$AyahProgressEntriesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
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

typedef $$AyahProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AyahProgressEntriesTable,
      AyahProgressEntry,
      $$AyahProgressEntriesTableFilterComposer,
      $$AyahProgressEntriesTableOrderingComposer,
      $$AyahProgressEntriesTableAnnotationComposer,
      $$AyahProgressEntriesTableCreateCompanionBuilder,
      $$AyahProgressEntriesTableUpdateCompanionBuilder,
      (AyahProgressEntry, $$AyahProgressEntriesTableReferences),
      AyahProgressEntry,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$SurahProgressEntriesTableCreateCompanionBuilder =
    SurahProgressEntriesCompanion Function({
      required String id,
      required String profileId,
      required int surahNumber,
      Value<int> memorizedAyahCount,
      required int totalAyahCount,
      Value<DateTime?> completedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SurahProgressEntriesTableUpdateCompanionBuilder =
    SurahProgressEntriesCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<int> surahNumber,
      Value<int> memorizedAyahCount,
      Value<int> totalAyahCount,
      Value<DateTime?> completedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SurahProgressEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SurahProgressEntriesTable,
          SurahProgressEntry
        > {
  $$SurahProgressEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTable _profileIdTable(_$AppDatabase db) => db.userProfiles
      .createAlias('surah_progress_entries__profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SurahProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SurahProgressEntriesTable> {
  $$SurahProgressEntriesTableFilterComposer({
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

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memorizedAyahCount => $composableBuilder(
    column: $table.memorizedAyahCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAyahCount => $composableBuilder(
    column: $table.totalAyahCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get profileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SurahProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahProgressEntriesTable> {
  $$SurahProgressEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memorizedAyahCount => $composableBuilder(
    column: $table.memorizedAyahCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAyahCount => $composableBuilder(
    column: $table.totalAyahCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get profileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SurahProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahProgressEntriesTable> {
  $$SurahProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get memorizedAyahCount => $composableBuilder(
    column: $table.memorizedAyahCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAyahCount => $composableBuilder(
    column: $table.totalAyahCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get profileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SurahProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurahProgressEntriesTable,
          SurahProgressEntry,
          $$SurahProgressEntriesTableFilterComposer,
          $$SurahProgressEntriesTableOrderingComposer,
          $$SurahProgressEntriesTableAnnotationComposer,
          $$SurahProgressEntriesTableCreateCompanionBuilder,
          $$SurahProgressEntriesTableUpdateCompanionBuilder,
          (SurahProgressEntry, $$SurahProgressEntriesTableReferences),
          SurahProgressEntry,
          PrefetchHooks Function({bool profileId})
        > {
  $$SurahProgressEntriesTableTableManager(
    _$AppDatabase db,
    $SurahProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahProgressEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SurahProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> memorizedAyahCount = const Value.absent(),
                Value<int> totalAyahCount = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SurahProgressEntriesCompanion(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                memorizedAyahCount: memorizedAyahCount,
                totalAyahCount: totalAyahCount,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required int surahNumber,
                Value<int> memorizedAyahCount = const Value.absent(),
                required int totalAyahCount,
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SurahProgressEntriesCompanion.insert(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                memorizedAyahCount: memorizedAyahCount,
                totalAyahCount: totalAyahCount,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SurahProgressEntriesTable, SurahProgressEntry>(
                    table,
                  ),
                  $$SurahProgressEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$SurahProgressEntriesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$SurahProgressEntriesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
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

typedef $$SurahProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurahProgressEntriesTable,
      SurahProgressEntry,
      $$SurahProgressEntriesTableFilterComposer,
      $$SurahProgressEntriesTableOrderingComposer,
      $$SurahProgressEntriesTableAnnotationComposer,
      $$SurahProgressEntriesTableCreateCompanionBuilder,
      $$SurahProgressEntriesTableUpdateCompanionBuilder,
      (SurahProgressEntry, $$SurahProgressEntriesTableReferences),
      SurahProgressEntry,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  required String id,
  required String profileId,
  required int surahNumber,
  required int ayahNumber,
  Value<String?> note,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<int> surahNumber,
  Value<int> ayahNumber,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$BookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark> {
  $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.userProfiles.createAlias('bookmarks__profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
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

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get profileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
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

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get profileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get profileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (Bookmark, $$BookmarksTableReferences),
          Bookmark,
          PrefetchHooks Function({bool profileId})
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required int surahNumber,
                required int ayahNumber,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion.insert(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BookmarksTable, Bookmark>(table),
                  $$BookmarksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$BookmarksTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$BookmarksTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
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

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (Bookmark, $$BookmarksTableReferences),
      Bookmark,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$ReviewLogEntriesTableCreateCompanionBuilder =
    ReviewLogEntriesCompanion Function({
      required String id,
      required String profileId,
      required int surahNumber,
      required int ayahNumber,
      required String kind,
      required String outcome,
      required DateTime occurredAt,
      Value<int> rowid,
    });
typedef $$ReviewLogEntriesTableUpdateCompanionBuilder =
    ReviewLogEntriesCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<String> kind,
      Value<String> outcome,
      Value<DateTime> occurredAt,
      Value<int> rowid,
    });

final class $$ReviewLogEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReviewLogEntriesTable, ReviewLogEntry> {
  $$ReviewLogEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTable _profileIdTable(_$AppDatabase db) => db.userProfiles
      .createAlias('review_log_entries__profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewLogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogEntriesTable> {
  $$ReviewLogEntriesTableFilterComposer({
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

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get profileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogEntriesTable> {
  $$ReviewLogEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get profileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogEntriesTable> {
  $$ReviewLogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  $$UserProfilesTableAnnotationComposer get profileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewLogEntriesTable,
          ReviewLogEntry,
          $$ReviewLogEntriesTableFilterComposer,
          $$ReviewLogEntriesTableOrderingComposer,
          $$ReviewLogEntriesTableAnnotationComposer,
          $$ReviewLogEntriesTableCreateCompanionBuilder,
          $$ReviewLogEntriesTableUpdateCompanionBuilder,
          (ReviewLogEntry, $$ReviewLogEntriesTableReferences),
          ReviewLogEntry,
          PrefetchHooks Function({bool profileId})
        > {
  $$ReviewLogEntriesTableTableManager(
    _$AppDatabase db,
    $ReviewLogEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewLogEntriesCompanion(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                kind: kind,
                outcome: outcome,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required int surahNumber,
                required int ayahNumber,
                required String kind,
                required String outcome,
                required DateTime occurredAt,
                Value<int> rowid = const Value.absent(),
              }) => ReviewLogEntriesCompanion.insert(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                kind: kind,
                outcome: outcome,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewLogEntriesTable, ReviewLogEntry>(table),
                  $$ReviewLogEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$ReviewLogEntriesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$ReviewLogEntriesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
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

typedef $$ReviewLogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewLogEntriesTable,
      ReviewLogEntry,
      $$ReviewLogEntriesTableFilterComposer,
      $$ReviewLogEntriesTableOrderingComposer,
      $$ReviewLogEntriesTableAnnotationComposer,
      $$ReviewLogEntriesTableCreateCompanionBuilder,
      $$ReviewLogEntriesTableUpdateCompanionBuilder,
      (ReviewLogEntry, $$ReviewLogEntriesTableReferences),
      ReviewLogEntry,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$StudySessionEntriesTableCreateCompanionBuilder =
    StudySessionEntriesCompanion Function({
      required String id,
      required String profileId,
      required String kind,
      required DateTime startedAt,
      required int durationSeconds,
      required int ayahCount,
      Value<int> rowid,
    });
typedef $$StudySessionEntriesTableUpdateCompanionBuilder =
    StudySessionEntriesCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> kind,
      Value<DateTime> startedAt,
      Value<int> durationSeconds,
      Value<int> ayahCount,
      Value<int> rowid,
    });

final class $$StudySessionEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StudySessionEntriesTable,
          StudySessionEntry
        > {
  $$StudySessionEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTable _profileIdTable(_$AppDatabase db) => db.userProfiles
      .createAlias('study_session_entries__profile_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudySessionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $StudySessionEntriesTable> {
  $$StudySessionEntriesTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahCount => $composableBuilder(
    column: $table.ayahCount,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get profileId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySessionEntriesTable> {
  $$StudySessionEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahCount => $composableBuilder(
    column: $table.ayahCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get profileId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySessionEntriesTable> {
  $$StudySessionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahCount =>
      $composableBuilder(column: $table.ayahCount, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get profileId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudySessionEntriesTable,
          StudySessionEntry,
          $$StudySessionEntriesTableFilterComposer,
          $$StudySessionEntriesTableOrderingComposer,
          $$StudySessionEntriesTableAnnotationComposer,
          $$StudySessionEntriesTableCreateCompanionBuilder,
          $$StudySessionEntriesTableUpdateCompanionBuilder,
          (StudySessionEntry, $$StudySessionEntriesTableReferences),
          StudySessionEntry,
          PrefetchHooks Function({bool profileId})
        > {
  $$StudySessionEntriesTableTableManager(
    _$AppDatabase db,
    $StudySessionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySessionEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySessionEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StudySessionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> ayahCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudySessionEntriesCompanion(
                id: id,
                profileId: profileId,
                kind: kind,
                startedAt: startedAt,
                durationSeconds: durationSeconds,
                ayahCount: ayahCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String kind,
                required DateTime startedAt,
                required int durationSeconds,
                required int ayahCount,
                Value<int> rowid = const Value.absent(),
              }) => StudySessionEntriesCompanion.insert(
                id: id,
                profileId: profileId,
                kind: kind,
                startedAt: startedAt,
                durationSeconds: durationSeconds,
                ayahCount: ayahCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudySessionEntriesTable, StudySessionEntry>(
                    table,
                  ),
                  $$StudySessionEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$StudySessionEntriesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$StudySessionEntriesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
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

typedef $$StudySessionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudySessionEntriesTable,
      StudySessionEntry,
      $$StudySessionEntriesTableFilterComposer,
      $$StudySessionEntriesTableOrderingComposer,
      $$StudySessionEntriesTableAnnotationComposer,
      $$StudySessionEntriesTableCreateCompanionBuilder,
      $$StudySessionEntriesTableUpdateCompanionBuilder,
      (StudySessionEntry, $$StudySessionEntriesTableReferences),
      StudySessionEntry,
      PrefetchHooks Function({bool profileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$PassagesTableTableManager get passages =>
      $$PassagesTableTableManager(_db, _db.passages);
  $$SessionProgressEntriesTableTableManager get sessionProgressEntries =>
      $$SessionProgressEntriesTableTableManager(
        _db,
        _db.sessionProgressEntries,
      );
  $$AyahProgressEntriesTableTableManager get ayahProgressEntries =>
      $$AyahProgressEntriesTableTableManager(_db, _db.ayahProgressEntries);
  $$SurahProgressEntriesTableTableManager get surahProgressEntries =>
      $$SurahProgressEntriesTableTableManager(_db, _db.surahProgressEntries);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$ReviewLogEntriesTableTableManager get reviewLogEntries =>
      $$ReviewLogEntriesTableTableManager(_db, _db.reviewLogEntries);
  $$StudySessionEntriesTableTableManager get studySessionEntries =>
      $$StudySessionEntriesTableTableManager(_db, _db.studySessionEntries);
}
