import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/screen_title.dart';
import 'package:student_for_student_mobile/views/templates/request_content.dart';

import '../organisms/screen_navigation_bar.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ScreenTitle(title: 'DEMANDES'),
      ),
      body: Center(
      child: RequestContent(),
      ),
      bottomNavigationBar: const ScreenNavigationBar(),
    );
  }
}
