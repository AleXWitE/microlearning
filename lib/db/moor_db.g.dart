// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Favor extends DataClass implements Insertable<Favor> {
  final int id;
  final int courseId;
  final String title;
  final bool favorite;
  Favor(
      {@required this.id,
      @required this.courseId,
      @required this.title,
      @required this.favorite});
  factory Favor.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Favor(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      courseId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}courseId']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}course_title']),
      favorite: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}course_fav']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || courseId != null) {
      map['courseId'] = Variable<int>(courseId);
    }
    if (!nullToAbsent || title != null) {
      map['course_title'] = Variable<String>(title);
    }
    if (!nullToAbsent || favorite != null) {
      map['course_fav'] = Variable<bool>(favorite);
    }
    return map;
  }

  FavorsCompanion toCompanion(bool nullToAbsent) {
    return FavorsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      courseId: courseId == null && nullToAbsent
          ? const Value.absent()
          : Value(courseId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
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
      courseId: serializer.fromJson<int>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      favorite: serializer.fromJson<bool>(json['favorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'courseId': serializer.toJson<int>(courseId),
      'title': serializer.toJson<String>(title),
      'favorite': serializer.toJson<bool>(favorite),
    };
  }

  Favor copyWith({int id, int courseId, String title, bool favorite}) => Favor(
        id: id ?? this.id,
        courseId: courseId ?? this.courseId,
        title: title ?? this.title,
        favorite: favorite ?? this.favorite,
      );
  @override
  String toString() {
    return (StringBuffer('Favor(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(courseId.hashCode, $mrjc(title.hashCode, favorite.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favor &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.favorite == this.favorite);
}

class FavorsCompanion extends UpdateCompanion<Favor> {
  final Value<int> id;
  final Value<int> courseId;
  final Value<String> title;
  final Value<bool> favorite;
  const FavorsCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.favorite = const Value.absent(),
  });
  FavorsCompanion.insert({
    this.id = const Value.absent(),
    @required int courseId,
    @required String title,
    @required bool favorite,
  })  : courseId = Value(courseId),
        title = Value(title),
        favorite = Value(favorite);
  static Insertable<Favor> custom({
    Expression<int> id,
    Expression<int> courseId,
    Expression<String> title,
    Expression<bool> favorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'courseId': courseId,
      if (title != null) 'course_title': title,
      if (favorite != null) 'course_fav': favorite,
    });
  }

  FavorsCompanion copyWith(
      {Value<int> id,
      Value<int> courseId,
      Value<String> title,
      Value<bool> favorite}) {
    return FavorsCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (courseId.present) {
      map['courseId'] = Variable<int>(courseId.value);
    }
    if (title.present) {
      map['course_title'] = Variable<String>(title.value);
    }
    if (favorite.present) {
      map['course_fav'] = Variable<bool>(favorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavorsCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
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

  final VerificationMeta _courseIdMeta = const VerificationMeta('courseId');
  GeneratedIntColumn _courseId;
  @override
  GeneratedIntColumn get courseId => _courseId ??= _constructCourseId();
  GeneratedIntColumn _constructCourseId() {
    return GeneratedIntColumn(
      'courseId',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'course_title',
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
      'course_fav',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, courseId, title, favorite];
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
    if (data.containsKey('courseId')) {
      context.handle(_courseIdMeta,
          courseId.isAcceptableOrUnknown(data['courseId'], _courseIdMeta));
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('course_title')) {
      context.handle(_titleMeta,
          title.isAcceptableOrUnknown(data['course_title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('course_fav')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['course_fav'], _favoriteMeta));
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

class FavorCard extends DataClass implements Insertable<FavorCard> {
  final int id;
  final String cardId;
  final String cardCourseId;
  final String cardTitle;
  final String cardQuestion;
  final String cardType;
  final String cardAnswer1;
  final String cardAnswer2;
  final String cardAnswer3;
  final String cardAnswerCorrect;
  final String cardUrl;
  FavorCard(
      {@required this.id,
      @required this.cardId,
      @required this.cardCourseId,
      @required this.cardTitle,
      @required this.cardQuestion,
      @required this.cardType,
      @required this.cardAnswer1,
      @required this.cardAnswer2,
      @required this.cardAnswer3,
      @required this.cardAnswerCorrect,
      @required this.cardUrl});
  factory FavorCard.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return FavorCard(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_card']),
      cardId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_id']),
      cardCourseId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_course_id']),
      cardTitle: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_title']),
      cardQuestion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_question']),
      cardType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_type']),
      cardAnswer1: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_answer_1']),
      cardAnswer2: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_answer_2']),
      cardAnswer3: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_answer_3']),
      cardAnswerCorrect: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}card_answer_correct']),
      cardUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_url']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id_card'] = Variable<int>(id);
    }
    if (!nullToAbsent || cardId != null) {
      map['card_id'] = Variable<String>(cardId);
    }
    if (!nullToAbsent || cardCourseId != null) {
      map['card_course_id'] = Variable<String>(cardCourseId);
    }
    if (!nullToAbsent || cardTitle != null) {
      map['card_title'] = Variable<String>(cardTitle);
    }
    if (!nullToAbsent || cardQuestion != null) {
      map['card_question'] = Variable<String>(cardQuestion);
    }
    if (!nullToAbsent || cardType != null) {
      map['card_type'] = Variable<String>(cardType);
    }
    if (!nullToAbsent || cardAnswer1 != null) {
      map['card_answer_1'] = Variable<String>(cardAnswer1);
    }
    if (!nullToAbsent || cardAnswer2 != null) {
      map['card_answer_2'] = Variable<String>(cardAnswer2);
    }
    if (!nullToAbsent || cardAnswer3 != null) {
      map['card_answer_3'] = Variable<String>(cardAnswer3);
    }
    if (!nullToAbsent || cardAnswerCorrect != null) {
      map['card_answer_correct'] = Variable<String>(cardAnswerCorrect);
    }
    if (!nullToAbsent || cardUrl != null) {
      map['card_url'] = Variable<String>(cardUrl);
    }
    return map;
  }

  FavorCardsCompanion toCompanion(bool nullToAbsent) {
    return FavorCardsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      cardId:
          cardId == null && nullToAbsent ? const Value.absent() : Value(cardId),
      cardCourseId: cardCourseId == null && nullToAbsent
          ? const Value.absent()
          : Value(cardCourseId),
      cardTitle: cardTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(cardTitle),
      cardQuestion: cardQuestion == null && nullToAbsent
          ? const Value.absent()
          : Value(cardQuestion),
      cardType: cardType == null && nullToAbsent
          ? const Value.absent()
          : Value(cardType),
      cardAnswer1: cardAnswer1 == null && nullToAbsent
          ? const Value.absent()
          : Value(cardAnswer1),
      cardAnswer2: cardAnswer2 == null && nullToAbsent
          ? const Value.absent()
          : Value(cardAnswer2),
      cardAnswer3: cardAnswer3 == null && nullToAbsent
          ? const Value.absent()
          : Value(cardAnswer3),
      cardAnswerCorrect: cardAnswerCorrect == null && nullToAbsent
          ? const Value.absent()
          : Value(cardAnswerCorrect),
      cardUrl: cardUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(cardUrl),
    );
  }

  factory FavorCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FavorCard(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      cardCourseId: serializer.fromJson<String>(json['cardCourseId']),
      cardTitle: serializer.fromJson<String>(json['cardTitle']),
      cardQuestion: serializer.fromJson<String>(json['cardQuestion']),
      cardType: serializer.fromJson<String>(json['cardType']),
      cardAnswer1: serializer.fromJson<String>(json['cardAnswer1']),
      cardAnswer2: serializer.fromJson<String>(json['cardAnswer2']),
      cardAnswer3: serializer.fromJson<String>(json['cardAnswer3']),
      cardAnswerCorrect: serializer.fromJson<String>(json['cardAnswerCorrect']),
      cardUrl: serializer.fromJson<String>(json['cardUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<String>(cardId),
      'cardCourseId': serializer.toJson<String>(cardCourseId),
      'cardTitle': serializer.toJson<String>(cardTitle),
      'cardQuestion': serializer.toJson<String>(cardQuestion),
      'cardType': serializer.toJson<String>(cardType),
      'cardAnswer1': serializer.toJson<String>(cardAnswer1),
      'cardAnswer2': serializer.toJson<String>(cardAnswer2),
      'cardAnswer3': serializer.toJson<String>(cardAnswer3),
      'cardAnswerCorrect': serializer.toJson<String>(cardAnswerCorrect),
      'cardUrl': serializer.toJson<String>(cardUrl),
    };
  }

  FavorCard copyWith(
          {int id,
          String cardId,
          String cardCourseId,
          String cardTitle,
          String cardQuestion,
          String cardType,
          String cardAnswer1,
          String cardAnswer2,
          String cardAnswer3,
          String cardAnswerCorrect,
          String cardUrl}) =>
      FavorCard(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        cardCourseId: cardCourseId ?? this.cardCourseId,
        cardTitle: cardTitle ?? this.cardTitle,
        cardQuestion: cardQuestion ?? this.cardQuestion,
        cardType: cardType ?? this.cardType,
        cardAnswer1: cardAnswer1 ?? this.cardAnswer1,
        cardAnswer2: cardAnswer2 ?? this.cardAnswer2,
        cardAnswer3: cardAnswer3 ?? this.cardAnswer3,
        cardAnswerCorrect: cardAnswerCorrect ?? this.cardAnswerCorrect,
        cardUrl: cardUrl ?? this.cardUrl,
      );
  @override
  String toString() {
    return (StringBuffer('FavorCard(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('cardCourseId: $cardCourseId, ')
          ..write('cardTitle: $cardTitle, ')
          ..write('cardQuestion: $cardQuestion, ')
          ..write('cardType: $cardType, ')
          ..write('cardAnswer1: $cardAnswer1, ')
          ..write('cardAnswer2: $cardAnswer2, ')
          ..write('cardAnswer3: $cardAnswer3, ')
          ..write('cardAnswerCorrect: $cardAnswerCorrect, ')
          ..write('cardUrl: $cardUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          cardId.hashCode,
          $mrjc(
              cardCourseId.hashCode,
              $mrjc(
                  cardTitle.hashCode,
                  $mrjc(
                      cardQuestion.hashCode,
                      $mrjc(
                          cardType.hashCode,
                          $mrjc(
                              cardAnswer1.hashCode,
                              $mrjc(
                                  cardAnswer2.hashCode,
                                  $mrjc(
                                      cardAnswer3.hashCode,
                                      $mrjc(cardAnswerCorrect.hashCode,
                                          cardUrl.hashCode)))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavorCard &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.cardCourseId == this.cardCourseId &&
          other.cardTitle == this.cardTitle &&
          other.cardQuestion == this.cardQuestion &&
          other.cardType == this.cardType &&
          other.cardAnswer1 == this.cardAnswer1 &&
          other.cardAnswer2 == this.cardAnswer2 &&
          other.cardAnswer3 == this.cardAnswer3 &&
          other.cardAnswerCorrect == this.cardAnswerCorrect &&
          other.cardUrl == this.cardUrl);
}

class FavorCardsCompanion extends UpdateCompanion<FavorCard> {
  final Value<int> id;
  final Value<String> cardId;
  final Value<String> cardCourseId;
  final Value<String> cardTitle;
  final Value<String> cardQuestion;
  final Value<String> cardType;
  final Value<String> cardAnswer1;
  final Value<String> cardAnswer2;
  final Value<String> cardAnswer3;
  final Value<String> cardAnswerCorrect;
  final Value<String> cardUrl;
  const FavorCardsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.cardCourseId = const Value.absent(),
    this.cardTitle = const Value.absent(),
    this.cardQuestion = const Value.absent(),
    this.cardType = const Value.absent(),
    this.cardAnswer1 = const Value.absent(),
    this.cardAnswer2 = const Value.absent(),
    this.cardAnswer3 = const Value.absent(),
    this.cardAnswerCorrect = const Value.absent(),
    this.cardUrl = const Value.absent(),
  });
  FavorCardsCompanion.insert({
    this.id = const Value.absent(),
    @required String cardId,
    @required String cardCourseId,
    @required String cardTitle,
    @required String cardQuestion,
    @required String cardType,
    @required String cardAnswer1,
    @required String cardAnswer2,
    @required String cardAnswer3,
    @required String cardAnswerCorrect,
    @required String cardUrl,
  })  : cardId = Value(cardId),
        cardCourseId = Value(cardCourseId),
        cardTitle = Value(cardTitle),
        cardQuestion = Value(cardQuestion),
        cardType = Value(cardType),
        cardAnswer1 = Value(cardAnswer1),
        cardAnswer2 = Value(cardAnswer2),
        cardAnswer3 = Value(cardAnswer3),
        cardAnswerCorrect = Value(cardAnswerCorrect),
        cardUrl = Value(cardUrl);
  static Insertable<FavorCard> custom({
    Expression<int> id,
    Expression<String> cardId,
    Expression<String> cardCourseId,
    Expression<String> cardTitle,
    Expression<String> cardQuestion,
    Expression<String> cardType,
    Expression<String> cardAnswer1,
    Expression<String> cardAnswer2,
    Expression<String> cardAnswer3,
    Expression<String> cardAnswerCorrect,
    Expression<String> cardUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id_card': id,
      if (cardId != null) 'card_id': cardId,
      if (cardCourseId != null) 'card_course_id': cardCourseId,
      if (cardTitle != null) 'card_title': cardTitle,
      if (cardQuestion != null) 'card_question': cardQuestion,
      if (cardType != null) 'card_type': cardType,
      if (cardAnswer1 != null) 'card_answer_1': cardAnswer1,
      if (cardAnswer2 != null) 'card_answer_2': cardAnswer2,
      if (cardAnswer3 != null) 'card_answer_3': cardAnswer3,
      if (cardAnswerCorrect != null) 'card_answer_correct': cardAnswerCorrect,
      if (cardUrl != null) 'card_url': cardUrl,
    });
  }

  FavorCardsCompanion copyWith(
      {Value<int> id,
      Value<String> cardId,
      Value<String> cardCourseId,
      Value<String> cardTitle,
      Value<String> cardQuestion,
      Value<String> cardType,
      Value<String> cardAnswer1,
      Value<String> cardAnswer2,
      Value<String> cardAnswer3,
      Value<String> cardAnswerCorrect,
      Value<String> cardUrl}) {
    return FavorCardsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      cardCourseId: cardCourseId ?? this.cardCourseId,
      cardTitle: cardTitle ?? this.cardTitle,
      cardQuestion: cardQuestion ?? this.cardQuestion,
      cardType: cardType ?? this.cardType,
      cardAnswer1: cardAnswer1 ?? this.cardAnswer1,
      cardAnswer2: cardAnswer2 ?? this.cardAnswer2,
      cardAnswer3: cardAnswer3 ?? this.cardAnswer3,
      cardAnswerCorrect: cardAnswerCorrect ?? this.cardAnswerCorrect,
      cardUrl: cardUrl ?? this.cardUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id_card'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (cardCourseId.present) {
      map['card_course_id'] = Variable<String>(cardCourseId.value);
    }
    if (cardTitle.present) {
      map['card_title'] = Variable<String>(cardTitle.value);
    }
    if (cardQuestion.present) {
      map['card_question'] = Variable<String>(cardQuestion.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (cardAnswer1.present) {
      map['card_answer_1'] = Variable<String>(cardAnswer1.value);
    }
    if (cardAnswer2.present) {
      map['card_answer_2'] = Variable<String>(cardAnswer2.value);
    }
    if (cardAnswer3.present) {
      map['card_answer_3'] = Variable<String>(cardAnswer3.value);
    }
    if (cardAnswerCorrect.present) {
      map['card_answer_correct'] = Variable<String>(cardAnswerCorrect.value);
    }
    if (cardUrl.present) {
      map['card_url'] = Variable<String>(cardUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavorCardsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('cardCourseId: $cardCourseId, ')
          ..write('cardTitle: $cardTitle, ')
          ..write('cardQuestion: $cardQuestion, ')
          ..write('cardType: $cardType, ')
          ..write('cardAnswer1: $cardAnswer1, ')
          ..write('cardAnswer2: $cardAnswer2, ')
          ..write('cardAnswer3: $cardAnswer3, ')
          ..write('cardAnswerCorrect: $cardAnswerCorrect, ')
          ..write('cardUrl: $cardUrl')
          ..write(')'))
        .toString();
  }
}

class $FavorCardsTable extends FavorCards
    with TableInfo<$FavorCardsTable, FavorCard> {
  final GeneratedDatabase _db;
  final String _alias;
  $FavorCardsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id_card', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  GeneratedTextColumn _cardId;
  @override
  GeneratedTextColumn get cardId => _cardId ??= _constructCardId();
  GeneratedTextColumn _constructCardId() {
    return GeneratedTextColumn(
      'card_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardCourseIdMeta =
      const VerificationMeta('cardCourseId');
  GeneratedTextColumn _cardCourseId;
  @override
  GeneratedTextColumn get cardCourseId =>
      _cardCourseId ??= _constructCardCourseId();
  GeneratedTextColumn _constructCardCourseId() {
    return GeneratedTextColumn(
      'card_course_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardTitleMeta = const VerificationMeta('cardTitle');
  GeneratedTextColumn _cardTitle;
  @override
  GeneratedTextColumn get cardTitle => _cardTitle ??= _constructCardTitle();
  GeneratedTextColumn _constructCardTitle() {
    return GeneratedTextColumn(
      'card_title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardQuestionMeta =
      const VerificationMeta('cardQuestion');
  GeneratedTextColumn _cardQuestion;
  @override
  GeneratedTextColumn get cardQuestion =>
      _cardQuestion ??= _constructCardQuestion();
  GeneratedTextColumn _constructCardQuestion() {
    return GeneratedTextColumn(
      'card_question',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardTypeMeta = const VerificationMeta('cardType');
  GeneratedTextColumn _cardType;
  @override
  GeneratedTextColumn get cardType => _cardType ??= _constructCardType();
  GeneratedTextColumn _constructCardType() {
    return GeneratedTextColumn(
      'card_type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardAnswer1Meta =
      const VerificationMeta('cardAnswer1');
  GeneratedTextColumn _cardAnswer1;
  @override
  GeneratedTextColumn get cardAnswer1 =>
      _cardAnswer1 ??= _constructCardAnswer1();
  GeneratedTextColumn _constructCardAnswer1() {
    return GeneratedTextColumn(
      'card_answer_1',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardAnswer2Meta =
      const VerificationMeta('cardAnswer2');
  GeneratedTextColumn _cardAnswer2;
  @override
  GeneratedTextColumn get cardAnswer2 =>
      _cardAnswer2 ??= _constructCardAnswer2();
  GeneratedTextColumn _constructCardAnswer2() {
    return GeneratedTextColumn(
      'card_answer_2',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardAnswer3Meta =
      const VerificationMeta('cardAnswer3');
  GeneratedTextColumn _cardAnswer3;
  @override
  GeneratedTextColumn get cardAnswer3 =>
      _cardAnswer3 ??= _constructCardAnswer3();
  GeneratedTextColumn _constructCardAnswer3() {
    return GeneratedTextColumn(
      'card_answer_3',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardAnswerCorrectMeta =
      const VerificationMeta('cardAnswerCorrect');
  GeneratedTextColumn _cardAnswerCorrect;
  @override
  GeneratedTextColumn get cardAnswerCorrect =>
      _cardAnswerCorrect ??= _constructCardAnswerCorrect();
  GeneratedTextColumn _constructCardAnswerCorrect() {
    return GeneratedTextColumn(
      'card_answer_correct',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cardUrlMeta = const VerificationMeta('cardUrl');
  GeneratedTextColumn _cardUrl;
  @override
  GeneratedTextColumn get cardUrl => _cardUrl ??= _constructCardUrl();
  GeneratedTextColumn _constructCardUrl() {
    return GeneratedTextColumn(
      'card_url',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        cardId,
        cardCourseId,
        cardTitle,
        cardQuestion,
        cardType,
        cardAnswer1,
        cardAnswer2,
        cardAnswer3,
        cardAnswerCorrect,
        cardUrl
      ];
  @override
  $FavorCardsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'favor_cards';
  @override
  final String actualTableName = 'favor_cards';
  @override
  VerificationContext validateIntegrity(Insertable<FavorCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_card')) {
      context.handle(
          _idMeta, id.isAcceptableOrUnknown(data['id_card'], _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id'], _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('card_course_id')) {
      context.handle(
          _cardCourseIdMeta,
          cardCourseId.isAcceptableOrUnknown(
              data['card_course_id'], _cardCourseIdMeta));
    } else if (isInserting) {
      context.missing(_cardCourseIdMeta);
    }
    if (data.containsKey('card_title')) {
      context.handle(_cardTitleMeta,
          cardTitle.isAcceptableOrUnknown(data['card_title'], _cardTitleMeta));
    } else if (isInserting) {
      context.missing(_cardTitleMeta);
    }
    if (data.containsKey('card_question')) {
      context.handle(
          _cardQuestionMeta,
          cardQuestion.isAcceptableOrUnknown(
              data['card_question'], _cardQuestionMeta));
    } else if (isInserting) {
      context.missing(_cardQuestionMeta);
    }
    if (data.containsKey('card_type')) {
      context.handle(_cardTypeMeta,
          cardType.isAcceptableOrUnknown(data['card_type'], _cardTypeMeta));
    } else if (isInserting) {
      context.missing(_cardTypeMeta);
    }
    if (data.containsKey('card_answer_1')) {
      context.handle(
          _cardAnswer1Meta,
          cardAnswer1.isAcceptableOrUnknown(
              data['card_answer_1'], _cardAnswer1Meta));
    } else if (isInserting) {
      context.missing(_cardAnswer1Meta);
    }
    if (data.containsKey('card_answer_2')) {
      context.handle(
          _cardAnswer2Meta,
          cardAnswer2.isAcceptableOrUnknown(
              data['card_answer_2'], _cardAnswer2Meta));
    } else if (isInserting) {
      context.missing(_cardAnswer2Meta);
    }
    if (data.containsKey('card_answer_3')) {
      context.handle(
          _cardAnswer3Meta,
          cardAnswer3.isAcceptableOrUnknown(
              data['card_answer_3'], _cardAnswer3Meta));
    } else if (isInserting) {
      context.missing(_cardAnswer3Meta);
    }
    if (data.containsKey('card_answer_correct')) {
      context.handle(
          _cardAnswerCorrectMeta,
          cardAnswerCorrect.isAcceptableOrUnknown(
              data['card_answer_correct'], _cardAnswerCorrectMeta));
    } else if (isInserting) {
      context.missing(_cardAnswerCorrectMeta);
    }
    if (data.containsKey('card_url')) {
      context.handle(_cardUrlMeta,
          cardUrl.isAcceptableOrUnknown(data['card_url'], _cardUrlMeta));
    } else if (isInserting) {
      context.missing(_cardUrlMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavorCard map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return FavorCard.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FavorCardsTable createAlias(String alias) {
    return $FavorCardsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $FavorsTable _favors;
  $FavorsTable get favors => _favors ??= $FavorsTable(this);
  $FavorCardsTable _favorCards;
  $FavorCardsTable get favorCards => _favorCards ??= $FavorCardsTable(this);
  FavorDao _favorDao;
  FavorDao get favorDao => _favorDao ??= FavorDao(this as AppDatabase);
  FavorCardsDao _favorCardsDao;
  FavorCardsDao get favorCardsDao =>
      _favorCardsDao ??= FavorCardsDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favors, favorCards];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$FavorDaoMixin on DatabaseAccessor<AppDatabase> {
  $FavorsTable get favors => attachedDatabase.favors;
}
mixin _$FavorCardsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FavorCardsTable get favorCards => attachedDatabase.favorCards;
}
