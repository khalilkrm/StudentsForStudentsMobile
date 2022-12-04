import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String name;
  final String uid;
  final String lastMessageText;
  final String lastMessageSenderUsername;
  final DateTime? lastMessageDate;

  Room({
    required this.name,
    required this.uid,
    required this.lastMessageDate,
    required this.lastMessageText,
    required this.lastMessageSenderUsername,
  });

  static Room fromDocument(doc) {
    final name = doc['name'];
    final uid = doc['uid'];

    final lastMessage = doc['lastMessage'].length > 0
        ? doc['lastMessage']
        : {'text': '', 'timestamp': null, 'senderUsername': ''};

    final lastMessageSenderUsername = lastMessage['senderUsername'];
    final lastMessageText = lastMessage['text'];
    final lastMessageDate = lastMessage['timestamp']?.toDate();

    return Room(
        name: name,
        uid: uid,
        lastMessageText: lastMessageText,
        lastMessageDate: lastMessageDate,
        lastMessageSenderUsername: lastMessageSenderUsername);
  }

  toJson() {
    return {
      'name': name,
      'uid': uid,
      'lastMessage': lastMessageDate != null
          ? {
              'text': lastMessageText,
              'timestamp': Timestamp.fromDate(lastMessageDate!),
              'senderUsername': lastMessageSenderUsername,
            }
          : {},
    };
  }
}
