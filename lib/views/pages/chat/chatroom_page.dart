import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatRoomPage extends StatefulWidget {
  final String title;
  final int index;

  const ChatRoomPage({super.key, required this.title, required this.index});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<List<String>> messages = [
    ["Hello, this is a chat bubble!", "17:29"],
    ["How are you?", "17:30"],
    ["I'm fine, thank you!", "17:31"],
    ["What about you?", "17:31"],
    ["I'm doing great!", "17:32"],
    ["Let's catch up later.", "17:33"],
    ["Sure, see you soon!", "17:34"],
    ["Bye!", "17:35"],
    ["Take care!", "17:36"],
    ["Have a nice day!", "17:37"],
    ["See you later!", "17:38"],
    ["Goodbye!", "17:39"],
    ["Talk to you soon!", "17:40"],
    ["Stay safe!", "17:41"],
  ];

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    clipper: ChatBubbleClipper1(
                      type: index % 2 == 0
                          ? BubbleType.receiverBubble
                          : BubbleType.sendBubble,
                    ),
                    alignment: index % 2 == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    margin: EdgeInsets.only(top: 20),
                    backGroundColor: index % 2 == 0
                        ? Theme.of(context).colorScheme.onInverseSurface
                        : Colors.teal,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            messages[index][0],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            messages[index][1],
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.inverseSurface,
                              fontSize: 10,
                            ),
                          ),
                          if (index % 2 != 0)
                            Icon(
                              Icons.double_arrow,
                              size: 10,
                              color: Colors.lightBlue
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
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
