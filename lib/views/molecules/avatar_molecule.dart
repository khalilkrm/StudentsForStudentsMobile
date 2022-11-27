import 'package:flutter/material.dart';

class AvatarMolecule extends StatelessWidget {
  const AvatarMolecule({
    Key? key,
    required this.text,
    this.size = 40,
    this.color = const Color(0xff46543d),
  }) : super(key: key);

  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
