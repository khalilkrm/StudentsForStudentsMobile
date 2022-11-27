import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_for_student_mobile/repositories/chat_repository.dart';

class ChatStore extends ChangeNotifier {
  String? error;
  final ChatRepository _repository;
  final List<Room> rooms = [];
  Conversation conversation = Conversation(messages: []);

  ChatStore({required ChatRepository repository}) : _repository = repository;

  Future<void> loadRooms({required String roomName}) async {
    rooms.clear();
    rooms.addAll(await _repository.getRooms(collectionName: roomName));
    notifyListeners();
  }

  Future<void> loadMessages({required String documentName}) async {
    conversation.messages.clear();
    conversation = await _repository.getMessages(roomId: documentName);
    notifyListeners();
  }

  Future<void> sendMessage({
    required String collectionName,
    required Room room,
    required String message,
    required String senderUsername,
  }) async {
    final data = Message(
      senderUsername: senderUsername,
      text: message,
      date: DateTime.now(),
    );

    await _repository.sendMessage(
      roomId: room.uid,
      data: data,
    );

    //conversation.messages.add(data);
    notifyListeners();
  }

  Future<void> updateLastRoomMessage({
    required String collectionName,
    required Room room,
    required Message data,
  }) async {
    final newRoom = Room(
      name: room.name,
      uid: room.uid,
      lastMessageDate: data.date,
      lastMessageSenderUsername: data.senderUsername,
      lastMessageText: data.text,
    );

    await _repository.updateLastRoomMessage(
      collectionName: collectionName,
      roomName: newRoom.name,
      data: newRoom,
    );

    notifyListeners();
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listenRooms(
      {required String collectionName}) {
    return _repository.listenRooms(
      collectionName: collectionName,
      onData: (rooms) {
        this.rooms.clear();
        this.rooms.addAll(rooms);
        notifyListeners();
      },
      onError: (error) {
        this.error = error.toString();
        notifyListeners();
      },
    );
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listenMessages(
      {required String documentName, required Room room}) {
    return _repository.listenMessages(
      roomId: room.uid,
      onData: (conversation) {
        this.conversation = conversation;
        notifyListeners();
      },
      onError: (error) {
        this.error = error.toString();
        notifyListeners();
      },
    );
  }
}
