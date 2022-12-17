import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_for_student_mobile/views/molecules/request_list_tile.dart';
import 'package:student_for_student_mobile/views/molecules/request_list_tile_button.dart';

const Color _expansionTileTextColor = Colors.white;
const Color _expansionTileIsAcceptedColor = Color(0xff46543d);
const Color _expansionTileIsPendingColor = Color(0xFFc18845);
const Color _onExpansionTileIsAcceptedColor = Color(0xFF85a074);
const Color _onExpansionTileIsPendingColor = Color(0xFF745229);

class RequestAccordion extends StatelessWidget {
  final String name;
  final String description;
  final String date;
  final String author;
  final String placeAddress;
  final String courseName;
  final void Function() onAccept;
  final void Function() onLocalize;

  const RequestAccordion({
    Key? key,
    required this.name,
    required this.description,
    required this.date,
    required this.author,
    required this.placeAddress,
    required this.courseName,
    required this.onAccept,
    required this.onLocalize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: _expansionTileIsPendingColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          collapsedTextColor: _expansionTileTextColor,
          collapsedIconColor: _expansionTileTextColor,
          textColor: _expansionTileTextColor,
          leading: const Icon(Icons.timelapse),
          iconColor: _expansionTileTextColor,
          title: Text(
            name,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          subtitle: Text('Demande de $author', style: GoogleFonts.roboto()),
          children: [
            ProfileRequestListTile(
                title: 'Description',
                subtitle: description,
                icon: Icons.description,
                textColor: _expansionTileTextColor),
            ProfileRequestListTile(
                title: 'Lieu',
                subtitle: placeAddress,
                icon: Icons.location_on,
                textColor: _expansionTileTextColor),
            ProfileRequestListTile(
                title: 'Cours',
                subtitle: courseName,
                icon: Icons.book,
                textColor: _expansionTileTextColor),
            ProfileRequestListTile(
                title: 'Date de rendez-vous',
                subtitle: date,
                icon: Icons.date_range,
                textColor: _expansionTileTextColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RequestListTileButton(
                    text: 'Accepter',
                    onPressed: onAccept,
                    icon: const Icon(Icons.check),
                    color: _onExpansionTileIsPendingColor,
                  ),
                  const SizedBox(width: 20),
                  RequestListTileButton(
                    text: 'Localiser',
                    onPressed: onLocalize,
                    icon: const Icon(Icons.navigation),
                    color: _onExpansionTileIsPendingColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
