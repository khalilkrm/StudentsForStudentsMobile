import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_for_student_mobile/extensions.dart';
import 'package:student_for_student_mobile/services/application_image_picker.dart';

class ProfileTitleOrganism extends StatelessWidget {
  ProfileTitleOrganism(
      {Key? key,
      required this.username,
      required this.image,
      required this.onDisconnect,
      required this.onImagePicked})
      : assert(username.isNotEmpty),
        super(key: key);

  final Future<Uint8List?> image;
  final String username;
  final void Function() onDisconnect;
  final FutureOr Function(Uint8List bytes, String extension) onImagePicked;
  final ApplicationImagePicker _picker = ApplicationImagePicker();

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
          GestureDetector(
            onTap: () async {
              final image = await _picker.pickImageFromGallery();
              if (image == null) return;
              await onImagePicked(await image.toBytes(), image.extension);
            },
            child: LoadingCircleAvatar(
                image: image,
                fallback: _CircleWithFirstLetter(username: username)),
          ),
          SizedBox(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    username
                        .split(" ")
                        .map((e) => e.capitalizeFirstLetter())
                        .join(" "),
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 5)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingCircleAvatar extends StatelessWidget {
  const LoadingCircleAvatar(
      {super.key,
      required this.image,
      required this.fallback,
      this.imageSize = 80,
      this.loadingSize = 100});

  final Future<Uint8List?> image;

  final double imageSize;
  final Widget fallback;
  final double loadingSize;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: image,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return CircleAvatar(
              radius: imageSize,
              backgroundImage: Image.memory(snapshot.data!).image,
            );
          } else if (snapshot.hasError) {
            debugPrint("Could not get image profile");
            return fallback;
          } else {
            return fallback;
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: loadingSize,
              width: loadingSize,
              child: const CircularProgressIndicator(strokeWidth: 2.0));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _CircleWithFirstLetter extends StatelessWidget {
  const _CircleWithFirstLetter({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
        color: Color(0xff46543d),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          username[0].capitalizeFirstLetter(),
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 50),
        ),
      ),
    );
  }
}
