import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_for_student_mobile/apis/firebase_api.dart';

class ChatRepository {
  final FirebaseApi _api;

  ChatRepository({required FirebaseApi api}) : _api = api;

  Future<List<Room>> getRooms({required String collectionName}) async {
    var docs = await _api.getCollection(collectionName: collectionName);
    var rooms = docs.map((doc) => Room.fromDocument(doc)).toList();
    return rooms;
  }

  Future<Conversation> getMessages({
    required String roomId,
  }) async {
    var docs = await _api.getDocument(
      collectionName: 'chats',
      documentName: roomId,
    );

    return Conversation.fromDocument(docs);
  }

  Future<void> sendMessage({
    required String roomId,
    required Message data,
  }) async {
    await _api.updateArrayDocument(
      collectionName: 'chats',
      fieldName: "messages",
      documentName: roomId,
      data: data.toJson(),
    );
  }

  Future<void> updateLastRoomMessage({
    required String collectionName,
    required String roomName,
    required Room data,
  }) async {
    await _api.updateObjectDocument(
      collectionName: collectionName,
      documentName: roomName,
      data: data.toJson(),
    );
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listenRooms({
    required String collectionName,
    required void Function(List<Room>) onData,
    required Function(dynamic) onError,
  }) {
    return _api.listenToCollection(
      collectionName: collectionName,
      onData: (querySnapshot) {
        List<Room> rooms = querySnapshot.docs
            .map((doc) => Room.fromDocument(doc.data()))
            .toList();
        onData(rooms);
      },
      onError: (error) {
        onError(error);
      },
    );
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listenMessages({
    required String roomId,
    required void Function(Conversation) onData,
    required Function(dynamic) onError,
  }) {
    return _api.listenToDocument(
      collectionName: 'chats',
      documentName: roomId,
      onData: (documentSnapshot) {
        var data = documentSnapshot.data();
        if (data != null) {
          var conversation = Conversation.fromDocument(data);
          onData(conversation);
        }
      },
      onError: (error) {
        onError(error);
      },
    );
  }
}

class Room {
  final String name;
  final String uid;
  final String lastMessageText;
  final String lastMessageSenderUsername;
  final DateTime lastMessageDate;

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
        : {'text': '', 'timestamp': Timestamp.now(), 'senderUsername': ''};

    final lastMessageSenderUsername = lastMessage['senderUsername'];
    final lastMessageText = lastMessage['text'];
    final lastMessageDate = lastMessage['timestamp'].toDate();

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
      'lastMessage': {
        'text': lastMessageText,
        'timestamp': Timestamp.fromDate(lastMessageDate),
        'senderUsername': lastMessageSenderUsername,
      },
    };
  }
}

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
