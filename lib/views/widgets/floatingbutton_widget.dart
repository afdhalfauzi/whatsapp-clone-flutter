import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/show_toast.dart';

class FloatingbuttonNewChatWidget extends StatelessWidget {
  const FloatingbuttonNewChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'New Chat',
      child: const Icon(Icons.add_comment),
      backgroundColor: Colors.green,
      foregroundColor: Colors.black
    );
  }
}

class FloatingbuttonNewStatusWidget extends StatelessWidget {
  const FloatingbuttonNewStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {showToast(context, "The feature is not implemented yet", 1000);},
      tooltip: 'New Status',
      child: const Icon(Icons.camera_alt),
      backgroundColor: Colors.green,
      foregroundColor: Colors.black
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
      child: const Icon(Icons.group_add),
      backgroundColor: Colors.green,
      foregroundColor: Colors.black
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
      child: const Icon(Icons.add_call),
      backgroundColor: Colors.green,
      foregroundColor: Colors.black
    );
  }
}
