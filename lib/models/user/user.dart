import 'dart:convert';

class User {
  String username;
  String email;
  String token;
  int cursusId;
  bool isAdmin;
  bool isBanned;

  User({
    required this.username,
    required this.email,
    required this.token,
    required this.cursusId,
    required this.isAdmin,
    required this.isBanned,
  });

  static User defaultUser() {
    return User(
      username: '',
      email: '',
      token: '',
      cursusId: 0,
      isAdmin: false,
      isBanned: false,
    );
  }

  User copyWith({
    String? username,
    String? email,
    String? token,
    int? cursusId,
    bool? isAdmin,
    bool? isBanned,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
      cursusId: cursusId ?? this.cursusId,
      isAdmin: isAdmin ?? this.isAdmin,
      isBanned: isBanned ?? this.isBanned,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'token': token,
      'cursusId': cursusId,
      'isAdmin': isAdmin,
      'isBanned': isBanned,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
      cursusId: map['cursusId'] as int,
      isAdmin: map['isAdmin'] as bool,
      isBanned: map['isBanned'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserApiModel(username: $username, email: $email, token: $token, cursusId: $cursusId, isAdmin: $isAdmin, isBanned: $isBanned)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.email == email &&
        other.token == token &&
        other.cursusId == cursusId &&
        other.isAdmin == isAdmin &&
        other.isBanned == isBanned;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        email.hashCode ^
        token.hashCode ^
        cursusId.hashCode ^
        isAdmin.hashCode ^
        isBanned.hashCode;
  }
}
