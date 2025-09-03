import 'package:flutter/material.dart';

class CallListWidget extends StatefulWidget {
  const CallListWidget({super.key});

  @override
  State<CallListWidget> createState() => _CallListWidgetState();
}

class _CallListWidgetState extends State<CallListWidget> {
  List<List<String>> calls = [
    ["orang", "Outgoing", "17:29"],
    ["orang juga", "Incoming", "17:30"],
    ["+62812345678910", "Outgoing", "17:31"],
    ["someone", "Missed", "17:32"],
    ["orang lain", "Incoming", "17:33"],
    ["orang", "Outgoing", "17:34"],
    ["orang juga", "Incoming", "17:35"],
    ["+62812345678910", "Outgoing", "17:36"],
    ["orang lain", "Incoming", "17:38"],
    ["orang", "Outgoing", "17:39"],
  ];
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: calls.length,
        itemBuilder: (BuildContext context, int index) {
          int pic_index = index + 1;
          return ListTile(
            title: Text(calls[index][0], overflow: TextOverflow.ellipsis,),
            subtitle: Text(calls[index][1], overflow: TextOverflow.ellipsis,),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/$pic_index.jpg'),
            ),
            trailing: Text(calls[index][2]),
          );
        },
      ),
    );
  }
}