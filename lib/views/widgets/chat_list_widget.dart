import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/pages/animate_to_page.dart';
import 'package:flutter_application_1/views/pages/chat/chatroom_page.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({super.key});

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  List<List<String>> chats = [
    ["orang", "Hello world hello world hello world hello ", "12:23"],
    ["orang juga", "Apa", "12:24"],
    ["+62812345678910", "awk", "12:25"],
    ["+6289876543210", "asik", "12:26"],
    ["iya", "bagus", "12:27"],
    ["ada", "mantap", "12:28"],
    ["beda", "Hello world", "12:29"],
    ["orang lain", "Hello world", "12:30"],
    ["orang", "Hello world hello", "12:31"],
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              animateToPage(
                context,
                ChatRoomPage(title: chats[index][0], index: index),
              );
            },
            title: Text(chats[index][0], overflow: TextOverflow.ellipsis),
            subtitle: Text(chats[index][1], overflow: TextOverflow.ellipsis),
            leading: GestureDetector(
              onTap: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  content: Image.asset('assets/images/${index + 1}.jpg'),
                );
              });},
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/${index + 1}.jpg'),
              ),
            ),
            trailing: Text(chats[index][2]),
          );
        },
      ),
    );
  }
}
