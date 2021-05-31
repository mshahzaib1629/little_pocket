import 'dart:convert' show json;
import 'dart:io';
import 'package:little_pocket/helpers/manual_exception.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:little_pocket/helpers/local_db_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import '../models/tag.dart';
import '../models/transaction.dart';
import '../models/mini_transaction.dart';

String path = '../../assets/',
    importedFile = path + 'importedFile.json',
    exportedFile = path + 'exportedFile.json';

class JsonHelper {
  static Future<String> _saveFile(String jsonData) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Little Pocket";
          directory = Directory(newPath);
        } else {
          throw ManualException(message: 'permission_denied');
        }
      } else {
        if (await _requestPermission(Permission.storage)) {
          directory = await getTemporaryDirectory();
        } else {
          throw ManualException(message: 'permission_denied');
        }
      }
      File saveFile =
          File(directory.path + "/${DateTime.now().toString()}.json");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await saveFile.writeAsString(jsonData);
        return saveFile.path;
      }
    } catch (error) {
      print('error from _saveFile: \n$error');
      return error;
    }
  }

  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  static Future<String> import() async {
    try {
      if (await _requestPermission(Permission.storage)) {
        FilePickerResult result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['doc']);
        if (result != null) {
          String fileExtension = result.names[0].split('.').last;
          if (fileExtension != 'json')
            throw ManualException(message: 'invalid_file_format');
          File file = File(result.files.single.path);
          var stringContent = await file.readAsString();
          Map<String, dynamic> jsonData = json.decode(stringContent);
          print('data read from the file: ');
          print(jsonData);
          return result.files[0].path.split("/").last;
        } else {
          print('user cancelled the pick request');
          return null;
        }
      } else
        throw ManualException(message: 'permission_denied');
    } catch (error) {
      print('error from import: $error');
      throw error;
    }
  }

  static Future<String> export() async {
    try {
      Map<String, dynamic> data = {'tags': null, 'transactions': null};
      var tagsData = await LocalDatabase.getAllTags();
      data['tags'] = tagsData;
      var jsonData = json.encode(data);
      String filePath = await _saveFile(jsonData);
      print('Saved data successfully!');
      List<String> paths = filePath.split("/");
      String simplifiedPath = '';
      for (int x = 3; x < paths.length; x++) {
        String folder = paths[x];
        simplifiedPath += "/" + folder;
      }
      return simplifiedPath;
    } catch (error) {
      print('error from export: $error');
      throw error;
    }
  }
}
