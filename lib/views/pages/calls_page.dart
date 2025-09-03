import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/widgets/call_list_widget.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => CallsPageState();
}

class CallsPageState extends State<CallsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search or start a new call',
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
        CallListWidget(),
      ],
    );
  }
}