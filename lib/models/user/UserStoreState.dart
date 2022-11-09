class UserStoreState {
  final bool isAuthLoading;
  final bool isGoogleLoading;
  final bool isSignedWithAuth;
  final bool isSignedInWithGoogle;

  final String? email;
  final String? username;
  final String? token;

  final String? emailErrorMessage;
  final String? passwordErrorMessage;
  final List<String> othersErrorMessages;

  UserStoreState({
    required this.isAuthLoading,
    required this.isGoogleLoading,
    this.isSignedWithAuth = false,
    this.isSignedInWithGoogle = false,
    this.email,
    this.username,
    this.token,
    this.emailErrorMessage,
    this.passwordErrorMessage,
    this.othersErrorMessages = const [],
  });
}