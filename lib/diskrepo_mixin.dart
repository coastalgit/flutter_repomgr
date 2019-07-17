import 'dart:io';

import 'package:path_provider/path_provider.dart';

mixin DiskRepoTasks {
  //Temporary directory cache could be deleted by the system at any time
  //Directory tempDir = await getTemporaryDirectory();
  //String tempPath = tempDir.path;

  diskFileName();

  Future<String> get localPath async {
    // Documents directory cache is only accessible by app
    final appDocDir = await getApplicationDocumentsDirectory();
    print('Directory path=[' + appDocDir.path + ']');
    return appDocDir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    //return File('$path/db.txt');
    //String filePath = '$path/' + diskFileName() + '.txt';
    String filePath = '$path/' + diskFileName();
    print('File path=[' + filePath + ']');
    return File(filePath);
  }

  Future<String> readData() async {
    try {
      print('Reading ' + diskFileName());
      final file = await localFile;
      String body = await file.readAsString();

      //await Helpers.sleep(3); // emulate longer task

      return body;
    } catch (e) {
      print('Exception(DiskRepo) (Reading ' + diskFileName() +') : '+e.toString());
      //throw Exception(e);
      //return Future.error(e);
      return null;
    }
  }

  Future<File> writeData(String data) async {
    print('Write ' + diskFileName());
    final file = await localFile;
    return file.writeAsString("$data");
  }

  void deleteData() async {
    final file = await localFile;
    try {
      if (file.existsSync()) {
        file.delete();
      }
    } catch (err) {
      print('Cannot delete file');
    }
  }
}
