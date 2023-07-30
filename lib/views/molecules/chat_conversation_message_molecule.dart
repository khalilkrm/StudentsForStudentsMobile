import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/extensions.dart';
import 'package:student_for_student_mobile/views/molecules/avatar_molecule.dart';
import 'package:student_for_student_mobile/views/organisms/profile_top_bar_organism.dart';
import 'package:student_for_student_mobile/views/pages/chat_page.dart';

class ChatConversationMessageMolecule extends StatelessWidget {
  const ChatConversationMessageMolecule({
    Key? key,
    required this.isMe,
    required this.message,
    required this.username,
    required this.image,
  }) : super(key: key);

  final bool isMe;
  final UIRoomMessage message;
  final String username;
  final Future<Uint8List?> image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe)
                _Avatar(message: message, username: username, image: image),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(message.sender,
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 10),
                      Text(message.date,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12))
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    decoration: BoxDecoration(
                        color:
                            isMe ? const Color(0xff46543d) : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isMe ? 12 : 0),
                            topRight: Radius.circular(isMe ? 0 : 12),
                            bottomLeft: const Radius.circular(12),
                            bottomRight: const Radius.circular(12))),
                    child: Text(
                      message.text,
                      style:
                          TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.message,
    required this.username,
    required this.image,
  });

  final UIRoomMessage message;
  final String username;
  final Future<Uint8List?> image;

  @override
  Widget build(BuildContext context) {
    return LoadingCircleAvatar(
        loadingSize: 40,
        imageSize: 20,
        image: image,
        fallback: AvatarMolecule(
          text: message.sender[0].capitalizeFirstLetter(),
          size: 35,
          color: const Color(0xff46543d),
        ));
  }
}
