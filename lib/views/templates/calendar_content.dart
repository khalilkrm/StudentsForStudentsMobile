import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/calendar_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/waiting_message.dart';
import 'package:student_for_student_mobile/views/organisms/calendar_box.dart';
import 'package:student_for_student_mobile/views/organisms/screen_content.dart';
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
      final userStore = Provider.of<UserStore>(context, listen: false);
      Provider.of<CalendarStore>(context, listen: false)
          .load(token: userStore.user.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) => Consumer<CalendarStore>(
        builder: (context, store, child) => store.state.isLoading
            ? const WaitingMessage('Le calendrier en cours de chargement...')
            : !store.state.isCalendarLinked
                ? ScreenContent(children: [CalendarBox()])
                : SfCalendar(
                    dataSource: store.state.source,
                    view: CalendarView.month,
                    showNavigationArrow: true,
                    timeZone: store.state.timezone,
                    appointmentTimeTextFormat: 'HH:mm',
                    monthViewSettings: const MonthViewSettings(
                        showAgenda: true, agendaStyle: AgendaStyle()),
                  ),
      ),
    );
  }
}
