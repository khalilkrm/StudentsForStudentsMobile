import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/models/calendar/CalendarEvent.dart';
import 'package:student_for_student_mobile/models/calendar/CalendarEventDataSource.dart';
import 'package:student_for_student_mobile/models/calendar/CalendarStoreState.dart';
import 'package:student_for_student_mobile/repositories/horairix_repository.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarStore extends ChangeNotifier {
  CalendarStoreState state = CalendarStoreState(isLoading: true);
  final HorairixRepository _horairixRepository;

  CalendarStore({required HorairixRepository horairixRepository})
      : _horairixRepository = horairixRepository;

  load() async {
    await _horairixRepository.loadAllEvents();

    List<CalendarEvent> events = [];

    for (var event in _horairixRepository.events) {
      if (event.endDate != null &&
          event.startDate != null &&
          event.description != null &&
          event.location != null &&
          event.summary != null &&
          event.uid != null) {
        events.add(CalendarEvent(
          background: Colors.red,
          eventName: event.summary!,
          isAllDay: false,
          from: event.startDate!,
          to: event.endDate!,
        ));
      }
    }

    print(events[0].from.toLocal().timeZoneOffset);

    state = CalendarStoreState(
      timezone: DateTime.now().toLocal().timeZoneName,
      isLoading: false,
      source: CalendarEventDataSource(source: events),
    );

    notifyListeners();
  }
}
