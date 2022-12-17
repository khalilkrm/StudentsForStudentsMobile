import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/screen_title.dart';
import 'package:student_for_student_mobile/views/templates/request_content.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: ScreenTitle(title: 'DEMANDES')),
      body: Center(
        child: RequestContent(),
      ),
    );
  }
}
