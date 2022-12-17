import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_for_student_mobile/models/request/CourseModel.dart';
import 'package:student_for_student_mobile/models/request/PlaceModel.dart';

part 'RequestModel.g.dart';

@JsonSerializable()
class RequestModel {
  final int id;
  final String name;
  final String description;
  final String date;
  final bool status;
  final String sender;
  final String handler;
  final PlaceModel place;
  final CourseModel course;

  RequestModel({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.status,
    required this.sender,
    required this.place,
    required this.course,
    required this.handler,
  });

  get requestName => name.length > 24 ? '${name.substring(0, 24)}...' : name;

  factory RequestModel.fromJson(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  getFormatedDate() {
    var date = DateFormat('dd/MM/y').parse(this.date);
    final DateFormat formatter = DateFormat('EEEE d MMMM y');
    return formatter.format(date);
  }
}
