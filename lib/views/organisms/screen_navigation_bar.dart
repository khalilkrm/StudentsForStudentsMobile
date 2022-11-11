import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/nav_store.dart';

class ScreenNavigationBar extends StatefulWidget {
  const ScreenNavigationBar({super.key});

  @override
  State<ScreenNavigationBar> createState() => _ScreenNavigationBarState();
}

class _ScreenNavigationBarState extends State<ScreenNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavStore>(
      builder: (context, store, child) =>
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.add, size: 25),
                label: 'Demandes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message, size: 25),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 25),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 25),
                label: 'Profil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today, size: 25),
                label: 'Calendrier',
              ),
            ],
            backgroundColor: const Color(0xFF5D7052),
            currentIndex: store.currentIndex,
            selectedItemColor: const Color(0xFFC18845),
            unselectedItemColor: Colors.white,
            onTap: store.setCurrentIndex,
          ),
    );
  }
}