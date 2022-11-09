import 'package:student_for_student_mobile/models/user/UserApiModel.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:student_for_student_mobile/repositories/user_repository.dart';
import 'package:student_for_student_mobile/apis/user_api.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([UserApi])
void main() {
  String email = 'user@example.com';
  String password = 'password';
  String username = 'username';
  String token = 'token';
  String message = 'message';

  late MockUserApi userApiMock;
  late UserRepository repository;

  setUp(() {
    userApiMock = MockUserApi();
    repository = UserRepository(userApi: userApiMock);
  });

  whenSignInThenAnswerFutureOf(UserApiModel answer) {
    when(userApiMock.signIn(
      email: email,
      password: password,
    )).thenAnswer((_) => Future.value(answer));
  }

  // TODO find a way to perform same set with this method without code repeats
  whenSignInWithGoogleThenAnswerFutureOf(UserApiModel answer) {
    when(userApiMock.google(idToken: token))
        .thenAnswer((_) => Future.value(answer));
  }

  group('UserRepository.signIn', () {
    test('signin state is idle at start', () {
      expect(repository.signInState, SignInState.idle);
    });

    test(
        'when signin then set signin state to succeed if the top call returns no error',
        () async {
      whenSignInThenAnswerFutureOf(UserApiModel(
        error: false,
        token: token,
        email: email,
        username: username,
      ));
      await repository.signIn(email: email, password: password);
      expect(repository.signInState, SignInState.succeed);
    });

    test(
        'when signin then set signin state to failed if the top call returns error',
        () async {
      whenSignInThenAnswerFutureOf(UserApiModel(error: true));
      await repository.signIn(email: email, password: password);
      expect(repository.signInState, SignInState.failed);
    });

    test('when signin then set user model if the top call returns no error',
        () async {
      whenSignInThenAnswerFutureOf(UserApiModel(
        error: false,
        token: token,
        email: email,
        username: username,
      ));
      await repository.signIn(email: email, password: password);
      expect(repository.userModel, isNotNull);
    });

    test(
        'when signin then set all user model fields if the top call returns non error',
        () async {
      whenSignInThenAnswerFutureOf(UserApiModel(
        error: false,
        email: email,
        username: username,
        token: token,
      ));
      await repository.signIn(email: email, password: password);
      expect(repository.userModel?.email, email);
      expect(repository.userModel?.username, username);
      expect(repository.userModel?.token, token);
    });

    test(
        'when signin then set error message if the top call returns non error without message',
        () async {
      whenSignInThenAnswerFutureOf(UserApiModel(error: true));
      await repository.signIn(email: email, password: password);
      expect(repository.errorMessage, isNotNull);
    });

    test(
        'when signin then set error message if the top call returns error with message',
        () async {
      whenSignInThenAnswerFutureOf(UserApiModel(error: true, message: message));
      await repository.signIn(email: email, password: password);
      expect(repository.errorMessage, isNotNull);
    });

    test(
        'when signin then set signin state to failed and error message if the received token is null',
        () async {
      whenSignInThenAnswerFutureOf(UserApiModel(
        error: false,
        token: null,
        email: email,
        username: username,
      ));
      await repository.signIn(email: email, password: password);
      expect(repository.signInState, SignInState.failed);
      expect(repository.errorMessage, isNotNull);
    });

    test(
        'when signin then set signin state to failed and error message if the received username is null',
        () async {
      whenSignInThenAnswerFutureOf(UserApiModel(
        error: false,
        token: token,
        email: email,
        username: null,
      ));
      await repository.signIn(email: email, password: password);
      expect(repository.signInState, SignInState.failed);
      expect(repository.errorMessage, isNotNull);
    });

    test(
        'when signin then set signin state to failed and error message if the received email is null',
        () async {
      whenSignInThenAnswerFutureOf(UserApiModel(
        error: false,
        token: token,
        email: null,
        username: username,
      ));
      await repository.signIn(email: email, password: password);
      expect(repository.signInState, SignInState.failed);
      expect(repository.errorMessage, isNotNull);
    });
  });
}
