import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalFileStorageManager {

  Future<String> _localPath(String type) async {
    var directoryPath = "";
    if(type == "1"){
      var directory = await getApplicationDocumentsDirectory();
      directoryPath = directory.path;
    }else if(type == "2"){
      var directory = await getTemporaryDirectory();
      directoryPath = directory.path;
    }else if(type == "3"){
      var directory = await getApplicationSupportDirectory();
      directoryPath = directory.path;
    }
    return directoryPath;
  }

  Future<File> _localFile(String type,String name,String sufix) async {
    final path = _localPath(type);
    return File('$path/$name.$sufix');
  }

  Future<String> readFile(String type,String name,String sufix) async {
    try {
      final file = await _localFile(type,name,sufix);
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }
  Future<File> writeFile(String type,String name,String sufix,String content) async {
    final file = await _localFile(type,name,sufix);
    // Write the file
    return file.writeAsString(content);
  }
}