import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/database_manager.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  final String title;
  final int index;

  const ChatRoomPage({super.key, required this.title, required this.index});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<List<String>> messages = [
    ["Stay safe!", "17:41"],
    ["Talk to you soon!", "17:40"],
    ["Goodbye!", "17:39"],
    ["See you later!", "17:38"],
    ["Have a nice day!", "17:37"],
    ["Take care!", "17:36"],
    ["Bye!", "17:35"],
    ["Sure, see you soon!", "17:34"],
    ["Let's catch up later.", "17:33"],
    ["I'm doing great!", "17:32"],
    ["What about you?", "17:31"],
    ["I'm fine, thank you!", "17:31"],
    ["How are you?", "17:30"],
    ["Hello, this is a chat bubble!", "17:29"],
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseManager>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/${widget.index + 1}.jpg',
              ),
            ),
            SizedBox(width: 10),
            Text(widget.title),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FutureBuilder(
              // future: db.getAllChats(),
              future: db.getChatsQuery(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No chats found');
                } else {
                  final chats = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index] as Map<String, dynamic>;
                        return ChatBubble(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          clipper: ChatBubbleClipper1(
                            type: BubbleType.sendBubble,
                          ),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(top: 20),
                          backGroundColor: Colors.teal,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  chat['chat'],
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  DateFormat("HH:mm").format( //only show the HH:mm part
                                    DateFormat("yyyy-MM-dd, hh:mm:ss").parse(chat['time']),
                                  ),
                                  // chat['time'],
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.inverseSurface,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (text) {
                      setState(() {
                        db.newChat(text);
                        _controller.clear();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Message",
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.emoji_emotions_outlined),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onInverseSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.attach_file),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.mic, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
