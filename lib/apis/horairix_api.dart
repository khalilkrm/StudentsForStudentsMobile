import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:student_for_student_mobile/apis/urls.dart';
import 'package:student_for_student_mobile/models/horairix/HorairixApiModel.dart';

final Uri timesheetUri = Uri.https(base, calendar);

class HorairixApi {
  Future<bool> linkCalendar({
    required String link,
    required String token,
  }) async {
    String encodedLink = Uri.encodeComponent(link);
    Uri linkCalendarUri = Uri.https(base, "User/$encodedLink");

    http.Response response = await http
        .put(linkCalendarUri, headers: {'Authorization': 'Bearer $token'});

    return response.statusCode == 200;
  }

  Future<HorairixApiModel> fetchTimeSheet({required String token}) async {
    http.Response response = await http.get(timesheetUri, headers: {
      'Authorization': 'bearer $token',
    });

    if (response.statusCode == 404) {
      return HorairixApiModel(error: true);
    }

    try {
      ICalendar ics = ICalendar.fromLines(
          response.body.replaceAll("\"", "").split('\\r\\n'));
      var model = HorairixApiModel.fromJson(ics.toJson());

      return model;
    } on FormatException {
      return HorairixApiModel(error: true);
    }
  }
}
