import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_for_student_mobile/stores/profile_store.dart';
import 'package:student_for_student_mobile/views/molecules/request_list_tile.dart';
import 'package:student_for_student_mobile/views/molecules/request_list_tile_button.dart';
import 'package:student_for_student_mobile/views/pages/map_page.dart';

const Color _expansionTileTextColor = Colors.white;
const Color _expansionTileIsAcceptedColor = Color(0xff46543d);
const Color _expansionTileIsPendingColor = Color(0xFFc18845);
const Color _onExpansionTileIsAcceptedColor = Color(0xFF85a074);
const Color _onExpansionTileIsPendingColor = Color(0xFF745229);

class ProfileRequestExpansionTileOrganism extends StatelessWidget {
  const ProfileRequestExpansionTileOrganism({
    Key? key,
    required this.profileRequestdataModel,
    required this.token,
  }) : super(key: key);

  final ProfileDataModel profileRequestdataModel;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: profileRequestdataModel.isAccepted
            ? _expansionTileIsAcceptedColor
            : _expansionTileIsPendingColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        collapsedTextColor: _expansionTileTextColor,
        collapsedIconColor: _expansionTileTextColor,
        textColor: _expansionTileTextColor,
        leading: Icon(
            profileRequestdataModel.isAccepted ? Icons.check : Icons.timelapse),
        iconColor: _expansionTileTextColor,
        title: Text(
          profileRequestdataModel.requestTitle,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        subtitle: _ProfileRequestTitle(
          handlerUsername: profileRequestdataModel.handlerUsername,
          isAccepted: profileRequestdataModel.isAccepted,
          isMeTheHandler: profileRequestdataModel.isMeTheHandler,
        ),
        children: [
          ...createRequestTiles(),
          createRequestButtons(
              token: token,
              onNavigatePressed: (address) => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MapPage(destination: address)))),
        ],
      ),
    );
  }
}

class _ProfileRequestTitle extends StatelessWidget {
  const _ProfileRequestTitle({
    Key? key,
    required this.handlerUsername,
    required this.isAccepted,
    required this.isMeTheHandler,
  }) : super(key: key);

  final String handlerUsername;
  final bool isAccepted;
  final bool isMeTheHandler;

  @override
  Widget build(BuildContext context) {
    return Text(
        isAccepted
            ? isMeTheHandler
                ? "Vous avez accepté cette demande"
                : "Tutoré par $handlerUsername"
            : 'En attente de tuteur',
        style: GoogleFonts.roboto());
  }
}

// -------------------------
// Extensions
// -------------------------

/// Private extension to [ProfileRequestExpansionTileOrganism] for convenience
extension _ProfileRequestExpansionTileOrganismExtension
    on ProfileRequestExpansionTileOrganism {
  List<Widget> createRequestTiles() {
    return [
      ProfileRequestListTile(
        textColor: _expansionTileTextColor,
        icon: Icons.book_outlined,
        title: 'Cours',
        subtitle: profileRequestdataModel.courseName,
      ),
      ProfileRequestListTile(
          textColor: _expansionTileTextColor,
          icon: Icons.description_outlined,
          title: 'Description de la demande',
          subtitle: profileRequestdataModel.requestDescription),
      ProfileRequestListTile(
          textColor: _expansionTileTextColor,
          icon: Icons.location_on_outlined,
          title: 'Lieu de rencontre',
          subtitle: profileRequestdataModel.requestMeetLocation),
      ProfileRequestListTile(
          title: 'Date de création',
          subtitle: profileRequestdataModel.meetingDate,
          icon: Icons.date_range,
          textColor: _expansionTileTextColor),
    ];
  }

  ListTile createRequestButtons({
    required token,
    required void Function(String) onNavigatePressed,
  }) {
    return ListTile(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (profileRequestdataModel.isAccepted)
          Expanded(
            child: RequestListTileButton(
              icon: const Icon(Icons.navigation),
              onPressed: () => onNavigatePressed(
                  profileRequestdataModel.requestMeetLocation),
              text: 'Naviguer',
              color: _onExpansionTileIsAcceptedColor,
            ),
          ),
        if (!profileRequestdataModel.isAccepted)
          Expanded(
            child: RequestListTileButton(
              icon: const Icon(Icons.close),
              onPressed: () => profileRequestdataModel.onCancelPressed(
                  profileRequestdataModel.id, token),
              text: 'Annuler',
              color: _onExpansionTileIsPendingColor,
            ),
          ),
      ],
    ));
  }
}
