import 'package:flutter/material.dart';

class WaitingMessage extends StatelessWidget {
  final String message;

  const WaitingMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(message),
        ],
      ),
    );
  }
}