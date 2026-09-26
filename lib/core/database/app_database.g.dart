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

class $MemorizationUnitsTable extends MemorizationUnits
    with TableInfo<$MemorizationUnitsTable, MemorizationUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemorizationUnitsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _startAyahMeta = const VerificationMeta(
    'startAyah',
  );
  @override
  late final GeneratedColumn<int> startAyah = GeneratedColumn<int>(
    'start_ayah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAyahMeta = const VerificationMeta(
    'endAyah',
  );
  @override
  late final GeneratedColumn<int> endAyah = GeneratedColumn<int>(
    'end_ayah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('not_started'),
  );
  static const VerificationMeta _masteryLevelMeta = const VerificationMeta(
    'masteryLevel',
  );
  @override
  late final GeneratedColumn<String> masteryLevel = GeneratedColumn<String>(
    'mastery_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _circleMeta = const VerificationMeta('circle');
  @override
  late final GeneratedColumn<int> circle = GeneratedColumn<int>(
    'circle',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextReviewDueAtMeta = const VerificationMeta(
    'nextReviewDueAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewDueAt =
      GeneratedColumn<DateTime>(
        'next_review_due_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
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
    startAyah,
    endAyah,
    status,
    masteryLevel,
    circle,
    lastReviewedAt,
    nextReviewDueAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memorization_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemorizationUnit> instance, {
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
    if (data.containsKey('start_ayah')) {
      context.handle(
        _startAyahMeta,
        startAyah.isAcceptableOrUnknown(data['start_ayah']!, _startAyahMeta),
      );
    } else if (isInserting) {
      context.missing(_startAyahMeta);
    }
    if (data.containsKey('end_ayah')) {
      context.handle(
        _endAyahMeta,
        endAyah.isAcceptableOrUnknown(data['end_ayah']!, _endAyahMeta),
      );
    } else if (isInserting) {
      context.missing(_endAyahMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('mastery_level')) {
      context.handle(
        _masteryLevelMeta,
        masteryLevel.isAcceptableOrUnknown(
          data['mastery_level']!,
          _masteryLevelMeta,
        ),
      );
    }
    if (data.containsKey('circle')) {
      context.handle(
        _circleMeta,
        circle.isAcceptableOrUnknown(data['circle']!, _circleMeta),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    if (data.containsKey('next_review_due_at')) {
      context.handle(
        _nextReviewDueAtMeta,
        nextReviewDueAt.isAcceptableOrUnknown(
          data['next_review_due_at']!,
          _nextReviewDueAtMeta,
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
  MemorizationUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemorizationUnit(
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
      startAyah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_ayah'],
      )!,
      endAyah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_ayah'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      masteryLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mastery_level'],
      ),
      circle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}circle'],
      ),
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      ),
      nextReviewDueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_due_at'],
      ),
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
  $MemorizationUnitsTable createAlias(String alias) {
    return $MemorizationUnitsTable(attachedDatabase, alias);
  }
}

class MemorizationUnit extends DataClass
    implements Insertable<MemorizationUnit> {
  final String id;
  final String profileId;
  final int surahNumber;
  final int startAyah;
  final int endAyah;

  /// 'not_started' | 'learning' | 'memorized'
  final String status;

  /// 'weak' | 'medium' | 'solid' — null until first review.
  final String? masteryLevel;

  /// Spaced-repetition circle ("Les Trois Cercles"): 1 = quotidien,
  /// 2 = hebdomadaire, 3 = mensuel. Null until the unit is memorized.
  final int? circle;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewDueAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MemorizationUnit({
    required this.id,
    required this.profileId,
    required this.surahNumber,
    required this.startAyah,
    required this.endAyah,
    required this.status,
    this.masteryLevel,
    this.circle,
    this.lastReviewedAt,
    this.nextReviewDueAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['surah_number'] = Variable<int>(surahNumber);
    map['start_ayah'] = Variable<int>(startAyah);
    map['end_ayah'] = Variable<int>(endAyah);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || masteryLevel != null) {
      map['mastery_level'] = Variable<String>(masteryLevel);
    }
    if (!nullToAbsent || circle != null) {
      map['circle'] = Variable<int>(circle);
    }
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    if (!nullToAbsent || nextReviewDueAt != null) {
      map['next_review_due_at'] = Variable<DateTime>(nextReviewDueAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MemorizationUnitsCompanion toCompanion(bool nullToAbsent) {
    return MemorizationUnitsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      surahNumber: Value(surahNumber),
      startAyah: Value(startAyah),
      endAyah: Value(endAyah),
      status: Value(status),
      masteryLevel: masteryLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(masteryLevel),
      circle: circle == null && nullToAbsent
          ? const Value.absent()
          : Value(circle),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      nextReviewDueAt: nextReviewDueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewDueAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MemorizationUnit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemorizationUnit(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      startAyah: serializer.fromJson<int>(json['startAyah']),
      endAyah: serializer.fromJson<int>(json['endAyah']),
      status: serializer.fromJson<String>(json['status']),
      masteryLevel: serializer.fromJson<String?>(json['masteryLevel']),
      circle: serializer.fromJson<int?>(json['circle']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      nextReviewDueAt: serializer.fromJson<DateTime?>(json['nextReviewDueAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
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
      'startAyah': serializer.toJson<int>(startAyah),
      'endAyah': serializer.toJson<int>(endAyah),
      'status': serializer.toJson<String>(status),
      'masteryLevel': serializer.toJson<String?>(masteryLevel),
      'circle': serializer.toJson<int?>(circle),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'nextReviewDueAt': serializer.toJson<DateTime?>(nextReviewDueAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MemorizationUnit copyWith({
    String? id,
    String? profileId,
    int? surahNumber,
    int? startAyah,
    int? endAyah,
    String? status,
    Value<String?> masteryLevel = const Value.absent(),
    Value<int?> circle = const Value.absent(),
    Value<DateTime?> lastReviewedAt = const Value.absent(),
    Value<DateTime?> nextReviewDueAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MemorizationUnit(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    surahNumber: surahNumber ?? this.surahNumber,
    startAyah: startAyah ?? this.startAyah,
    endAyah: endAyah ?? this.endAyah,
    status: status ?? this.status,
    masteryLevel: masteryLevel.present ? masteryLevel.value : this.masteryLevel,
    circle: circle.present ? circle.value : this.circle,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
    nextReviewDueAt: nextReviewDueAt.present
        ? nextReviewDueAt.value
        : this.nextReviewDueAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MemorizationUnit copyWithCompanion(MemorizationUnitsCompanion data) {
    return MemorizationUnit(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      startAyah: data.startAyah.present ? data.startAyah.value : this.startAyah,
      endAyah: data.endAyah.present ? data.endAyah.value : this.endAyah,
      status: data.status.present ? data.status.value : this.status,
      masteryLevel: data.masteryLevel.present
          ? data.masteryLevel.value
          : this.masteryLevel,
      circle: data.circle.present ? data.circle.value : this.circle,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      nextReviewDueAt: data.nextReviewDueAt.present
          ? data.nextReviewDueAt.value
          : this.nextReviewDueAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemorizationUnit(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('startAyah: $startAyah, ')
          ..write('endAyah: $endAyah, ')
          ..write('status: $status, ')
          ..write('masteryLevel: $masteryLevel, ')
          ..write('circle: $circle, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewDueAt: $nextReviewDueAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    surahNumber,
    startAyah,
    endAyah,
    status,
    masteryLevel,
    circle,
    lastReviewedAt,
    nextReviewDueAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemorizationUnit &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.surahNumber == this.surahNumber &&
          other.startAyah == this.startAyah &&
          other.endAyah == this.endAyah &&
          other.status == this.status &&
          other.masteryLevel == this.masteryLevel &&
          other.circle == this.circle &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.nextReviewDueAt == this.nextReviewDueAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MemorizationUnitsCompanion extends UpdateCompanion<MemorizationUnit> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int> surahNumber;
  final Value<int> startAyah;
  final Value<int> endAyah;
  final Value<String> status;
  final Value<String?> masteryLevel;
  final Value<int?> circle;
  final Value<DateTime?> lastReviewedAt;
  final Value<DateTime?> nextReviewDueAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MemorizationUnitsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.startAyah = const Value.absent(),
    this.endAyah = const Value.absent(),
    this.status = const Value.absent(),
    this.masteryLevel = const Value.absent(),
    this.circle = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.nextReviewDueAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemorizationUnitsCompanion.insert({
    required String id,
    required String profileId,
    required int surahNumber,
    required int startAyah,
    required int endAyah,
    this.status = const Value.absent(),
    this.masteryLevel = const Value.absent(),
    this.circle = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.nextReviewDueAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       surahNumber = Value(surahNumber),
       startAyah = Value(startAyah),
       endAyah = Value(endAyah),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MemorizationUnit> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? surahNumber,
    Expression<int>? startAyah,
    Expression<int>? endAyah,
    Expression<String>? status,
    Expression<String>? masteryLevel,
    Expression<int>? circle,
    Expression<DateTime>? lastReviewedAt,
    Expression<DateTime>? nextReviewDueAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (startAyah != null) 'start_ayah': startAyah,
      if (endAyah != null) 'end_ayah': endAyah,
      if (status != null) 'status': status,
      if (masteryLevel != null) 'mastery_level': masteryLevel,
      if (circle != null) 'circle': circle,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (nextReviewDueAt != null) 'next_review_due_at': nextReviewDueAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemorizationUnitsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int>? surahNumber,
    Value<int>? startAyah,
    Value<int>? endAyah,
    Value<String>? status,
    Value<String?>? masteryLevel,
    Value<int?>? circle,
    Value<DateTime?>? lastReviewedAt,
    Value<DateTime?>? nextReviewDueAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MemorizationUnitsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      surahNumber: surahNumber ?? this.surahNumber,
      startAyah: startAyah ?? this.startAyah,
      endAyah: endAyah ?? this.endAyah,
      status: status ?? this.status,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      circle: circle ?? this.circle,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewDueAt: nextReviewDueAt ?? this.nextReviewDueAt,
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
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (startAyah.present) {
      map['start_ayah'] = Variable<int>(startAyah.value);
    }
    if (endAyah.present) {
      map['end_ayah'] = Variable<int>(endAyah.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (masteryLevel.present) {
      map['mastery_level'] = Variable<String>(masteryLevel.value);
    }
    if (circle.present) {
      map['circle'] = Variable<int>(circle.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (nextReviewDueAt.present) {
      map['next_review_due_at'] = Variable<DateTime>(nextReviewDueAt.value);
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
    return (StringBuffer('MemorizationUnitsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('startAyah: $startAyah, ')
          ..write('endAyah: $endAyah, ')
          ..write('status: $status, ')
          ..write('masteryLevel: $masteryLevel, ')
          ..write('circle: $circle, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewDueAt: $nextReviewDueAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewHistoryEntriesTable extends ReviewHistoryEntries
    with TableInfo<$ReviewHistoryEntriesTable, ReviewHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewHistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES memorization_units (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _circleBeforeMeta = const VerificationMeta(
    'circleBefore',
  );
  @override
  late final GeneratedColumn<int> circleBefore = GeneratedColumn<int>(
    'circle_before',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _circleAfterMeta = const VerificationMeta(
    'circleAfter',
  );
  @override
  late final GeneratedColumn<int> circleAfter = GeneratedColumn<int>(
    'circle_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    unitId,
    reviewedAt,
    result,
    circleBefore,
    circleAfter,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_history_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewHistoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('circle_before')) {
      context.handle(
        _circleBeforeMeta,
        circleBefore.isAcceptableOrUnknown(
          data['circle_before']!,
          _circleBeforeMeta,
        ),
      );
    }
    if (data.containsKey('circle_after')) {
      context.handle(
        _circleAfterMeta,
        circleAfter.isAcceptableOrUnknown(
          data['circle_after']!,
          _circleAfterMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewHistoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      circleBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}circle_before'],
      ),
      circleAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}circle_after'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReviewHistoryEntriesTable createAlias(String alias) {
    return $ReviewHistoryEntriesTable(attachedDatabase, alias);
  }
}

class ReviewHistoryEntry extends DataClass
    implements Insertable<ReviewHistoryEntry> {
  final String id;
  final String unitId;
  final DateTime reviewedAt;

  /// 'success' | 'fail'
  final String result;
  final int? circleBefore;
  final int? circleAfter;
  final DateTime createdAt;
  const ReviewHistoryEntry({
    required this.id,
    required this.unitId,
    required this.reviewedAt,
    required this.result,
    this.circleBefore,
    this.circleAfter,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unit_id'] = Variable<String>(unitId);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    map['result'] = Variable<String>(result);
    if (!nullToAbsent || circleBefore != null) {
      map['circle_before'] = Variable<int>(circleBefore);
    }
    if (!nullToAbsent || circleAfter != null) {
      map['circle_after'] = Variable<int>(circleAfter);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReviewHistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return ReviewHistoryEntriesCompanion(
      id: Value(id),
      unitId: Value(unitId),
      reviewedAt: Value(reviewedAt),
      result: Value(result),
      circleBefore: circleBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(circleBefore),
      circleAfter: circleAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(circleAfter),
      createdAt: Value(createdAt),
    );
  }

  factory ReviewHistoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewHistoryEntry(
      id: serializer.fromJson<String>(json['id']),
      unitId: serializer.fromJson<String>(json['unitId']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
      result: serializer.fromJson<String>(json['result']),
      circleBefore: serializer.fromJson<int?>(json['circleBefore']),
      circleAfter: serializer.fromJson<int?>(json['circleAfter']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unitId': serializer.toJson<String>(unitId),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
      'result': serializer.toJson<String>(result),
      'circleBefore': serializer.toJson<int?>(circleBefore),
      'circleAfter': serializer.toJson<int?>(circleAfter),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReviewHistoryEntry copyWith({
    String? id,
    String? unitId,
    DateTime? reviewedAt,
    String? result,
    Value<int?> circleBefore = const Value.absent(),
    Value<int?> circleAfter = const Value.absent(),
    DateTime? createdAt,
  }) => ReviewHistoryEntry(
    id: id ?? this.id,
    unitId: unitId ?? this.unitId,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    result: result ?? this.result,
    circleBefore: circleBefore.present ? circleBefore.value : this.circleBefore,
    circleAfter: circleAfter.present ? circleAfter.value : this.circleAfter,
    createdAt: createdAt ?? this.createdAt,
  );
  ReviewHistoryEntry copyWithCompanion(ReviewHistoryEntriesCompanion data) {
    return ReviewHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      result: data.result.present ? data.result.value : this.result,
      circleBefore: data.circleBefore.present
          ? data.circleBefore.value
          : this.circleBefore,
      circleAfter: data.circleAfter.present
          ? data.circleAfter.value
          : this.circleAfter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewHistoryEntry(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('result: $result, ')
          ..write('circleBefore: $circleBefore, ')
          ..write('circleAfter: $circleAfter, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    unitId,
    reviewedAt,
    result,
    circleBefore,
    circleAfter,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewHistoryEntry &&
          other.id == this.id &&
          other.unitId == this.unitId &&
          other.reviewedAt == this.reviewedAt &&
          other.result == this.result &&
          other.circleBefore == this.circleBefore &&
          other.circleAfter == this.circleAfter &&
          other.createdAt == this.createdAt);
}

class ReviewHistoryEntriesCompanion
    extends UpdateCompanion<ReviewHistoryEntry> {
  final Value<String> id;
  final Value<String> unitId;
  final Value<DateTime> reviewedAt;
  final Value<String> result;
  final Value<int?> circleBefore;
  final Value<int?> circleAfter;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReviewHistoryEntriesCompanion({
    this.id = const Value.absent(),
    this.unitId = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.result = const Value.absent(),
    this.circleBefore = const Value.absent(),
    this.circleAfter = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewHistoryEntriesCompanion.insert({
    required String id,
    required String unitId,
    required DateTime reviewedAt,
    required String result,
    this.circleBefore = const Value.absent(),
    this.circleAfter = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       unitId = Value(unitId),
       reviewedAt = Value(reviewedAt),
       result = Value(result),
       createdAt = Value(createdAt);
  static Insertable<ReviewHistoryEntry> custom({
    Expression<String>? id,
    Expression<String>? unitId,
    Expression<DateTime>? reviewedAt,
    Expression<String>? result,
    Expression<int>? circleBefore,
    Expression<int>? circleAfter,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitId != null) 'unit_id': unitId,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (result != null) 'result': result,
      if (circleBefore != null) 'circle_before': circleBefore,
      if (circleAfter != null) 'circle_after': circleAfter,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewHistoryEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? unitId,
    Value<DateTime>? reviewedAt,
    Value<String>? result,
    Value<int?>? circleBefore,
    Value<int?>? circleAfter,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReviewHistoryEntriesCompanion(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      result: result ?? this.result,
      circleBefore: circleBefore ?? this.circleBefore,
      circleAfter: circleAfter ?? this.circleAfter,
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
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (circleBefore.present) {
      map['circle_before'] = Variable<int>(circleBefore.value);
    }
    if (circleAfter.present) {
      map['circle_after'] = Variable<int>(circleAfter.value);
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
    return (StringBuffer('ReviewHistoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('result: $result, ')
          ..write('circleBefore: $circleBefore, ')
          ..write('circleAfter: $circleAfter, ')
          ..write('createdAt: $createdAt, ')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $MemorizationUnitsTable memorizationUnits =
      $MemorizationUnitsTable(this);
  late final $ReviewHistoryEntriesTable reviewHistoryEntries =
      $ReviewHistoryEntriesTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    memorizationUnits,
    reviewHistoryEntries,
    bookmarks,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memorization_units', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'memorization_units',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('review_history_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmarks', kind: UpdateKind.delete)],
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

  static MultiTypedResultKey<$MemorizationUnitsTable, List<MemorizationUnit>>
  _memorizationUnitsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.memorizationUnits,
        aliasName: 'user_profiles__id__memorization_units__profile_id',
      );

  $$MemorizationUnitsTableProcessedTableManager get memorizationUnitsRefs {
    final manager = $$MemorizationUnitsTableTableManager(
      $_db,
      $_db.memorizationUnits,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memorizationUnitsRefsTable($_db),
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

  Expression<bool> memorizationUnitsRefs(
    Expression<bool> Function($$MemorizationUnitsTableFilterComposer f) f,
  ) {
    final $$MemorizationUnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memorizationUnits,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemorizationUnitsTableFilterComposer(
            $db: $db,
            $table: $db.memorizationUnits,
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

  Expression<T> memorizationUnitsRefs<T extends Object>(
    Expression<T> Function($$MemorizationUnitsTableAnnotationComposer a) f,
  ) {
    final $$MemorizationUnitsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.memorizationUnits,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemorizationUnitsTableAnnotationComposer(
                $db: $db,
                $table: $db.memorizationUnits,
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
            bool memorizationUnitsRefs,
            bool bookmarksRefs,
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
              ({memorizationUnitsRefs = false, bookmarksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (memorizationUnitsRefs) db.memorizationUnits,
                    if (bookmarksRefs) db.bookmarks,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (memorizationUnitsRefs)
                        await $_getPrefetchedData<
                          UserProfile,
                          $UserProfilesTable,
                          MemorizationUnit
                        >(
                          currentTable: table,
                          referencedTable: $$UserProfilesTableReferences
                              ._memorizationUnitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).memorizationUnitsRefs,
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
      PrefetchHooks Function({bool memorizationUnitsRefs, bool bookmarksRefs})
    >;
typedef $$MemorizationUnitsTableCreateCompanionBuilder =
    MemorizationUnitsCompanion Function({
      required String id,
      required String profileId,
      required int surahNumber,
      required int startAyah,
      required int endAyah,
      Value<String> status,
      Value<String?> masteryLevel,
      Value<int?> circle,
      Value<DateTime?> lastReviewedAt,
      Value<DateTime?> nextReviewDueAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MemorizationUnitsTableUpdateCompanionBuilder =
    MemorizationUnitsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<int> surahNumber,
      Value<int> startAyah,
      Value<int> endAyah,
      Value<String> status,
      Value<String?> masteryLevel,
      Value<int?> circle,
      Value<DateTime?> lastReviewedAt,
      Value<DateTime?> nextReviewDueAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MemorizationUnitsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MemorizationUnitsTable,
          MemorizationUnit
        > {
  $$MemorizationUnitsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTable _profileIdTable(_$AppDatabase db) => db.userProfiles
      .createAlias('memorization_units__profile_id__user_profiles__id');

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
    $ReviewHistoryEntriesTable,
    List<ReviewHistoryEntry>
  >
  _reviewHistoryEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.reviewHistoryEntries,
        aliasName: 'memorization_units__id__review_history_entries__unit_id',
      );

  $$ReviewHistoryEntriesTableProcessedTableManager
  get reviewHistoryEntriesRefs {
    final manager = $$ReviewHistoryEntriesTableTableManager(
      $_db,
      $_db.reviewHistoryEntries,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reviewHistoryEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MemorizationUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $MemorizationUnitsTable> {
  $$MemorizationUnitsTableFilterComposer({
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

  ColumnFilters<int> get startAyah => $composableBuilder(
    column: $table.startAyah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endAyah => $composableBuilder(
    column: $table.endAyah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get masteryLevel => $composableBuilder(
    column: $table.masteryLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get circle => $composableBuilder(
    column: $table.circle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewDueAt => $composableBuilder(
    column: $table.nextReviewDueAt,
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

  Expression<bool> reviewHistoryEntriesRefs(
    Expression<bool> Function($$ReviewHistoryEntriesTableFilterComposer f) f,
  ) {
    final $$ReviewHistoryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewHistoryEntries,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewHistoryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.reviewHistoryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemorizationUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemorizationUnitsTable> {
  $$MemorizationUnitsTableOrderingComposer({
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

  ColumnOrderings<int> get startAyah => $composableBuilder(
    column: $table.startAyah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endAyah => $composableBuilder(
    column: $table.endAyah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get masteryLevel => $composableBuilder(
    column: $table.masteryLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get circle => $composableBuilder(
    column: $table.circle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewDueAt => $composableBuilder(
    column: $table.nextReviewDueAt,
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

class $$MemorizationUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemorizationUnitsTable> {
  $$MemorizationUnitsTableAnnotationComposer({
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

  GeneratedColumn<int> get startAyah =>
      $composableBuilder(column: $table.startAyah, builder: (column) => column);

  GeneratedColumn<int> get endAyah =>
      $composableBuilder(column: $table.endAyah, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get masteryLevel => $composableBuilder(
    column: $table.masteryLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get circle =>
      $composableBuilder(column: $table.circle, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewDueAt => $composableBuilder(
    column: $table.nextReviewDueAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

  Expression<T> reviewHistoryEntriesRefs<T extends Object>(
    Expression<T> Function($$ReviewHistoryEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReviewHistoryEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.reviewHistoryEntries,
          getReferencedColumn: (t) => t.unitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReviewHistoryEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.reviewHistoryEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MemorizationUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemorizationUnitsTable,
          MemorizationUnit,
          $$MemorizationUnitsTableFilterComposer,
          $$MemorizationUnitsTableOrderingComposer,
          $$MemorizationUnitsTableAnnotationComposer,
          $$MemorizationUnitsTableCreateCompanionBuilder,
          $$MemorizationUnitsTableUpdateCompanionBuilder,
          (MemorizationUnit, $$MemorizationUnitsTableReferences),
          MemorizationUnit,
          PrefetchHooks Function({
            bool profileId,
            bool reviewHistoryEntriesRefs,
          })
        > {
  $$MemorizationUnitsTableTableManager(
    _$AppDatabase db,
    $MemorizationUnitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemorizationUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemorizationUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemorizationUnitsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> startAyah = const Value.absent(),
                Value<int> endAyah = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> masteryLevel = const Value.absent(),
                Value<int?> circle = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime?> nextReviewDueAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemorizationUnitsCompanion(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                startAyah: startAyah,
                endAyah: endAyah,
                status: status,
                masteryLevel: masteryLevel,
                circle: circle,
                lastReviewedAt: lastReviewedAt,
                nextReviewDueAt: nextReviewDueAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required int surahNumber,
                required int startAyah,
                required int endAyah,
                Value<String> status = const Value.absent(),
                Value<String?> masteryLevel = const Value.absent(),
                Value<int?> circle = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime?> nextReviewDueAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MemorizationUnitsCompanion.insert(
                id: id,
                profileId: profileId,
                surahNumber: surahNumber,
                startAyah: startAyah,
                endAyah: endAyah,
                status: status,
                masteryLevel: masteryLevel,
                circle: circle,
                lastReviewedAt: lastReviewedAt,
                nextReviewDueAt: nextReviewDueAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MemorizationUnitsTable, MemorizationUnit>(table),
                  $$MemorizationUnitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, reviewHistoryEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (reviewHistoryEntriesRefs) db.reviewHistoryEntries,
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
                            referencedTable: $$MemorizationUnitsTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$MemorizationUnitsTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reviewHistoryEntriesRefs)
                        await $_getPrefetchedData<
                          MemorizationUnit,
                          $MemorizationUnitsTable,
                          ReviewHistoryEntry
                        >(
                          currentTable: table,
                          referencedTable: $$MemorizationUnitsTableReferences
                              ._reviewHistoryEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MemorizationUnitsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewHistoryEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
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

typedef $$MemorizationUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemorizationUnitsTable,
      MemorizationUnit,
      $$MemorizationUnitsTableFilterComposer,
      $$MemorizationUnitsTableOrderingComposer,
      $$MemorizationUnitsTableAnnotationComposer,
      $$MemorizationUnitsTableCreateCompanionBuilder,
      $$MemorizationUnitsTableUpdateCompanionBuilder,
      (MemorizationUnit, $$MemorizationUnitsTableReferences),
      MemorizationUnit,
      PrefetchHooks Function({bool profileId, bool reviewHistoryEntriesRefs})
    >;
typedef $$ReviewHistoryEntriesTableCreateCompanionBuilder =
    ReviewHistoryEntriesCompanion Function({
      required String id,
      required String unitId,
      required DateTime reviewedAt,
      required String result,
      Value<int?> circleBefore,
      Value<int?> circleAfter,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ReviewHistoryEntriesTableUpdateCompanionBuilder =
    ReviewHistoryEntriesCompanion Function({
      Value<String> id,
      Value<String> unitId,
      Value<DateTime> reviewedAt,
      Value<String> result,
      Value<int?> circleBefore,
      Value<int?> circleAfter,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ReviewHistoryEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReviewHistoryEntriesTable,
          ReviewHistoryEntry
        > {
  $$ReviewHistoryEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MemorizationUnitsTable _unitIdTable(_$AppDatabase db) => db
      .memorizationUnits
      .createAlias('review_history_entries__unit_id__memorization_units__id');

  $$MemorizationUnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<String>('unit_id')!;

    final manager = $$MemorizationUnitsTableTableManager(
      $_db,
      $_db.memorizationUnits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewHistoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewHistoryEntriesTable> {
  $$ReviewHistoryEntriesTableFilterComposer({
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

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get circleBefore => $composableBuilder(
    column: $table.circleBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get circleAfter => $composableBuilder(
    column: $table.circleAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MemorizationUnitsTableFilterComposer get unitId {
    final $$MemorizationUnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.memorizationUnits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemorizationUnitsTableFilterComposer(
            $db: $db,
            $table: $db.memorizationUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewHistoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewHistoryEntriesTable> {
  $$ReviewHistoryEntriesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get circleBefore => $composableBuilder(
    column: $table.circleBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get circleAfter => $composableBuilder(
    column: $table.circleAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MemorizationUnitsTableOrderingComposer get unitId {
    final $$MemorizationUnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.memorizationUnits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemorizationUnitsTableOrderingComposer(
            $db: $db,
            $table: $db.memorizationUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewHistoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewHistoryEntriesTable> {
  $$ReviewHistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<int> get circleBefore => $composableBuilder(
    column: $table.circleBefore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get circleAfter => $composableBuilder(
    column: $table.circleAfter,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MemorizationUnitsTableAnnotationComposer get unitId {
    final $$MemorizationUnitsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.unitId,
          referencedTable: $db.memorizationUnits,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemorizationUnitsTableAnnotationComposer(
                $db: $db,
                $table: $db.memorizationUnits,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReviewHistoryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewHistoryEntriesTable,
          ReviewHistoryEntry,
          $$ReviewHistoryEntriesTableFilterComposer,
          $$ReviewHistoryEntriesTableOrderingComposer,
          $$ReviewHistoryEntriesTableAnnotationComposer,
          $$ReviewHistoryEntriesTableCreateCompanionBuilder,
          $$ReviewHistoryEntriesTableUpdateCompanionBuilder,
          (ReviewHistoryEntry, $$ReviewHistoryEntriesTableReferences),
          ReviewHistoryEntry,
          PrefetchHooks Function({bool unitId})
        > {
  $$ReviewHistoryEntriesTableTableManager(
    _$AppDatabase db,
    $ReviewHistoryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewHistoryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewHistoryEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReviewHistoryEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> unitId = const Value.absent(),
                Value<DateTime> reviewedAt = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<int?> circleBefore = const Value.absent(),
                Value<int?> circleAfter = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewHistoryEntriesCompanion(
                id: id,
                unitId: unitId,
                reviewedAt: reviewedAt,
                result: result,
                circleBefore: circleBefore,
                circleAfter: circleAfter,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String unitId,
                required DateTime reviewedAt,
                required String result,
                Value<int?> circleBefore = const Value.absent(),
                Value<int?> circleAfter = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReviewHistoryEntriesCompanion.insert(
                id: id,
                unitId: unitId,
                reviewedAt: reviewedAt,
                result: result,
                circleBefore: circleBefore,
                circleAfter: circleAfter,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewHistoryEntriesTable, ReviewHistoryEntry>(
                    table,
                  ),
                  $$ReviewHistoryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unitId = false}) {
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
                    if (unitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.unitId,
                        referencedTable: $$ReviewHistoryEntriesTableReferences
                            ._unitIdTable(db),
                        referencedColumn: $$ReviewHistoryEntriesTableReferences
                            ._unitIdTable(db)
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

typedef $$ReviewHistoryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewHistoryEntriesTable,
      ReviewHistoryEntry,
      $$ReviewHistoryEntriesTableFilterComposer,
      $$ReviewHistoryEntriesTableOrderingComposer,
      $$ReviewHistoryEntriesTableAnnotationComposer,
      $$ReviewHistoryEntriesTableCreateCompanionBuilder,
      $$ReviewHistoryEntriesTableUpdateCompanionBuilder,
      (ReviewHistoryEntry, $$ReviewHistoryEntriesTableReferences),
      ReviewHistoryEntry,
      PrefetchHooks Function({bool unitId})
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$MemorizationUnitsTableTableManager get memorizationUnits =>
      $$MemorizationUnitsTableTableManager(_db, _db.memorizationUnits);
  $$ReviewHistoryEntriesTableTableManager get reviewHistoryEntries =>
      $$ReviewHistoryEntriesTableTableManager(_db, _db.reviewHistoryEntries);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
}
