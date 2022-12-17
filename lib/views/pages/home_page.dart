import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/screen_title.dart';
import 'package:student_for_student_mobile/views/pages/requests_page.dart';
import 'package:student_for_student_mobile/views/templates/home_content.dart';

import '../organisms/screen_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: ScreenTitle(title: 'ACCUEIL')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const RequestsPage())),
        child: const Icon(Icons.add),
      ),
      body: const HomeContent(),
      bottomNavigationBar: const ScreenNavigationBar(),
    );
  }
}
