import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_for_student_mobile/apis/firebase_api.dart';
import 'package:student_for_student_mobile/models/chat/conversation.dart';
import 'package:student_for_student_mobile/models/chat/message.dart';
import 'package:student_for_student_mobile/models/chat/room.dart';

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
