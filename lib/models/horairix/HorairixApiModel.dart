import 'package:json_annotation/json_annotation.dart';
import 'package:student_for_student_mobile/models/horairix/HorairixApiEventModel.dart';

part 'HorairixApiModel.g.dart';

@JsonSerializable()
class HorairixApiModel {
  final bool? error;

  final String? version;
  final String? prodid;
  final String? calscale;
  final String? method;
  final List<HorairixApiEventModel>? data;

  HorairixApiModel(
      {this.version,
        this.prodid,
        this.calscale,
        this.method,
        this.data,
        required this.error});

  factory HorairixApiModel.fromJson(Map<String, dynamic> json) =>
      _$HorairixApiModelFromJson(json);
}