import 'package:flutter/material.dart';

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  List communities = [
    "ROBOTECH TADULAKO",
    "Macca Community",
    "WA Community: All Angkatan TI",
  ];
  List groups = [
    ["Announcements", "ROBOTECH TADULAKO", "TIM KRI 2025"],
    ["Announcements", "Macca Lab", "Macca Project Progress"],
    ["Announcements", "Informatika 2018", "Class Info"],
  ];
  List chats = [
    ["John Doe", "Hey, are you coming to the meeting?", "10:30 AM"],
    ["Jane Smith", "Don't forget to submit your report.", "9:15 AM"],
    ["Alice Johnson", "Let's catch up later!", "Yesterday"],
    ["Bob Brown", "Meeting rescheduled to next week.", "Yesterday"],
    ["Charlie Davis", "Can you send me the files?", "2 days ago"],
    ["Eve Wilson", "Happy Birthday!", "3 days ago"],
    ["Frank Miller", "See you at the event.", "Last week"],
    ["Grace Lee", "Thanks for your help!", "Last week"],
    ["Hank Taylor", "Let's collaborate on this project.", "Last month"],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("New Community"),
          // leading: Image.asset('assets/images/4.jpg'),
          leading: Stack(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset('assets/images/4.jpg', fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    color: Colors.black, // White background
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_circle_outlined,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: communities.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(communities[index]),
                // leading: CircleAvatar(
                //   backgroundImage: AssetImage('assets/images/${index + 1}.jpg'),
                // ),
                // trailing: Icon(Icons.arrow_forward_ios, size: 16),
                subtitle: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: groups[index].length,
                      itemBuilder: (context, groupIndex) {
                        return ListTile(
                          title: Text(groups[index][groupIndex]),
                          subtitle: Text(
                            chats[groupIndex][1],
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/${index * 3 + groupIndex + 1}.jpg',
                            ),
                          ),
                          trailing: Text(chats[index * 3 + groupIndex][2]),
                        );
                      },
                    ),
                    ListTile(
                      title: Text("View all"),
                      leading: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
