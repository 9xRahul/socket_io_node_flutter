import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/chat_provider.dart';

class ChatPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChatProvider>(
          builder: (_, chat, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Socket.IO Chat"),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: chat.isUserOnline ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    chat.isUserOnline ? "Online" : "Offline",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: chat.messages.length,
              itemBuilder: (_, i) {
                final isMe = chat.messages[i].startsWith("Me");
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.green.shade100
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(chat.messages[i]),
                  ),
                );
              },
            ),
          ),

          if (chat.isTyping)
            Padding(
              padding: EdgeInsets.only(left: 12, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Typing...",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

          Divider(height: 1),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: chat.onTyping,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    chat.sendMessage(controller.text.trim());
                    controller.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
