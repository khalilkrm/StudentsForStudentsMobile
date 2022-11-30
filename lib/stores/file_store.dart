import 'package:flutter/cupertino.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:student_for_student_mobile/models/files/file.dart';
import 'package:student_for_student_mobile/models/files/files.dart';
import 'package:student_for_student_mobile/repositories/file_repository.dart';
import 'dart:io' as io;

class FileStore extends ChangeNotifier {
  final FileRepository _repository;
  Files files = Files(files: []);
  bool isError = false;
  String error = '';

  FileStore({required FileRepository repository}) : _repository = repository;

  Future<void> loadFiles({required String token}) async {
    try {
      files = await _repository.getFiles(token: token);
    } on Exception catch (e) {
      isError = true;
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> dowloadFile({
    required String token,
    required String filename,
  }) async {
    try {
      if (!await Permission.storage.request().isGranted) return;

      final int index =
          files.files.indexWhere((file) => file.filename == filename);
      final File file = files.files[index];

      final String content = await _repository.downloadFile(
        token: token,
        fileName: file.filename,
      );

      final io.File iofile =
          await _writeFile("${file.filename}.${file.extension}", content);
      await OpenFile.open(iofile.path);
    } on Exception catch (e) {
      isError = true;
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  static Future<String> get _localPath async {
    String documentsPath = '/storage/emulated/0/Documents/';
    if (io.Platform.isIOS) {
      io.Directory path =
          await path_provider.getApplicationDocumentsDirectory();
      documentsPath = path.path;
    } else if (io.Platform.isAndroid) {
      io.Directory? documents =
          await path_provider.getExternalStorageDirectory();
      documentsPath = documents == null ? documentsPath : documents.path;
    }
    return documentsPath;
  }

  static Future<io.File> _file(String name) async {
    final path = await _localPath;
    return io.File('$path/$name');
  }

  static Future<io.File> _writeFile(String name, String content) async {
    final file = await _file(name);
    return file.writeAsString(content);
  }
}
