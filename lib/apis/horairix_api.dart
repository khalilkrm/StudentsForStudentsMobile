import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:student_for_student_mobile/apis/urls.dart';
import 'package:student_for_student_mobile/logger.dart';
import 'package:student_for_student_mobile/models/horairix/HorairixApiModel.dart';

final Uri timesheetUri = Uri.https(horairixBaseUrl, horairixAgenda, {
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

      logger.d(
          "${model.data![0].dtstamp!.dt!} => ${model.data![0].dtstamp!.dt!.timeZoneName} : ${model.data![0].dtstamp!.dt!.timeZoneOffset.inHours}");
      print(model.data![0].dtstart!.dt!);
      print(model.data![0].dtend!.dt!);

      return model;
    } on FormatException {
      logger.e("${(HorairixApi).toString()} une erreur de formatage a eu lieu");
      return HorairixApiModel(error: true);
    }
  }
}
