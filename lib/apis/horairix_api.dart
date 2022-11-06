import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_for_student_mobile/apis/urls.dart';

part 'horairix_api.g.dart';

final Uri timesheetUri = Uri.https(horairix_base_url, horairix_agenda, {
  'type': '0',
  'token': 'G6ZhjOQU4XffW50lo7PiSRuRMi7gWcHFdJaMe2mB84Ip5Fn2LLPzTQizLHUARt8a'
});

class HorairixApi {
  Future<HorairixApiModel> fetchTimeSheet() async {
    http.Response response = await http.get(timesheetUri, headers: {
      'Content-Type': 'text/calendar',
      'charset': 'UTF-8',
    });

    try {
      String body = utf8.decode(response.bodyBytes);
      ICalendar ics = ICalendar.fromString(body);
      var model = HorairixApiModel.fromJson(ics.toJson());
      return model;
    } on FormatException {
      return HorairixApiModel(error: true);
    }
  }
}

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
      this.error});

  factory HorairixApiModel.fromJson(Map<String, dynamic> json) =>
      _$HorairixApiModelFromJson(json);
}

@JsonSerializable()
class HorairixApiEventModel {
  final String? type;
  final String? description;
  final HorairixApiEventDatetimeModel? dtend;
  final HorairixApiEventDatetimeModel? dtstamp;
  final HorairixApiEventDatetimeModel? dtstart;
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

@JsonSerializable()
class HorairixApiEventDatetimeModel {
  final DateTime? dt;
  HorairixApiEventDatetimeModel({
    this.dt,
  });

  factory HorairixApiEventDatetimeModel.fromJson(Map<String, dynamic> json) {
    final String? jsondt = json['dt'] as String?;

    if (jsondt == null) return HorairixApiEventDatetimeModel();

    return HorairixApiEventDatetimeModel(dt: DateTime.parse(jsondt).toLocal());
  }
}
