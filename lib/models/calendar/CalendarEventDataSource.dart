import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/models/calendar/CalendarEvent.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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