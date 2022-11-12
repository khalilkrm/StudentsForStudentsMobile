import 'package:json_annotation/json_annotation.dart';
import 'package:student_for_student_mobile/models/request/CursusModel.dart';

part 'CourseModel.g.dart';

@JsonSerializable()
class CourseModel {
  final int id;
  final String label;
  final CursusModel cursus;

  CourseModel({
    required this.id,
    required this.label,
    required this.cursus,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);

  get content => "${label.substring(0, label.length < 45 ? label.length : 45)}${label.length > 45 ? "..." : ""}";
}