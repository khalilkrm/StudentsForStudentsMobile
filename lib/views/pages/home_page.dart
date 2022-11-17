import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/screen_title.dart';
import 'package:student_for_student_mobile/views/templates/home_content.dart';

import '../organisms/screen_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ScreenTitle(title: 'ACCUEIL'),
      ),
      body: const HomeContent(),
      bottomNavigationBar: const ScreenNavigationBar(),
    );
  }
}
