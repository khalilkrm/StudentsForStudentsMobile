import 'dart:async';

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
      final map = await _userApi.google(idToken: idToken).timeout(timelimit);
      return User.fromMap(map);
    } on TimeoutException {
      throw Exception(
          "La requête n'a pas pu être résolue dans le temps imparti de ${timelimit.inSeconds} secondes");
    }
  }

  Future<User> signIn({
    required String email,
    required String password,
    Duration timelimit = const Duration(seconds: 5),
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
}
