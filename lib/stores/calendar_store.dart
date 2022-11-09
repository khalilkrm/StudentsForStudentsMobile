import 'package:flutter/material.dart';
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

class CalendarStoreState {
  final CalendarEventDataSource? source;
  final bool isLoading;
  final String _timezone;

  CalendarStoreState({this.source, required this.isLoading, timezone})
      : _timezone = timezone ?? DateTime.now().timeZoneName;

  String get timezone => _timezone;
}

class CalendarEventDataSource extends CalendarDataSource {
  CalendarEventDataSource({required List<CalendarEvent> source}) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  CalendarEvent _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final CalendarEvent meetingData;
    if (meeting is CalendarEvent) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class CalendarEvent {
  /// Creates a meeting class with required details.
  CalendarEvent({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
  });

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
