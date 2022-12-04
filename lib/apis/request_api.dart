import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_for_student_mobile/apis/urls.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';

class RequestApi {
  late final UserRepository? _userRepository;

  void setUserRepository(UserRepository userRepository) {
    _userRepository = userRepository;
  }

  Future<String?> fetchPlaces() async {
    Uri placesUri = Uri.https(base, place);

    http.Response response = await http.get(placesUri, headers: {
      'Authorization': 'Bearer ${_userRepository!.userModel!.token}',
    });

    if (response.statusCode == 401) {
      return 'unauthorized';
    }

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String?> fetchCourses() async {
    Uri coursesUri = Uri.https(base, courses);

    http.Response response = await http.get(coursesUri, headers: {
      'Authorization': 'Bearer ${_userRepository!.userModel!.token}',
    });

    if (response.statusCode == 401) {
      return 'unauthorized';
    }

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String> sendRequest(
      {required String name,
      required String description,
      required int placeId,
      required int courseId}) async {
    Uri requestUri = Uri.https(base, requests);

    http.Response response = await http.post(requestUri,
        headers: {
          'Authorization': 'Bearer ${_userRepository!.userModel!.token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'placeId': placeId,
          'courseId': courseId
        }));

    if (response.statusCode == 401) {
      return 'unauthorized';
    }
    return response.body;
  }

  Future<String> sendAddress(
      {required String street,
      required String number,
      required int postalCode,
      required String locality}) async {
    Uri addressUri = Uri.https(base, place);

    http.Response response = await http.post(addressUri,
        headers: {
          'Authorization': 'Bearer ${_userRepository!.userModel!.token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'street': street,
          'number': number,
          'postalCode': postalCode,
          'locality': locality
        }));

    if (response.statusCode == 401) {
      return 'unauthorized';
    }
    return response.body;
  }

  /// If [owned] is true then it returns a list of requests
  /// user has created or is assigned to, else
  /// it returns the requests that are not assigned to the user
  Future<dynamic> getRequests({
    required bool owned,
    required String token,
  }) async {
    Uri requestUri = Uri.https(base, "$requests/$owned");
    http.Response response = await http.get(requestUri, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 401) {
      throw Exception('unauthorized');
    }

    if (response.statusCode != 200) {
      throw Exception('Something went wrong while fetching requests');
    }

    return jsonDecode(response.body);
  }
}
