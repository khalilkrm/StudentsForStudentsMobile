import 'package:flutter/material.dart';

class RequestListTileButton extends StatelessWidget {
  const RequestListTileButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon,
    required this.color,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;
  final Icon icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      onPressed: onPressed,
      label: Text(text),
      icon: icon,
    );
  }
}
