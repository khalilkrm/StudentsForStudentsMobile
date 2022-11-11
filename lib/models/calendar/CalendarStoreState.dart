import 'package:student_for_student_mobile/models/calendar/CalendarEventDataSource.dart';

class CalendarStoreState {
  final CalendarEventDataSource? source;
  final bool isLoading;
  bool isCalendarLinked;
  final String _timezone;

  CalendarStoreState({this.source, required this.isLoading, required this.isCalendarLinked, timezone})
      : _timezone = timezone ?? DateTime.now().timeZoneName;

  String get timezone => _timezone;
}