import 'package:moor_flutter/moor_flutter.dart';

part 'moor_db.g.dart';

// By default framework just strips off 's' at end to create the dataclass, but we can use @DataClassName to specify
@DataClassName('Pessoa')
class Persons extends Table {
//class Pdersons extends Table {
  // IntColumn get id => integer().autoIncrement().call();
  // also expressed as:
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().named('p_name')();
  IntColumn get age => integer().named('p_age')();
}

@UseMoor(tables: [Persons], daos: [PessoaDao])
class AppDB extends _$AppDB {
  AppDB()
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          logStatements: true, // SQL debug to console
        )));

  @override
  int get schemaVersion => 1;
}

// this codegens a mixin allowing us to access tables
@UseDao(tables: [Persons])
class PessoaDao extends DatabaseAccessor<AppDB> with _$PessoaDaoMixin {
  final AppDB db;

  PessoaDao(this.db) : super(db);

  Future<List<Pessoa>> getAllPersons() => select(persons).get();
  Future insertPerson(Insertable<Pessoa> pessoa) => into(persons).insert(pessoa);
  Future deletePerson(Insertable<Pessoa> pessoa) => delete(persons).delete(pessoa);
  Future updatePerson(Insertable<Pessoa> pessoa) => update(persons).replace(pessoa);

  // ability to monitor a stream of any changes via "watch"
  Stream<List<Pessoa>> watchAllPersons() => select(persons).watch();

  Stream<List<Pessoa>> watchAllPersonsByAge() {
    // Wrap the whole select statement in parenthesis
    return (select(persons)
      ..orderBy(
        ([
          // Primary sorting
              (p) => OrderingTerm(expression: p.age, mode: OrderingMode.desc),
          // Secondary alphabetical sorting
              (p) => OrderingTerm(expression: p.name),
        ]),
      ))
    // watch the whole select statement
        .watch();
  }

  Stream<List<Pessoa>> watchAllPersonsOver18OrderedByAge() {
    return (select(persons)
          ..orderBy(
            ([
              (p) => OrderingTerm(expression: p.age, mode: OrderingMode.desc),
              // secondary sort
              (p) => OrderingTerm(expression: p.name),
            ]),
          )
          ..where((p) => p.age.isBiggerThanValue(18)))
        .watch();
  }

}
