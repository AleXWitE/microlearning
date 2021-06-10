import 'package:moor_flutter/moor_flutter.dart';

part 'moor_db.g.dart';

class Favors extends Table {
  IntColumn get id => integer().named("id").autoIncrement()();

  IntColumn get courseId => integer().named("courseId")();

  TextColumn get title => text().named("course_title")();

  BoolColumn get favorite => boolean().named("course_fav")();
}

@UseMoor(tables: [Favors, FavorCards], daos: [FavorDao, FavorCardsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
            path: "db.sqlite", logStatements: true)));

  @override
  int get schemaVersion => 2;

  // @override
  // MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
  //       return m.createAll();
  //     }, onUpgrade: (Migrator m, int from, int to) async {
  //       if (from == 1) {
  //         m.addColumn(favors, favors.id);
  //       }
  //     });
}

@UseDao(tables: [Favors])
class FavorDao extends DatabaseAccessor<AppDatabase> with _$FavorDaoMixin {
  final AppDatabase db;

  FavorDao(this.db) : super(db);

  Future<List<Favor>> getAllFavorites() => select(favors).get();

  Future<Favor> getFavorite(int id) {
    return (select(favors)..where((fav) => fav.courseId.equals(id)))
        .getSingle();
  }

  Stream<List<Favor>> watchAllFavorites() => select(favors).watch();


  Future<int> insertNewFavorite(Favor fav) => into(favors).insert(fav);

  Future<int> deleteFavorite(Favor fav) => delete(favors).delete(fav);
}

class FavorCards extends Table {
  IntColumn get id => integer().named("id_card").autoIncrement()();

  TextColumn get cardId => text().named("card_id")();

  TextColumn get cardCourseId => text().named("card_course_id")();

  TextColumn get cardTitle => text().named("card_title")();

  TextColumn get cardQuestion => text().named("card_question")();

  TextColumn get cardType => text().named("card_type")();

  TextColumn get cardAnswer1 => text().named("card_answer_1")();

  TextColumn get cardAnswer2 => text().named("card_answer_2")();

  TextColumn get cardAnswer3 => text().named("card_answer_3")();

  TextColumn get cardAnswerCorrect => text().named("card_answer_correct")();

  TextColumn get cardUrl => text().named("card_url")();
}

@UseDao(tables: [FavorCards])
class FavorCardsDao extends DatabaseAccessor<AppDatabase> with _$FavorCardsDaoMixin {
  final AppDatabase db;

  FavorCardsDao(this.db) : super(db);

  Future<List<FavorCard>> getAllFavoritesCards() => select(favorCards).get();

  Future<FavorCard> getFavoriteCard(int id) {
    return (select(favorCards)..where((fav) => fav.cardId.equals(id.toString())))
        .getSingle();
  }

  Stream<List<FavorCard>> watchAllFavoritesCards() => select(favorCards).watch();


  Future<int> insertNewFavoriteCard(FavorCard fav) => into(favorCards).insert(fav);

  Future<int> deleteFavoriteCard(FavorCard fav) => delete(favorCards).delete(fav);

}