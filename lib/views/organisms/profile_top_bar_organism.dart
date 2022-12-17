import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTitleOrganism extends StatelessWidget {
  ProfileTitleOrganism({
    Key? key,
    required this.username,
    required this.onDisconnect,
  })  : assert(username.isNotEmpty),
        super(key: key);

  final String username;
  final void Function() onDisconnect;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ClipOval(
              child: Material(
                color: const Color(0xFFc18845), // button color
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(.5),
                  onTap: onDisconnect, // inkwell color
                  child: const SizedBox(
                      width: 56, height: 56, child: Icon(Icons.logout)),
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              color: Color(0xff46543d),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                username[0],
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(username,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 5),
                Text('Votre profil',
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
