import 'package:flutter_repomgr/person_model.dart';

class PeopleManager {
  List<Person> people;

  PeopleManager() : people = List<Person>();
  PeopleManager.withPeople(this.people);
}
