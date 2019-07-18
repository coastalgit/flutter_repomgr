// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class Pessoa extends DataClass implements Insertable<Pessoa> {
  final int id;
  final String name;
  final int age;
  Pessoa({@required this.id, @required this.name, @required this.age});
  factory Pessoa.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Pessoa(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}p_name']),
      age: intType.mapFromDatabaseResponse(data['${effectivePrefix}p_age']),
    );
  }
  factory Pessoa.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Pessoa(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<Pessoa>>(bool nullToAbsent) {
    return PersonsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
    ) as T;
  }

  Pessoa copyWith({int id, String name, int age}) => Pessoa(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
      );
  @override
  String toString() {
    return (StringBuffer('Pessoa(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc($mrjc($mrjc(0, id.hashCode), name.hashCode), age.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Pessoa &&
          other.id == id &&
          other.name == name &&
          other.age == age);
}

class PersonsCompanion extends UpdateCompanion<Pessoa> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> age;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
  });
}

class $PersonsTable extends Persons with TableInfo<$PersonsTable, Pessoa> {
  final GeneratedDatabase _db;
  final String _alias;
  $PersonsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false, hasAutoIncrement: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'p_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ageMeta = const VerificationMeta('age');
  GeneratedIntColumn _age;
  @override
  GeneratedIntColumn get age => _age ??= _constructAge();
  GeneratedIntColumn _constructAge() {
    return GeneratedIntColumn(
      'p_age',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, age];
  @override
  $PersonsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'persons';
  @override
  final String actualTableName = 'persons';
  @override
  VerificationContext validateIntegrity(PersonsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.age.present) {
      context.handle(_ageMeta, age.isAcceptableValue(d.age.value, _ageMeta));
    } else if (age.isRequired && isInserting) {
      context.missing(_ageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pessoa map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Pessoa.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(PersonsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['p_name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.age.present) {
      map['p_age'] = Variable<int, IntType>(d.age.value);
    }
    return map;
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(_db, alias);
  }
}

abstract class _$AppDB extends GeneratedDatabase {
  _$AppDB(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $PersonsTable _persons;
  $PersonsTable get persons => _persons ??= $PersonsTable(this);
  PessoaDao _pessoaDao;
  PessoaDao get pessoaDao => _pessoaDao ??= PessoaDao(this as AppDB);
  @override
  List<TableInfo> get allTables => [persons];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$PessoaDaoMixin on DatabaseAccessor<AppDB> {
  $PersonsTable get persons => db.persons;
}
