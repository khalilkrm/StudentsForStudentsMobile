import 'package:json_annotation/json_annotation.dart';
import 'package:student_for_student_mobile/models/horairix/HorairixApiEventDateTimeModel.dart';

part 'HorairixApiEventModel.g.dart';

@JsonSerializable()
class HorairixApiEventModel {
  final String? type;
  final String? description;
  final HorairixApiEventDateTimeModel? dtend;
  final HorairixApiEventDateTimeModel? dtstamp;
  final HorairixApiEventDateTimeModel? dtstart;
  final String? location;
  final String? sequence;
  final String? summary;
  final String? uid;

  HorairixApiEventModel({
    this.type,
    this.description,
    this.dtend,
    this.dtstamp,
    this.dtstart,
    this.location,
    this.sequence,
    this.summary,
    this.uid,
  });

  factory HorairixApiEventModel.fromJson(Map<String, dynamic> json) =>
      _$HorairixApiEventModelFromJson(json);
}