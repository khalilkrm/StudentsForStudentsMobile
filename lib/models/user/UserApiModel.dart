import 'package:json_annotation/json_annotation.dart';

part 'UserApiModel.g.dart';

@JsonSerializable()
class UserApiModel {
  bool? error;
  String? message;

  String? username;
  String? email;
  String? token;

  UserApiModel(
      {this.error, this.message, this.username, this.email, this.token});

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);
}