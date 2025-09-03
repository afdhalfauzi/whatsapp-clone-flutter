import 'package:flutter/material.dart';

class CallListWidget extends StatefulWidget {
  const CallListWidget({super.key});

  @override
  State<CallListWidget> createState() => _CallListWidgetState();
}

class _CallListWidgetState extends State<CallListWidget> {
  List<List<String>> chats = [
    ["orang", "Outgoing"],
    ["orang juga", "Incoming"],
    ["+62812345678910", "Outgoing"],
    ["someone", "Missed"],
    ["orang lain", "Incoming"],
    ["orang", "Outgoing"],
  ];
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          int pic_index = index + 1;
          return ListTile(
            title: Text(chats[index][0], overflow: TextOverflow.ellipsis,),
            subtitle: Text(chats[index][1], overflow: TextOverflow.ellipsis,),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/$pic_index.jpg'),
            ),
            trailing: Text("Yesterday"),
          );
        },
      ),
    );
  }
}