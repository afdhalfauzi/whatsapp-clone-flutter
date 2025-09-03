import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/notifiers.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, selectedPage, child) {
      return NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.chat_bubble), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.update), label: 'Update'),
          NavigationDestination(icon: Icon(Icons.group), label: 'Communities'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Calls'),
        ],
        selectedIndex: selectedPage,
        onDestinationSelected: (value) {
          selectedPageNotifier.value = value;
        },
      );
    },);
  }
}