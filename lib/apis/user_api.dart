import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_for_student_mobile/apis/api_exception.dart';
import 'package:student_for_student_mobile/apis/urls.dart' as url;

Uri _signinUri = Uri.https(url.base, url.signIn);
Uri _googleUri = Uri.https(url.base, url.googleSignIn);
Uri _whoamiUri = Uri.https(url.base, url.whoami);
Uri _signupUri = Uri.https(url.base, url.signUp);

class UserApi {
  Future<dynamic> google({required String idToken}) async {
    http.Response response = await http.post(_googleUri,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'credentials': idToken}));

    _reponseStatusIs200ElseThrow(response: response, actionName: "sign in");

    return jsonDecode(response.body);
  }

  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    http.Response response = await http.post(_signinUri,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'email': email, 'password': password}));

    _reponseStatusIs200ElseThrow(response: response, actionName: "sign in");

    return jsonDecode(response.body);
  }

  Future<dynamic> getUserFromToken({required String token}) async {
    http.Response response = await http.get(_whoamiUri, headers: {
      'accept': 'application/json',
      'Authorization': "bearer $token"
    });

    _reponseStatusIs200ElseThrow(
        response: response, actionName: "getting user");

    return jsonDecode(response.body);
  }

  Future<dynamic> getCursus({int? id, String? token}) async {
    Uri uri = Uri.https(url.base,
        url.cursus.replaceAll('{id}', id != null ? id.toString() : ''));
    http.Response response = await http.get(uri, headers: {
      'accept': 'application/json',
      'Authorization': 'bearer $token'
    });

    _reponseStatusIs200ElseThrow(
        response: response, actionName: "getting cursus");

    return jsonDecode(response.body);
  }

  void _reponseStatusIs200ElseThrow(
      {required http.Response response, required String actionName}) {
    final json = response.body.isNotEmpty ? jsonDecode(response.body) : "";

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw UnauthorizedException('unauthorized');
      }
      if (response.statusCode == 404) {
        throw ApiException(404, "Aucun compte avec le mail ${json['message']}");
      }
      throw Exception(
          json['message'] ?? 'Something went wrong while $actionName');
    }
  }

  Future<http.Response> singnUp(
      {required String firstname,
      required String lastname,
      required String email,
      required String password,
      required int cursusId}) async {
    const Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json'
    };

    final Map<String, Object> body = {
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'cursusId': cursusId
    };

    return await http.post(_signupUri,
        headers: headers, body: jsonEncode(body));
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}
