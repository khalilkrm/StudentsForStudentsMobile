import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/avatar_molecule.dart';
import 'package:student_for_student_mobile/views/pages/chat_page.dart';

class ChatConversationMessageMolecule extends StatelessWidget {
  const ChatConversationMessageMolecule({
    Key? key,
    required this.isMe,
    required this.message,
  }) : super(key: key);

  final bool isMe;
  final UIRoomMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe)
                AvatarMolecule(
                  text: message.sender[0],
                  size: 25,
                  color: const Color(0xff46543d),
                ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                decoration: BoxDecoration(
                    color: isMe ? const Color(0xff46543d) : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 12 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 12),
                    )),
                child: Text(
                  message.text,
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (isMe) const SizedBox(width: 30),
                Text(
                  message.time,
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
