import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_for_student_mobile/apis/api_exception.dart';
import 'package:student_for_student_mobile/apis/user_api.dart';
import 'package:student_for_student_mobile/models/request/CursusModel.dart';
import 'package:student_for_student_mobile/models/user/user.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const String _tokenKeyInLocalStorage = 'token';

class UserStore extends ChangeNotifier {
  final UserRepository _userRepository;
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<CursusModel> cursus = List.empty();

  bool isLoading = false;
  bool isSignedIn = false;
  bool isError = false;
  String error = "";
  User user = User.defaultUser();
  String cursusName = "";
  GoogleToken? token;

  UserStore(
      {required UserRepository userRepository,
      required GoogleSignIn googleSignIn})
      : _userRepository = userRepository,
        _googleSignIn = googleSignIn;

  Future<String> _startGoogleFlowConnection() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) throw Exception("Aucun compte n'a été sélectionné");

    final GoogleSignInAuthentication auth = await googleUser.authentication;

    if (auth.idToken == null) {
      throw Exception("Le token n'a pas pu être récupérer. Réessayez");
    } else {
      return auth.idToken!;
    }
  }

  Future<List<CursusModel>> getCursusList() async {
    if (cursus.isNotEmpty) return cursus;

    List<CursusModel> cursusList = List.empty();

    final response = (await UserApi().getCursus()).toList();
    try {
      cursusList = response
          .map<CursusModel>((item) => CursusModel.fromJson(item))
          .toList();
      cursus = cursusList;
    } catch (e) {
      debugPrint('test: $e');
    }
    return cursusList;
  }

  Future<void> loadUserCursus() async {
    try {
      final String name = await _userRepository.getCursusName(
          cursusId: user.cursusId, token: user.token);
      cursusName = name;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> signInWithGoogle() async {
    await _handleSignIn(asyncSignInMethod: () async {
      final String idToken = await _startGoogleFlowConnection();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(idToken);
      token = GoogleToken.fromMap(decodedToken);
      user = await _userRepository.signInWithGoogle(idToken: idToken);
      await _setTokenInLocalStorage(
          key: _tokenKeyInLocalStorage, token: user.token);
      isSignedIn = true;
    });
  }

  Future<void> _setTokenInLocalStorage(
      {required String key, required String token}) async {
    await _storage.write(key: key, value: token);
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    await _handleSignIn(asyncSignInMethod: () async {
      user = await _userRepository.signIn(email: email, password: password);
      await _setTokenInLocalStorage(
          key: _tokenKeyInLocalStorage, token: user.token);
      isSignedIn = true;
    });
  }

  Future<void> signUpWithEmail(
      {required String firstname,
      required String lastname,
      required String email,
      required String password,
      required String cursus}) async {
    await _handleSignUp(asyncSignUpMethod: () async {
      await _userRepository.signUpWithEmail(
          email: email,
          password: password,
          lastname: lastname,
          firstname: firstname,
          cursusId:
              this.cursus.where((element) => element.label == cursus).first.id);
    });
  }

  Future<void> signOut() async {
    isLoading = true;
    isSignedIn = false;

    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint(
          "Error while deleting token from local storage: ${e.toString()}");
    } finally {
      user = User.defaultUser();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> findUserFromLocalStorage() async {
    final String? token = await _storage.read(key: _tokenKeyInLocalStorage);
    if (token != null) {
      try {
        user = await _userRepository.getUserFromToken(token: token);
        isSignedIn = true;
      } on UnauthorizedException {
        isSignedIn = false;
      } catch (e) {
        debugPrint(
            "Error while getting user from local storage: ${e.toString()}");
      } finally {
        notifyListeners();
      }
    }
  }

  // Private method to handle common sign-in tasks
  Future<void> _handleSignIn(
      {required Future<void> Function() asyncSignInMethod}) async {
    isLoading = true;

    try {
      await asyncSignInMethod();
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        rethrow;
      } else {
        _handleError(e);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // New method to handle common sign-up tasks
  Future<void> _handleSignUp(
      {required Future<void> Function() asyncSignUpMethod}) async {
    isLoading = true;
    isError = false;
    error = "";

    try {
      await asyncSignUpMethod();
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Private method to handle errors
  void _handleError(dynamic e) {
    isError = true;
    error = e.toString();
  }
}

class GoogleToken {
  final String email;
  final String givenName;
  GoogleToken(this.email, this.givenName);
  factory GoogleToken.fromMap(Map<String, dynamic> map) {
    return GoogleToken(map['email'], map['given_name']);
  }
}
