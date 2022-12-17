import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String _title;

  const ScreenTitle({required String title, super.key}) : _title = title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: null,
      centerTitle: true,
      shadowColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Text(
          _title,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
