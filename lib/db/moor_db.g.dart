// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Favor extends DataClass implements Insertable<Favor> {
  final int id;
  final String eventId;
  final String name;
  final String location;
  final String date;
  final bool favorite;
  Favor(
      {@required this.id,
      @required this.eventId,
      @required this.name,
      @required this.location,
      @required this.date,
      @required this.favorite});
  factory Favor.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Favor(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      eventId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}event_id']),
      name: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}event_name']),
      location: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}event_location']),
      date: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}event_date']),
      favorite:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}event_fav']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || eventId != null) {
      map['event_id'] = Variable<String>(eventId);
    }
    if (!nullToAbsent || name != null) {
      map['event_name'] = Variable<String>(name);
    }
    if (!nullToAbsent || location != null) {
      map['event_location'] = Variable<String>(location);
    }
    if (!nullToAbsent || date != null) {
      map['event_date'] = Variable<String>(date);
    }
    if (!nullToAbsent || favorite != null) {
      map['event_fav'] = Variable<bool>(favorite);
    }
    return map;
  }

  FavorsCompanion toCompanion(bool nullToAbsent) {
    return FavorsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      eventId: eventId == null && nullToAbsent
          ? const Value.absent()
          : Value(eventId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      favorite: favorite == null && nullToAbsent
          ? const Value.absent()
          : Value(favorite),
    );
  }

  factory Favor.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Favor(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String>(json['location']),
      date: serializer.fromJson<String>(json['date']),
      favorite: serializer.fromJson<bool>(json['favorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<String>(eventId),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String>(location),
      'date': serializer.toJson<String>(date),
      'favorite': serializer.toJson<bool>(favorite),
    };
  }

  Favor copyWith(
          {int id,
          String eventId,
          String name,
          String location,
          String date,
          bool favorite}) =>
      Favor(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        name: name ?? this.name,
        location: location ?? this.location,
        date: date ?? this.date,
        favorite: favorite ?? this.favorite,
      );
  @override
  String toString() {
    return (StringBuffer('Favor(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('date: $date, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          eventId.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(location.hashCode,
                  $mrjc(date.hashCode, favorite.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Favor &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.name == this.name &&
          other.location == this.location &&
          other.date == this.date &&
          other.favorite == this.favorite);
}

class FavorsCompanion extends UpdateCompanion<Favor> {
  final Value<int> id;
  final Value<String> eventId;
  final Value<String> name;
  final Value<String> location;
  final Value<String> date;
  final Value<bool> favorite;
  const FavorsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.date = const Value.absent(),
    this.favorite = const Value.absent(),
  });
  FavorsCompanion.insert({
    this.id = const Value.absent(),
    @required String eventId,
    @required String name,
    @required String location,
    @required String date,
    @required bool favorite,
  })  : eventId = Value(eventId),
        name = Value(name),
        location = Value(location),
        date = Value(date),
        favorite = Value(favorite);
  static Insertable<Favor> custom({
    Expression<int> id,
    Expression<String> eventId,
    Expression<String> name,
    Expression<String> location,
    Expression<String> date,
    Expression<bool> favorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (name != null) 'event_name': name,
      if (location != null) 'event_location': location,
      if (date != null) 'event_date': date,
      if (favorite != null) 'event_fav': favorite,
    });
  }

  FavorsCompanion copyWith(
      {Value<int> id,
      Value<String> eventId,
      Value<String> name,
      Value<String> location,
      Value<String> date,
      Value<bool> favorite}) {
    return FavorsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
      location: location ?? this.location,
      date: date ?? this.date,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (name.present) {
      map['event_name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['event_location'] = Variable<String>(location.value);
    }
    if (date.present) {
      map['event_date'] = Variable<String>(date.value);
    }
    if (favorite.present) {
      map['event_fav'] = Variable<bool>(favorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavorsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('date: $date, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }
}

class $FavorsTable extends Favors with TableInfo<$FavorsTable, Favor> {
  final GeneratedDatabase _db;
  final String _alias;
  $FavorsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _eventIdMeta = const VerificationMeta('eventId');
  GeneratedTextColumn _eventId;
  @override
  GeneratedTextColumn get eventId => _eventId ??= _constructEventId();
  GeneratedTextColumn _constructEventId() {
    return GeneratedTextColumn('event_id', $tableName, false,
        $customConstraints: 'REMOVE UNIQUE');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'event_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _locationMeta = const VerificationMeta('location');
  GeneratedTextColumn _location;
  @override
  GeneratedTextColumn get location => _location ??= _constructLocation();
  GeneratedTextColumn _constructLocation() {
    return GeneratedTextColumn(
      'event_location',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedTextColumn _date;
  @override
  GeneratedTextColumn get date => _date ??= _constructDate();
  GeneratedTextColumn _constructDate() {
    return GeneratedTextColumn(
      'event_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _favoriteMeta = const VerificationMeta('favorite');
  GeneratedBoolColumn _favorite;
  @override
  GeneratedBoolColumn get favorite => _favorite ??= _constructFavorite();
  GeneratedBoolColumn _constructFavorite() {
    return GeneratedBoolColumn(
      'event_fav',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, eventId, name, location, date, favorite];
  @override
  $FavorsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'favors';
  @override
  final String actualTableName = 'favors';
  @override
  VerificationContext validateIntegrity(Insertable<Favor> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id'], _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('event_name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['event_name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('event_location')) {
      context.handle(
          _locationMeta,
          location.isAcceptableOrUnknown(
              data['event_location'], _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('event_date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['event_date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('event_fav')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['event_fav'], _favoriteMeta));
    } else if (isInserting) {
      context.missing(_favoriteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favor map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Favor.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FavorsTable createAlias(String alias) {
    return $FavorsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $FavorsTable _favors;
  $FavorsTable get favors => _favors ??= $FavorsTable(this);
  FavorDao _favorDao;
  FavorDao get favorDao => _favorDao ??= FavorDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favors];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$FavorDaoMixin on DatabaseAccessor<AppDatabase> {
  $FavorsTable get favors => attachedDatabase.favors;
}
