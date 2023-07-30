import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student_for_student_mobile/models/files/file.dart';
import 'package:student_for_student_mobile/models/files/files.dart';
import 'package:student_for_student_mobile/repositories/file_repository.dart';

class FileStore extends ChangeNotifier {
  final FileRepository _repository;
  Files files = Files(files: []);
  bool isError = false;
  String error = '';
  void Function(String)? onErrorCallback;

  FileStore({required FileRepository repository}) : _repository = repository;

  Future<void> loadFiles({required String token}) async {
    try {
      files = await _repository.getFiles(token: token);
    } on Exception catch (e) {
      isError = true;
      error = e.toString();
      onErrorCallback?.call(error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> uploadImage(
    String token, {
    required int courseId,
    required String username,
    required String extension,
    required Uint8List bytesContent,
  }) async {
    try {
      await _repository.uploadImage(
          token: token,
          courseId: courseId,
          content: base64.encode(bytesContent),
          filename: 'userimage_$username',
          extension: extension);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  set onError(void Function(String) callback) {
    onErrorCallback = callback;
  }

  Future<void> dowloadFile({
    required String token,
    required String filename,
  }) async {
    try {
      if (!await Permission.storage.request().isGranted) return;

      ApplicationFile? file = _findFileByIndex(filename);

      if (file == null) return;

      final String base64Content = await _repository.downloadFileContent(
        token: token,
        fileName: file.filename,
      );

      final Uint8List decodedContent =
          base64.decode(base64Content.replaceAll('\n', ''));

      final io.File iofile = await _writeFileAsBytes(
          "${file.filename}.${file.extension}", decodedContent);

      await OpenFile.open(iofile.path);
    } on Exception catch (e) {
      isError = true;
      error = e.toString();
      onErrorCallback?.call(error);
    } finally {
      notifyListeners();
    }
  }

  ApplicationFile? _findFileByIndex(String filename) {
    final int index =
        files.files.indexWhere((file) => file.filename == filename);
    if (index < 0) return null;
    final ApplicationFile file = files.files[index];
    return file;
  }

  Future<String> get _localPath async {
    String documentsPath = '/storage/emulated/0/Documents/';
    if (io.Platform.isIOS) {
      io.Directory path = await getApplicationDocumentsDirectory();
      documentsPath = path.path;
    } else if (io.Platform.isAndroid) {
      io.Directory? documents = await getExternalStorageDirectory();
      documentsPath = documents == null ? documentsPath : documents.path;
    }
    return documentsPath;
  }

  Future<io.File> _file(String name) async {
    final path = await _localPath;
    return io.File('$path/$name');
  }

  Future<io.File> _writeFileAsBytes(String name, Uint8List bytes) async {
    final file = await _file(name);
    return await file.writeAsBytes(bytes.buffer.asUint8List());
  }

  ApplicationFile? findImage(String username) {
    if (files.files.isEmpty) return null;
    ApplicationFile? file = _findFileByIndex('userimage_$username');
    return file;
  }

  Future<Uint8List?> downloadImage(String token, String username) async {
    try {
      ApplicationFile? file = findImage(username);

      if (file == null) return null;

      final String base64Content = await _repository.downloadFileContent(
        token: token,
        fileName: file.filename,
      );
      final a = base64.decode(base64Content);
      return a;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
