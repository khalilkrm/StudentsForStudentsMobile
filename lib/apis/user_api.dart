import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_for_student_mobile/apis/urls.dart' as url;
import 'package:student_for_student_mobile/models/user/UserApiModel.dart';
import 'package:student_for_student_mobile/repositories/horairix_repository.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';

Uri _signinUri = Uri.https(url.base, url.signIn);
Uri _googleUri = Uri.https(url.base, url.googleSignIn);

class UserApi {
  late final UserRepository? _userRepository;
  late final HorairixRepository _horairixRepository;

  Future<UserApiModel> google({required String idToken}) async {
    http.Response response = await http.post(_googleUri,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'credentials': idToken}));

    return UserApiModel.fromJson(jsonDecode(response.body));
  }

  Future<UserApiModel> signIn(
      {required String email, required String password}) async {
    http.Response response = await http.post(_signinUri,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'email': email, 'password': password}));

    return UserApiModel.fromJson(jsonDecode(response.body));
  }

  void setUserRepository(UserRepository userRepository) {
    _userRepository = userRepository;
  }

  void setHorairixRepository(HorairixRepository horairixRepository) {
    _horairixRepository = horairixRepository;
  }
}
