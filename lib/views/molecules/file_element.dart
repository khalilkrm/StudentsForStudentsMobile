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
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ListTile(
              onTap: () => onFileTap(),
              leading: const Icon(Icons.book),
              subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                Text(DateFormat("d-MM-y").format(uiFile.creationDate),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    )),
              ]),
              title: Text(
                uiFile.filename,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ));
  }
}
