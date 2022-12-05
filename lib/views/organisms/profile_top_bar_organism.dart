import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTitleOrganism extends StatelessWidget {
  ProfileTitleOrganism({
    Key? key,
    required this.username,
  })  : assert(username.isNotEmpty),
        super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: Container(
              height: 150,
              width: 150,
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
          ),
          // The name
          SizedBox(
            height: 50,
            child: Column(
              children: [
                Text(username,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const Spacer(),
                Text('Etudiant',
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
