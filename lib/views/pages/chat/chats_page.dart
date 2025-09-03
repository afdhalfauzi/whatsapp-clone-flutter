import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/widgets/chat_list_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    // return Container(child: Center(child: Text('CHAT')));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Ask Meta AI or Search',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.onInverseSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        ChatListWidget(),
      ],
    );
  }
}
