import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/firestore_manager.dart';
import 'package:provider/provider.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late User? _currentUser;
  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

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
    final db = Provider.of<FirestoreManager>(context, listen: false);
    return ListView(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: _currentUser?.photoURL != null
                ? NetworkImage(_currentUser!.photoURL!)
                : AssetImage("assets/images/default_avatar.webp"),
          ),
          title: Text(_currentUser!.displayName ?? "New User"),
          subtitle: Text(_currentUser!.email ?? "No Email"),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 15, top: 10),
          child: Text(
            "Recent updates",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        ...List.generate(stories.length, (index) {
          return ListTile(
            title: Text(stories[index][0], overflow: TextOverflow.ellipsis),
            subtitle: Text(stories[index][1], overflow: TextOverflow.ellipsis),
            leading: CircleAvatar(
              radius: 25 + 4,
              backgroundColor: Colors.green,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/${index + 1}.jpg'),
              ),
            ),
          );
        }),
        FutureBuilder(
          future: db.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No users found');
            } else {
              final users = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index] as Map<String, dynamic>;
                  return ListTile(
                    title: Text(user['name'] ?? 'No Name'),
                    subtitle: Text(user['chat'] ?? 'No Chat'),
                    trailing: Text(user['time'] ?? 'No Time'),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
