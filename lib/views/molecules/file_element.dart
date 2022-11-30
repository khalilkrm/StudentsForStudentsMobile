import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:student_for_student_mobile/models/files/file.dart';

class FileMolecule extends StatelessWidget {
  const FileMolecule({
    Key? key,
    required this.uiFile,
    required this.onFileTap,
  }) : super(key: key);

  final File uiFile;
  final Function onFileTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onFileTap(),
      leading: const Icon(Icons.book),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          uiFile.ownerName,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(DateFormat("d MMM yyyy").format(uiFile.creationDate),
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            )),
      ]),
      title: Text(
        uiFile.filename,
        style: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
