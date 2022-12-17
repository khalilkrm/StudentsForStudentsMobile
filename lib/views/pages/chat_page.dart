import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/models/chat/room.dart';
import 'package:student_for_student_mobile/stores/chat_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/screen_title.dart';
import 'package:student_for_student_mobile/views/organisms/screen_navigation_bar.dart';
import 'package:student_for_student_mobile/views/pages/chat_room.dart';

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
      await userStore.loadUserCursus();
      await chatStore.loadRooms(roomName: userStore.cursusName);
      disposer = chatStore.listenRooms(collectionName: userStore.cursusName);
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
        child: Consumer<ChatStore>(
          builder: (context, chatStore, child) => ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            shrinkWrap: true,
            itemCount: chatStore.rooms.length,
            itemBuilder: (context, int index) {
              final room = chatStore.rooms[index];
              return RoomWidget(
                cursusName:
                    Provider.of<UserStore>(context, listen: false).cursusName,
                mounted: mounted,
                room: room,
                index: index,
                chatStore: chatStore,
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const ScreenNavigationBar(),
    );
  }
}

class RoomWidget extends StatelessWidget {
  const RoomWidget({
    Key? key,
    required this.mounted,
    required this.room,
    required this.index,
    required this.chatStore,
    required this.cursusName,
  }) : super(key: key);

  final bool mounted;
  final Room room;
  final int index;
  final ChatStore chatStore;
  final String cursusName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (!mounted) return;
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return ChatRoom(
            roomIndex: index,
            collectionName: cursusName,
          );
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
                maxWidth: MediaQuery.of(context).size.width * 0.40,
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
                  chatStore.formatDate(room.lastMessageDate),
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UIRoomMessage {
  final String sender;
  final String date;
  final String text;

  UIRoomMessage({
    required this.sender,
    required this.date,
    required this.text,
  });
}
