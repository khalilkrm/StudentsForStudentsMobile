import 'package:student_for_student_mobile/apis/horairix_api.dart';
import 'package:student_for_student_mobile/logger.dart';
import 'package:student_for_student_mobile/models/horairix/Event.dart';
import 'package:student_for_student_mobile/models/horairix/HorairixApiModel.dart';

class HorairixRepository {
  final HorairixApi _horairixApi;

  bool? _isError;
  String? _message;
  final List<Event> _events = [];

  HorairixRepository({required horairixApi}) : _horairixApi = horairixApi;

  Future<void> loadAllEvents() async {
    final HorairixApiModel model = await _horairixApi.fetchTimeSheet();

    if (model.error ?? false) {
      logger.w(
          "${(HorairixRepository).toString()}: The api returned an error, could not get events");
      return;
    } else if (model.data == null) {
      logger.w(
          "${(HorairixRepository).toString()}: The api does not have a 'data' field, could not get events");
      return;
    } else {
      model.data?.forEach((event) {
        _events.add(Event(
          description: event.description,
          endDate: event.dtend?.dt,
          location: event.location,
          startDate: event.dtstart?.dt,
          summary: event.summary,
          uid: event.uid,
        ));
      });
    }
  }

  List<Event> get events {
    return _events;
  }
}
