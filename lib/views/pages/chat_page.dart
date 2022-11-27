import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/chat_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/screen_title.dart';
import 'package:student_for_student_mobile/views/pages/chat_room.dart';

import '../organisms/screen_navigation_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? disposer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var chatStore = Provider.of<ChatStore>(context, listen: false);
      var userStore = Provider.of<UserStore>(context, listen: false);
      await chatStore.loadRooms(roomName: "Développement d'applications");
      disposer =
          chatStore.listenRooms(collectionName: "Développement d'applications");
    });
  }

  @override
  void dispose() {
    disposer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ScreenTitle(title: 'CHAT'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Consumer2<ChatStore, UserStore>(
          builder: (context, chatStore, userStore, child) => ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              shrinkWrap: true,
              itemCount: chatStore.rooms.length,
              itemBuilder: (context, int index) {
                final room = chatStore.rooms[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    if (!mounted) return;
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return ChatRoom(roomIndex: index);
                    }));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xff5d7052),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(room.name[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.65,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                room.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                room.lastMessageText,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              '${room.lastMessageDate.hour}:${room.lastMessageDate.minute}',
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
      bottomNavigationBar: const ScreenNavigationBar(),
    );
  }
}

class UIRoomMessage {
  final String sender;
  final String time;
  final String text;

  UIRoomMessage({
    required this.sender,
    required this.time,
    required this.text,
  });
}
