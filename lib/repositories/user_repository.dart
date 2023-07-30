import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_for_student_mobile/apis/api_exception.dart';
import 'package:student_for_student_mobile/apis/user_api.dart';
import 'package:student_for_student_mobile/models/user/user.dart';

class UserRepository {
  final UserApi _userApi;

  UserRepository({required UserApi userApi}) : _userApi = userApi;

  // ------ PUBLIC ------

  Future<User> signInWithGoogle({
    required String idToken,
    Duration timelimit = const Duration(seconds: 5),
  }) async {
    try {
      final map = await _userApi.google(idToken: idToken);
      return User.fromMap(map);
    } on TimeoutException {
      throw Exception(
          "La requête n'a pas pu être résolue dans le temps imparti de ${timelimit.inSeconds} secondes");
    }
  }

  Future<User> signIn({
    required String email,
    required String password,
    Duration timelimit = const Duration(seconds: 60),
  }) async {
    try {
      final map = await _userApi
          .signIn(email: email, password: password)
          .timeout(timelimit);
      return User.fromMap(map);
    } on TimeoutException {
      throw Exception(
          "La requête n'a pas pu être résolue dans le temps imparti de ${timelimit.inSeconds} secondes");
    }
  }

  Future<User> getUserFromToken({
    required String token,
    Duration timelimit = const Duration(seconds: 60),
  }) async {
    try {
      final map =
          await _userApi.getUserFromToken(token: token).timeout(timelimit);
      return User.fromMap(map);
    } on TimeoutException {
      throw Exception(
          "La requête n'a pas pu être résolue dans le temps imparti de ${timelimit.inSeconds} secondes");
    }
  }

  Future<String> getCursusName({
    required int cursusId,
    required String token,
  }) async {
    final response = await _userApi.getCursus(id: cursusId, token: token);
    return response[0]['label'];
  }

  Future<void> signUpWithEmail(
      {required String email,
      required String password,
      required String lastname,
      required String firstname,
      required int cursusId}) async {
    http.Response response = await _userApi.singnUp(
        firstname: firstname,
        lastname: lastname,
        email: email,
        password: password,
        cursusId: cursusId);

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, body['message']);
    }
  }
}
