import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_for_student_mobile/models/user/UserModel.dart';
import 'package:student_for_student_mobile/models/user/UserStoreState.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';

class UserStore extends ChangeNotifier {
  final UserRepository _userRepository;
  final GoogleSignIn _googleSignIn;

  UserStoreState state =
      UserStoreState(isAuthLoading: false, isGoogleLoading: false);

  UserStore({
    required UserRepository userRepository,
    required GoogleSignIn googleSignIn,
  })  : _userRepository = userRepository,
        _googleSignIn = googleSignIn;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? user = await _googleSignIn.signIn();

    if (user == null) return;

    final GoogleSignInAuthentication auth = await user.authentication;

    if (auth.idToken == null) {
      _setState(UserStoreState(
          isAuthLoading: false,
          isGoogleLoading: false,
          othersErrorMessages: [
            "Le token n'a pas pu être récupérer. Réessayez"
          ]));
      return;
    }

    _setState(UserStoreState(isAuthLoading: false, isGoogleLoading: true));

    await _userRepository.signInWithGoogle(idToken: auth.idToken!);

    final String? message = _userRepository.errorMessage;
    final UserModel? userModel = _userRepository.userModel;

    _setState(UserStoreState(
      isSignedInWithGoogle: _userRepository.signInState == SignInState.succeed,
      isAuthLoading: false,
      isGoogleLoading: false,
      email: userModel?.email,
      username: userModel?.username,
      token: userModel?.token,
      othersErrorMessages: message == null ? [] : [message],
    ));
  }

  Future<void> signIn({required String email, required String password}) async {
    _setState(UserStoreState(isAuthLoading: true, isGoogleLoading: false));

    await _userRepository.signIn(email: email, password: password);

    final String? message = _userRepository.errorMessage;
    final UserModel? userModel = _userRepository.userModel;

    _setState(UserStoreState(
      isSignedWithAuth: _userRepository.signInState == SignInState.succeed,
      isAuthLoading: false,
      isGoogleLoading: false,
      email: userModel?.email,
      username: userModel?.username,
      token: userModel?.token,
      emailErrorMessage: _mailErrorMessageOrNull(message),
      passwordErrorMessage: _passwordErrorMessageOrNull(message),
      othersErrorMessages: _othersErrorMessagesOrEmptyArray(message),
    ));
  }

  get user => _userRepository.userModel;

  void _setState(UserStoreState state) {
    this.state = state;
    notifyListeners();
  }

  String? _passwordErrorMessageOrNull(String? message) {
    return message != null && message.toLowerCase().contains('mot de passe')
        ? message
        : null;
  }

  String? _mailErrorMessageOrNull(String? message) =>
      message != null && message.toLowerCase().contains('mail')
          ? message
          : null;

  List<String> _othersErrorMessagesOrEmptyArray(String? message) {
    return message != null &&
            message.isNotEmpty &&
            !message.toLowerCase().contains(RegExp(r"(mail|mot de passe)"))
        ? [message]
        : [];
  }

  void signOut() {
    _userRepository.userModel = null;
    _setState(UserStoreState(
        isSignedInWithGoogle: false,
        isSignedWithAuth: false,
        isAuthLoading: false,
        isGoogleLoading: false));
    notifyListeners();
  }
}
