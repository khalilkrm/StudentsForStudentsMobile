import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/chat_conversation_message_molecule.dart';
import 'package:student_for_student_mobile/views/pages/chat_page.dart';

class ChatConversationOrganism extends StatelessWidget {
  const ChatConversationOrganism({
    required this.currentUsername,
    required this.conversation,
    Key? key,
  }) : super(key: key);

  final String currentUsername;
  final List<UIRoomMessage> conversation;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: conversation.length,
      itemBuilder: (context, int index) {
        final message = conversation[index];
        bool isMe = message.sender == currentUsername;
        return ChatConversationMessageMolecule(
            isMe: isMe,
            message: UIRoomMessage(
              sender: message.sender,
              text: message.text,
              date: message.date,
            ));
      },
    );
  }
}
