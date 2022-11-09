import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/calendar_store.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CalendarStore>(context, listen: false).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CalendarStore>(
        builder: (context, store, child) => store.state.isLoading
            ? const CircularProgressIndicator()
            : SfCalendar(
                dataSource: store.state.source,
                view: CalendarView.month,
                showNavigationArrow: true,
                timeZone: store.state.timezone,
                monthViewSettings: const MonthViewSettings(
                    showAgenda: true, agendaStyle: AgendaStyle()),
              ),
      ),
    );
  }
}
