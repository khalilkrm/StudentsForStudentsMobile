import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_for_student_mobile/extensions.dart';
import 'package:student_for_student_mobile/models/user/user.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';

class UserStore extends ChangeNotifier {
  final UserRepository _userRepository;
  final GoogleSignIn _googleSignIn;

  bool isLoading = false;
  bool isSignedIn = false;
  bool isError = false;
  String error = "";

  User user = User.defaultUser();

  UserStore({
    required UserRepository userRepository,
    required GoogleSignIn googleSignIn,
  })  : _userRepository = userRepository,
        _googleSignIn = googleSignIn;

  Future<String> _startGoogleFlowConnection() async {
    final GoogleSignInAccount? user = await _googleSignIn.signIn();

    if (user == null) return Future.error("Aucun compte n'a été sélectionné");

    final GoogleSignInAuthentication auth = await user.authentication;

    if (auth.idToken == null) {
      throw Exception("Le token n'a pas pu être récupérer. Réessayez");
    } else {
      return auth.idToken!;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading = true;

    try {
      final String idToken = await _startGoogleFlowConnection();
      user = await _userRepository.signInWithGoogle(idToken: idToken);
      isSignedIn = true;
    } on Exception catch (e) {
      isError = true;
      error = e.getMessage();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading = true;

    try {
      user = await _userRepository.signIn(email: email, password: password);
      isSignedIn = true;
    } on Exception catch (e) {
      isError = true;
      error = e.getMessage();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void signOut() {
    isSignedIn = false;
    isLoading = false;
    user = User.defaultUser();
    notifyListeners();
  }
}
