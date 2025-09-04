import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  List<List<String>> stories = [
    ["orang", "Yesterday 14:45"],
    ["orang juga", "Yesterday 12:23"],
    ["orang lain", "Today 11:30"],
    ["orang", "Today 10:45 "],
    ["seseorang", "Today 09:00"],
    ["+62812345678910", "Yesterday 08:12"],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFufGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60',
            ),
          ),
          title: Text('Add status'),
          subtitle: Text('Disappear after 24 hours'),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 15, top: 10),
          child: Text(
            "Recent updates",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: stories.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(stories[index][0], overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  stories[index][1],
                  overflow: TextOverflow.ellipsis,
                ),
                leading: CircleAvatar(
                  radius: 25 + 4,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius:25,
                    backgroundImage: AssetImage('assets/images/${index +1}.jpg'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
