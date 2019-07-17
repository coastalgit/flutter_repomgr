import 'package:flutter_repomgr/diskrepo_mixin.dart';

class GreetingManager with DiskRepoTasks {

  String greetingMessage;

  GreetingManager({this.greetingMessage});

  @override
  diskFileName() {
    return 'msg.txt';
  }

  void saveMessage() {
    writeData(this.greetingMessage);
  }

  Future<String> loadMessage() {
    var data = readData().then((d) => this.greetingMessage = d);
    return data;
  }
}
