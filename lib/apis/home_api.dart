import 'package:http/http.dart' as http;
import 'package:student_for_student_mobile/apis/urls.dart';

class HomeApi {
  Future<String?> fetchRequests({required String token}) async {
    Uri requestsUri = Uri.https(base, publicRequests);

    http.Response response = await http.get(requestsUri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 401) {
      return 'unauthorized';
    }

    if (response.statusCode == 200) {
      return response.body;
    }

    return null;
  }

  Future<String?> fetchCourses({required String token}) async {
    Uri coursesUri = Uri.https(base, courses);

    http.Response response = await http.get(coursesUri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 401) {
      return 'unauthorized';
    }

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String> acceptRequest({
    required int requestId,
    required String token,
  }) async {
    Uri acceptUri = Uri.https(base, '$requests/$requestId');

    http.Response response = await http.put(acceptUri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 401) {
      return 'unauthorized';
    }

    return response.body;
  }
}
