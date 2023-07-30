import 'package:json_annotation/json_annotation.dart';
import 'package:student_for_student_mobile/models/request/SectionModel.dart';

part 'CursusModel.g.dart';

@JsonSerializable()
class CursusModel {
  final int id;
  final String label;
  final SectionModel section;

  CursusModel({
    required this.id,
    required this.label,
    required this.section,
  });

  factory CursusModel.fromJson(Map<String, dynamic> json) =>
      _$CursusModelFromJson(json);
}
