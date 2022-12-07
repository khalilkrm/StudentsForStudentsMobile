import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_for_student_mobile/apis/urls.dart' as url;

Uri _signinUri = Uri.https(url.base, url.signIn);
Uri _googleUri = Uri.https(url.base, url.googleSignIn);

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

  void _reponseStatusIs200ElseThrow(
      {required http.Response response, required String actionName}) {
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ??
          'Something went wrong while $actionName');
    }
  }
}
