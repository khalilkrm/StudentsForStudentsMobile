import 'dart:convert';

import 'package:student_for_student_mobile/apis/urls.dart' as url;
import 'package:http/http.dart' as http;

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
}
