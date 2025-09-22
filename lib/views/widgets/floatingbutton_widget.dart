import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/firestore_manager.dart';
import 'package:flutter_application_1/mqtt/mqtt_connection.dart';
import 'package:flutter_application_1/utils/show_toast.dart';
import 'package:provider/provider.dart';

class FloatingbuttonNewChatWidget extends StatelessWidget {
  const FloatingbuttonNewChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final mqtt = Provider.of<MqttConnection>(context, listen: false);
        mqtt.publishMessage('topic/test', 'Hello from Floating Button');
        showToast("published");
      },
      tooltip: 'New Chat',
      backgroundColor: Colors.green,
      foregroundColor: Colors.black,
      child: const Icon(Icons.add_comment),
    );
  }
}

class FloatingbuttonNewStatusWidget extends StatefulWidget {
  const FloatingbuttonNewStatusWidget({super.key});

  @override
  State<FloatingbuttonNewStatusWidget> createState() => _FloatingbuttonNewStatusWidgetState();
}

class _FloatingbuttonNewStatusWidgetState extends State<FloatingbuttonNewStatusWidget> {
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final db = Provider.of<FirestoreManager>(context, listen: false);
        db.newUser("Ada", "Hello, I'm Ada!", "13:23");
        // db.updateUser("1", {"chat": "Updated chat message!", "time": "14:00"});
        db.deleteUser( "3");
        db.getUser("1").then((doc) {
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            showSnackbar(context, "User: ${data['name']}, Chat: ${data['chat']}, Time: ${data['time']}", 2000);
          } else {
            showSnackbar(context, "No such user!", 1000);
          }
        }).catchError((error) {
          showSnackbar(context, "Error fetching user: $error", 2000);
        });
      },
      tooltip: 'New Status',
      backgroundColor: Colors.green,
      foregroundColor: Colors.black,
      child: const Icon(Icons.camera_alt),
    );
  }
}

class FloatingbuttonNewCommunityWidget extends StatelessWidget {
  const FloatingbuttonNewCommunityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'New Community',
      backgroundColor: Colors.green,
      foregroundColor: Colors.black,
      child: const Icon(Icons.group_add),
    );
  }
}

class FloatingbuttonNewCallWidget extends StatelessWidget {
  const FloatingbuttonNewCallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'New Call',
      backgroundColor: Colors.green,
      foregroundColor: Colors.black,
      child: const Icon(Icons.add_call),
    );
  }
}
