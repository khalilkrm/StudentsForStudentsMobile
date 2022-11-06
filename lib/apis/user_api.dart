import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_for_student_mobile/apis/urls.dart' as url;

Uri _signinUri = Uri.https(url.base, url.signIn);
Uri _googleUri = Uri.https(url.base, url.googleSignIn);

class UserApi {
  Future<UserApiModel> google({required String idToken}) async {
    http.Response response = await http.post(_googleUri,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'credentials': idToken}));

    return UserApiModel.fromJson(response.body);
  }

  Future<UserApiModel> signIn(
      {required String email, required String password}) async {
    http.Response response = await http.post(_signinUri,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'email': email, 'password': password}));

    return UserApiModel.fromJson(response.body);
  }
}

class UserApiModel {
  final bool error;
  String? message;

  String? username;
  String? email;
  String? token;

  UserApiModel(
      {required this.error,
      this.message,
      this.username,
      this.email,
      this.token});

  factory UserApiModel.fromJson(String json) {
    Map<String, dynamic> decoded = jsonDecode(json);

    return UserApiModel(
      error: decoded['error'] ?? false,
      message: decoded['message'],
      username: decoded['username'],
      email: decoded['email'],
      token: decoded['token'],
    );
  }
}
