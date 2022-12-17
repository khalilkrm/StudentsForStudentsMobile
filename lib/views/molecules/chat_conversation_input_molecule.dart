import 'package:flutter/material.dart';

class ChatConversationInputMolecule extends StatefulWidget {
  const ChatConversationInputMolecule({Key? key, required this.onSend})
      : super(key: key);

  final void Function(String) onSend;

  @override
  State<ChatConversationInputMolecule> createState() =>
      _ChatConversationInputMoleculeState();
}

class _ChatConversationInputMoleculeState
    extends State<ChatConversationInputMolecule> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      color: Colors.white,
      child: Row(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type your message ...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: (() {
            if (_controller.text.isNotEmpty) {
              widget.onSend(_controller.text);
              _controller.text = "";
            }
          }),
          child: const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xffa4713d),
            child: Center(
              child: Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
