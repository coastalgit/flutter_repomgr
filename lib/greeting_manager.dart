import 'package:flutter_repomgr/diskrepo_mixin.dart';

/* EXPERIMENT: serialised/deserialised simple String in device storage */

class GreetingManager with DiskRepoTasks {

  String greetingMessage;

  GreetingManager({this.greetingMessage});

  @override
  diskFileName() {
    return 'msg.txt';
  }

  void saveMessage() async{
    await writeData(this.greetingMessage);
  }

  Future<String> loadMessage() {
    var data = readData().then((d) => this.greetingMessage = d);
    return data;
  }
}
