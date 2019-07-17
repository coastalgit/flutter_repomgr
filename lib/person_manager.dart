import 'package:flutter_repomgr/diskrepo_mixin.dart';
import 'package:flutter_repomgr/helper.dart';
import 'package:flutter_repomgr/person_model.dart';

class PersonManager with DiskRepoTasks {
  Person person;

  PersonManager({this.person});

  @override
  diskFileName() {
    return 'person.txt';
  }

  Future<Null> savePerson() async{
    await writeData(person.name);
  }

  Future<Person> loadPerson() async {
    var data;
    try {
      data = await _loadPersonDataFromDisk();
    }
    catch(err){
      //return Future.error(err);
      return null;
    }

    await Helpers.sleep(2); // emulate longer task

    this.person.name = data;
    this.person.age = 69;
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
