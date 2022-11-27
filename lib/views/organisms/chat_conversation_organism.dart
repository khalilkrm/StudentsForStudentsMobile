import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/repositories/chat_repository.dart';
import 'package:student_for_student_mobile/views/molecules/chat_conversation_message_molecule.dart';
import 'package:student_for_student_mobile/views/pages/chat_page.dart';

class ChatConversationOrganism extends StatelessWidget {
  const ChatConversationOrganism({
    required this.currentUsername,
    required this.conversation,
    Key? key,
  }) : super(key: key);

  final String currentUsername;
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: conversation.messages.length,
      itemBuilder: (context, int index) {
        final message = conversation.messages[index];
        bool isMe = message.senderUsername == currentUsername;
        return ChatConversationMessageMolecule(
            isMe: isMe,
            message: UIRoomMessage(
              sender: message.senderUsername,
              text: message.text,
              time: "${message.date.hour}:${message.date.minute}",
            ));
      },
    );
  }
}
