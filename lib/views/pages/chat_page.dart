import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/screen_title.dart';

import '../organisms/screen_navigation_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ScreenTitle(title: 'CHAT'),
      ),
      body: const Center(
        child: Text('CHAT'),
      ),
      bottomNavigationBar: const ScreenNavigationBar(),
    );
  }
}
