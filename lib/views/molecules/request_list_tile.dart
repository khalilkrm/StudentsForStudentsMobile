import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileRequestListTile extends StatelessWidget {
  const ProfileRequestListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.textColor,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.roboto(color: textColor),
      ),
    );
  }
}
