import 'dart:convert';

import 'package:flutter_repomgr/diskrepo_mixin.dart';
import 'package:flutter_repomgr/helper.dart';
import 'package:flutter_repomgr/person_model.dart';

/* EXPERIMENT: serialised/deserialised object in device storage */

class PersonManager with DiskRepoTasks {
  Person person;

  PersonManager({this.person});

  @override
  diskFileName() {
    return 'person.txt';
  }

  Future<Null> savePerson() async{
    await writeData(json.encode(person.toJson()));
  }

  Future<Person> loadPerson() async {
    var data;
    try {
      //data = await _loadPersonDataFromDisk();
      data = await _loadPersonDataFromDisk();
    }
    catch(err){
      return null;
    }

    await Helpers.sleep(1); // emulate longer task

    this.person = Person.fromMap(json.decode(data));
    return this.person;
  }

  Future<String> _loadPersonDataFromDisk() {
    var data = readData();
    data.then((d) {
      return d;
    });
    data.catchError((error) {
      print('Exception(PersonMgr) : '+error.toString());
    });
    return data;
  }

}
