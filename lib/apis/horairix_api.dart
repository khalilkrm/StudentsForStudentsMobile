import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:student_for_student_mobile/apis/urls.dart';
import 'package:student_for_student_mobile/logger.dart';
import 'package:student_for_student_mobile/models/horairix/HorairixApiModel.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';

final Uri timesheetUri = Uri.https(base, calendar);

class HorairixApi {
  late final UserRepository? _userRepository;

  Future<bool> linkCalendar({required String link}) async {
    String encodedLink = Uri.encodeComponent(link);
    Uri linkCalendarUri = Uri.https(base, "User/$encodedLink");

    http.Response response = await http.put(linkCalendarUri, headers: {
      'Authorization': 'Bearer ${_userRepository?.userModel?.token}'
    });

    return response.statusCode == 200;
  }

  Future<HorairixApiModel> fetchTimeSheet() async {
    http.Response response = await http.get(timesheetUri, headers: {
      'Authorization': 'bearer ${_userRepository!.userModel!.token}',
    });

    if (response.statusCode == 404) {
      logger.w(
          "${(HorairixApi).toString()}: The api returned an error, could not get events");
      return HorairixApiModel(error: true);
    }

    try {
      ICalendar ics = ICalendar.fromLines(
          response.body.replaceAll("\"", "").split('\\r\\n'));
      var model = HorairixApiModel.fromJson(ics.toJson());

      logger.d(
          "${model.data![0].dtstamp!.dt!} => ${model.data![0].dtstamp!.dt!.timeZoneName} : ${model.data![0].dtstamp!.dt!.timeZoneOffset.inHours}");
      //print(model.data![0].dtstart!.dt!);
      //print(model.data![0].dtend!.dt!);

      return model;
    } on FormatException {
      logger.e("${(HorairixApi).toString()} une erreur de formatage a eu lieu");
      return HorairixApiModel(error: true);
    }
  }

  void setUserRepository(UserRepository userRepository) {
    _userRepository = userRepository;
  }
}
