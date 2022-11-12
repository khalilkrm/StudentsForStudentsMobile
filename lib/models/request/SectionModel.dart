import 'package:json_annotation/json_annotation.dart';

part 'SectionModel.g.dart';

@JsonSerializable()
class SectionModel {
  final int id;
  final String label;

  SectionModel({
    required this.id,
    required this.label,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) => _$SectionModelFromJson(json);
}