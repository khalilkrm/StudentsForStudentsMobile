import 'package:student_for_student_mobile/models/chat/message.dart';

class Conversation {
  final List<Message> messages;

  Conversation({required this.messages});

  static Conversation fromDocument(doc) {
    final messages = doc['messages'];

    if (messages == null) return Conversation(messages: []);

    return Conversation(
        messages: messages
            .map((message) => Message.fromDocument(message))
            .toList()
            .cast<Message>());
  }
}
