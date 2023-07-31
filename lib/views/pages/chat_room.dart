import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/apis/urls.dart';
import 'package:student_for_student_mobile/stores/chat_store.dart';
import 'package:student_for_student_mobile/stores/file_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/avatar_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/chat_conversation_input_molecule.dart';
import 'package:student_for_student_mobile/views/organisms/chat_conversation_organism.dart';
import 'package:student_for_student_mobile/views/pages/chat_page.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    super.key,
    required this.roomIndex,
    required this.collectionName,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();

  final int roomIndex;
  final String message = '';
  final String collectionName;
}

class _ChatRoomState extends State<ChatRoom> {
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? disposer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var chatStore = Provider.of<ChatStore>(context, listen: false);
      chatStore.loadMessages(
          documentName: chatStore.rooms[widget.roomIndex].uid);
      chatStore.listenMessages(
        documentName: widget.collectionName,
        room: chatStore.rooms[widget.roomIndex],
      );
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    disposer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ChatStore, UserStore, FileStore>(
      builder: (context, chatStore, userStore, fileStore, child) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          elevation: 0,
          title: Row(
            children: [
              AvatarMolecule(text: chatStore.rooms[widget.roomIndex].name[0]),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  maxLines: 3,
                  softWrap: false,
                  chatStore.rooms[widget.roomIndex].name,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xff5d7052),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 100,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: ChatConversationOrganism(
                    image: (String senderUsername) => fileStore.downloadImage(
                        userStore.user.token, senderUsername),
                    currentUsername: userStore.user.username,
                    conversation: chatStore.conversation.messages
                        .map((message) => UIRoomMessage(
                            sender: message.senderUsername,
                            date: chatStore.formatDate(message.date),
                            text: message.text))
                        .toList(),
                  ),
                ),
              ),
              ChatConversationInputMolecule(
                onSend: (message) async {
                  await chatStore.sendMessage(
                    collectionName: widget.collectionName,
                    room: chatStore.rooms[widget.roomIndex],
                    message: message,
                    senderUsername: userStore.user.username,
                  );
                  await chatStore.updateLastRoomMessage(
                    collectionName: widget.collectionName,
                    room: chatStore.rooms[widget.roomIndex],
                    data: chatStore.conversation.messages.first,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
