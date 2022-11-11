import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/screen_title.dart';
import 'package:student_for_student_mobile/views/organisms/screen_navigation_bar.dart';
import 'package:student_for_student_mobile/views/templates/calendar_content.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ScreenTitle(title: 'CALENDRIER'),
      ),
      body: const CalendarContent(),
      bottomNavigationBar: const ScreenNavigationBar(),
    );
  }
  
}
