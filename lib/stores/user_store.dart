import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_for_student_mobile/extensions.dart';
import 'package:student_for_student_mobile/models/user/user.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';

const _tokenKeyInLocalStorage = 'token';

class UserStore extends ChangeNotifier {
  final UserRepository _userRepository;
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool isLoading = false;
  bool isSignedIn = false;
  bool isError = false;
  String error = "";
  User user = User.defaultUser();
  String cursusName = "";

  UserStore({
    required UserRepository userRepository,
    required GoogleSignIn googleSignIn,
  })  : _userRepository = userRepository,
        _googleSignIn = googleSignIn;

  Future<String> _startGoogleFlowConnection() async {
    final GoogleSignInAccount? user = await _googleSignIn.signIn();

    if (user == null) throw Exception("Aucun compte n'a été sélectionné");

    final GoogleSignInAuthentication auth = await user.authentication;

    if (auth.idToken == null) {
      throw Exception("Le token n'a pas pu être récupérer. Réessayez");
    } else {
      return auth.idToken!;
    }
  }

  Future<void> loadUserCursus() async {
    try {
      final String name = await _userRepository.getCursusName(
          cursusId: user.cursusId, token: user.token);
      cursusName = name;
    } catch (e) {
      isError = true;
      error = e.toString();
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading = true;

    try {
      final String idToken = await _startGoogleFlowConnection();
      user = await _userRepository.signInWithGoogle(idToken: idToken);
      await _setTokenInLocalStorage(
          key: _tokenKeyInLocalStorage, token: user.token);
      isSignedIn = true;
    } on Exception catch (e) {
      isError = true;
      error = e.getMessage();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _setTokenInLocalStorage(
      {required String key, required String token}) async {
    await _storage.write(key: key, value: token);
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading = true;

    try {
      user = await _userRepository.signIn(email: email, password: password);
      _setTokenInLocalStorage(key: _tokenKeyInLocalStorage, token: user.token);
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

  Future<void> findUserFromLocalStorage() async {
    final String? token = await _storage.read(key: _tokenKeyInLocalStorage);
    if (token != null) {
      try {
        user = await _userRepository.getUserFromToken(token: token);
        isSignedIn = true;
      } on Exception catch (_) {
        // ignore
      } finally {
        notifyListeners();
      }
    }
  }
}
