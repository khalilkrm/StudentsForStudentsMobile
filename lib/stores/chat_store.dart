import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:student_for_student_mobile/models/chat/conversation.dart';
import 'package:student_for_student_mobile/models/chat/message.dart';
import 'package:student_for_student_mobile/models/chat/room.dart';
import 'package:student_for_student_mobile/repositories/chat_repository.dart';

class ChatStore extends ChangeNotifier {
  String? error;
  final ChatRepository _repository;
  List<Room> rooms = [];
  Conversation conversation = Conversation(messages: []);

  ChatStore({required ChatRepository repository}) : _repository = repository;

  Future<void> loadRooms({required String roomName}) async {
    rooms = await _repository.getRooms(collectionName: roomName);
    _sortRoomsByDate(rooms);
    notifyListeners();
  }

  void _sortRoomsByDate(List<Room> rooms) {
    rooms.sort((a, b) => dateComparator(a.lastMessageDate, b.lastMessageDate));
  }

  int dateComparator(DateTime? prev, DateTime? current) {
    if (current == null) {
      return -1;
    }
    if (prev == null) {
      return 1;
    }
    return current.compareTo(prev);
  }

  Future<void> loadMessages({required String documentName}) async {
    conversation.messages.clear();
    conversation = await _repository.getMessages(roomId: documentName);
    _sortMessagesByDate(conversation.messages);
    notifyListeners();
  }

  void _sortMessagesByDate(List<Message> messages) {
    messages.sort((a, b) => dateComparator(a.date, b.date));
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
        this.rooms = rooms;
        _sortRoomsByDate(rooms);
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
        _sortMessagesByDate(conversation.messages);
        notifyListeners();
      },
      onError: (error) {
        this.error = error.toString();
        notifyListeners();
      },
    );
  }

  formatDate(DateTime? datetime) {
    if (datetime == null) return 'Jamais';
    DateTime todayDateTime = DateTime.now();
    String todayDateFormat = DateFormat("d/MM/yyyy").format(todayDateTime);
    String givenDateFormat = DateFormat("d/MM/yyyy").format(datetime);
    String formatedDate =
        givenDateFormat == todayDateFormat ? "Aujourd'hui" : givenDateFormat;
    String time = DateFormat("HH:mm").format(datetime);
    return "$formatedDate à $time";
  }
}
