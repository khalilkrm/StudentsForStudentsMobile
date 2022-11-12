import 'dart:async';

import 'package:student_for_student_mobile/apis/user_api.dart';
import 'package:student_for_student_mobile/models/user/UserApiModel.dart';
import 'package:student_for_student_mobile/models/user/UserModel.dart';

class UserRepository {
  final UserApi _userApi;

  SignInState _signInState = SignInState.idle;
  String? _errorMessage;
  UserModel? _userModel;

  UserRepository({required UserApi userApi}) : _userApi = userApi;

  // ------ PUBLIC ------

  set userModel(UserModel? userModel) {
    _userModel = userModel;
  }

  Future<void> signInWithGoogle({
    required String idToken,
    Duration timelimit = const Duration(seconds: 5),
  }) async {
    try {
      // call to api
      UserApiModel apiModel =
          await _userApi.google(idToken: idToken).timeout(timelimit);

      // set the sign in state
      _setSignInStateBasedOnErrorBoolean(apiModel.error ?? false);

      // based on sign in state set model or else set error message
      _onSucceedSetModelElseSetErrorMessage(
        apiModel: apiModel,
        errorMessage: "Aucun compte n'existe avec le mail ${apiModel.message}",
      );
    } on TimeoutException {
      _onTimeoutException(timelimit);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    Duration timelimit = const Duration(seconds: 5),
  }) async {
    try {
      // call to api
      UserApiModel apiModel = await _userApi
          .signIn(email: email, password: password)
          .timeout(timelimit);

      // set the sign in state
      _setSignInStateBasedOnErrorBoolean(apiModel.error ?? false);

      // based on sign in state set model or else set error message
      _onSucceedSetModelElseSetErrorMessage(
        apiModel: apiModel,
        errorMessage: apiModel.message,
      );
    } on TimeoutException {
      _onTimeoutException(timelimit);
    }
  }

  UserModel? get userModel {
    return _userModel;
  }

  String? get errorMessage {
    return _errorMessage;
  }

  SignInState get signInState {
    return _signInState;
  }

  // ------ PRIVATE ------

  void _setSignInStateBasedOnErrorBoolean(bool error) {
    _signInState = error ? SignInState.failed : SignInState.succeed;
  }

  void _onSucceedSetModelElseSetErrorMessage({
    required UserApiModel apiModel,
    required String? errorMessage,
  }) {
    if (_signInState == SignInState.succeed) {
      List<String> errors = [];

      if (apiModel.username == null) {
        errors
            .add("La réponse à la requête ne contient pas le champ 'username'");
      }

      if (apiModel.token == null) {
        errors.add("La réponse à la requête ne contient pas le champ 'token'");
      }

      if (apiModel.email == null) {
        errors.add("La réponse à la requête ne contient pas le champ 'email'");
      }

      if (errors.isNotEmpty) {
        _errorMessage = errors.join(' | ');
        _signInState = SignInState.failed;
      } else {
        _errorMessage = null;
        _userModel = UserModel(
            username: apiModel.username!,
            email: apiModel.email!,
            token: apiModel.token!);
      }
    } else {
      _errorMessage = errorMessage ?? "Api returned an error without message";
    }
  }

  void _onTimeoutException(Duration timelimit) {
    _signInState = SignInState.failed;
    _errorMessage =
        "La requête n'a pas pu être résolue dans le temps imparti de ${timelimit.inSeconds} secondes";
  }
}

enum SignInState { idle, failed, succeed }
