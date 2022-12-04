import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderUsername;
  final String text;
  final DateTime date;

  Message({
    required this.senderUsername,
    required this.date,
    required this.text,
  });

  static Message fromDocument(Map<String, dynamic> doc) {
    return Message(
      senderUsername: doc['senderUsername'],
      date: doc['timestamp'].toDate(),
      text: doc['text'],
    );
  }

  toJson() {
    return {
      'senderUsername': senderUsername,
      'timestamp': Timestamp.fromDate(date),
      'text': text,
    };
  }
}
