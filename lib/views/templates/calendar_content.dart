import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/calendar_store.dart';
import 'package:student_for_student_mobile/views/molecules/waiting_message.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarContent extends StatefulWidget {
  const CalendarContent({super.key});

  @override
  State<CalendarContent> createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CalendarStore>(context, listen: false).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarStore>(
      builder: (context, store, child) => store.state.isLoading
          ? const WaitingMessage('Calendrier en cours de chargement...')
          : SfCalendar(
              dataSource: store.state.source,
              view: CalendarView.month,
              showNavigationArrow: true,
              timeZone: store.state.timezone,
              monthViewSettings: const MonthViewSettings(
                  showAgenda: true, agendaStyle: AgendaStyle()),
            ),
    );
  }
}
