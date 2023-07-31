import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_for_student_mobile/apis/urls.dart' as url;

class FilesApi {
  fetchFiles({required String token}) async {
    Uri uri = Uri.https(url.base, url.file);
    http.Response response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load files');
    }
  }

  downloadFile({
    required String token,
    required String filename,
  }) async {
    Uri uri = Uri.https(url.base, '${url.file}/$filename');
    http.Response response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to download file');
    }
  }

  Future<Map<String, dynamic>> uploadImage(
      {required String token,
      required int courseId,
      required String content,
      required String filename,
      required String extension}) async {
    Uri uri = Uri.https(url.base, url.file);
    final body = jsonEncode({
      'courseId': courseId,
      'content': content,
      'filename': filename,
      'extension': extension
    });
    http.Response response = await http.post(uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to upload image');
    }
  }
}
