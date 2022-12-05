import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_for_student_mobile/stores/profile_store.dart';

const Color _expansionTileTextColor = Colors.white;
const Color _expansionTileIsAcceptedColor = Color(0xff46543d);
const Color _expansionTileIsPendingColor = Color(0xFFc18845);
const Color _onExpansionTileIsAcceptedColor = Color(0xFF85a074);
const Color _onExpansionTileIsPendingColor = Color(0xFF745229);

class ProfileRequestExpansionTileOrganism extends StatelessWidget {
  const ProfileRequestExpansionTileOrganism({
    Key? key,
    required this.profiledataModel,
  }) : super(key: key);

  final ProfileDataModel profiledataModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: profiledataModel.isAccepted
            ? _expansionTileIsAcceptedColor
            : _expansionTileIsPendingColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        collapsedTextColor: _expansionTileTextColor,
        collapsedIconColor: _expansionTileTextColor,
        textColor: _expansionTileTextColor,
        leading:
            Icon(profiledataModel.isAccepted ? Icons.check : Icons.timelapse),
        iconColor: _expansionTileTextColor,
        title: Text(
          profiledataModel.requestTitle,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        subtitle: _ProfileRequestTitle(
          handlerUsername: profiledataModel.handlerUsername,
          isAccepted: profiledataModel.isAccepted,
          isMeTheHandler: profiledataModel.isMeTheHandler,
        ),
        children: [
          ...createRequestTiles(),
          createRequestButtons(),
        ],
      ),
    );
  }
}

class _ProfileRequestListTileButton extends StatelessWidget {
  const _ProfileRequestListTileButton({
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
    return Expanded(
      child: ElevatedButton.icon(
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

class _ProfileRequestListTile extends StatelessWidget {
  const _ProfileRequestListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          color: _expansionTileTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.roboto(color: _expansionTileTextColor),
      ),
    );
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
      _ProfileRequestListTile(
        icon: Icons.book_outlined,
        title: 'Cours',
        subtitle: profiledataModel.courseName,
      ),
      _ProfileRequestListTile(
          icon: Icons.description_outlined,
          title: 'Description de la demande',
          subtitle: profiledataModel.requestDescription),
      _ProfileRequestListTile(
          icon: Icons.location_on_outlined,
          title: 'Lieu de rencontre',
          subtitle: profiledataModel.requestMeetLocation),
      profiledataModel.isAccepted
          ? _ProfileRequestListTile(
              icon: Icons.person_outline,
              title: 'Tuteur',
              subtitle: profiledataModel.handlerUsername,
            )
          : const SizedBox.shrink()
    ];
  }

  ListTile createRequestButtons() {
    return ListTile(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (profiledataModel.isAccepted)
          _ProfileRequestListTileButton(
            icon: const Icon(Icons.navigation),
            onPressed: profiledataModel.onNavigatePressed,
            text: 'Naviguer',
            color: _onExpansionTileIsAcceptedColor,
          ),
        if (!profiledataModel.isAccepted)
          _ProfileRequestListTileButton(
            icon: const Icon(Icons.close),
            onPressed: profiledataModel.onCancelPressed,
            text: 'Annuler',
            color: _onExpansionTileIsPendingColor,
          ),
      ],
    ));
  }
}
