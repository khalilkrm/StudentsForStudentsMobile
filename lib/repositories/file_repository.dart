import 'package:student_for_student_mobile/apis/files_api.dart';
import 'package:student_for_student_mobile/models/files/file.dart';
import 'package:student_for_student_mobile/models/files/files.dart';

class FileRepository {
  final FilesApi _api;

  FileRepository({required FilesApi api}) : _api = api;

  Future<Files> getFiles({required String token}) async {
    var filesJson = await _api.fetchFiles(token: token);

    if (_isErrorInResponse(filesJson)) {
      throw Exception(_getErrorFromResponse(filesJson));
    }

    Files files = Files.fromJson(filesJson);
    return files;
  }

  Future<void> uploadImage(
      {required String token,
      required int courseId,
      required String content,
      required String filename,
      required String extension}) async {
    var imageJson = await _api.uploadImage(
        token: token,
        courseId: courseId,
        content: content,
        filename: filename,
        extension: extension);

    if (_isErrorInResponse(imageJson)) {
      throw Exception(_getErrorFromResponse(imageJson));
    }
  }

  Future<String> downloadFileContent({
    required String token,
    required String fileName,
  }) async {
    var fileJson = await _api.downloadFile(
      token: token,
      filename: fileName,
    );

    if (_isErrorInResponse(fileJson)) {
      throw Exception(_getErrorFromResponse(fileJson));
    }

    return fileJson['content'];
  }

  bool _isErrorInResponse(Map<String, dynamic> json) {
    return json['isError'];
  }

  String _getErrorFromResponse(Map<String, dynamic> json) {
    return json['errors'][0];
  }
}
