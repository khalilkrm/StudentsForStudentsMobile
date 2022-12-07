import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/models/calendar/CalendarEvent.dart';
import 'package:student_for_student_mobile/models/calendar/CalendarEventDataSource.dart';
import 'package:student_for_student_mobile/models/calendar/CalendarStoreState.dart';
import 'package:student_for_student_mobile/repositories/horairix_repository.dart';

class CalendarStore extends ChangeNotifier {
  CalendarStoreState state =
      CalendarStoreState(isLoading: true, isCalendarLinked: false);
  final HorairixRepository _horairixRepository;

  CalendarStore({required HorairixRepository horairixRepository})
      : _horairixRepository = horairixRepository;

  Future<void> linkCalendar(
      {required String calendarLink, required String token}) async {
    state = CalendarStoreState(isLoading: true, isCalendarLinked: false);
    notifyListeners();

    bool isCalendarLinked = await _horairixRepository.linkCalendar(
        link: calendarLink, token: token);
    if (isCalendarLinked) load(token: token);
  }

  load({required String token}) async {
    if (_horairixRepository.events.isNotEmpty) return;
    await _horairixRepository.loadAllEvents(token: token);

    List<CalendarEvent> events = [];

    for (var event in _horairixRepository.events) {
      if (event.endDate != null &&
          event.startDate != null &&
          event.description != null &&
          event.location != null &&
          event.summary != null &&
          event.uid != null) {
        events.add(CalendarEvent(
          background: const Color(0xFFC18845),
          eventName: event.summary!,
          isAllDay: false,
          from: event.startDate!,
          to: event.endDate!,
        ));
      }
    }

    //print(events[0].from.toLocal().timeZoneOffset);

    if (events.isEmpty) {
      state = CalendarStoreState(
        timezone: DateTime.now().toLocal().timeZoneName,
        isLoading: false,
        isCalendarLinked: false,
        source: CalendarEventDataSource(source: events),
      );
    } else {
      state = CalendarStoreState(
        timezone: DateTime.now().toLocal().timeZoneName,
        isLoading: false,
        isCalendarLinked: true,
        source: CalendarEventDataSource(source: events),
      );
    }

    notifyListeners();
  }
}
