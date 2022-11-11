import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class HorairixApiEventDateTimeModel {
  final DateTime? dt;
  HorairixApiEventDateTimeModel({
    this.dt,
  });

  factory HorairixApiEventDateTimeModel.fromJson(Map<String, dynamic> json) {
    final String? jsondt = json['dt'] as String?;

    if (jsondt == null) return HorairixApiEventDateTimeModel();

    DateTime local = DateTime.parse(jsondt).add(const Duration(hours: 1));

    return HorairixApiEventDateTimeModel(dt: local);
  }
}