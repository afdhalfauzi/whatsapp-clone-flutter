import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/api_manager.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/services/email_auth_service.dart';
import 'package:flutter_application_1/views/pages/signup_page.dart';
import 'package:flutter_application_1/services/google_auth_service.dart';
import 'package:provider/provider.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppbarWidget({super.key});

  static const List icons = [
    Icons.camera_alt_outlined,
    Icons.search,
    Icons.search,
    Icons.search,
  ];
  static const List title = [
    "WhatsApp Clone",
    "Updates",
    "Communities",
    "Calls",
  ];
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return AppBar(
          title: Text(title[selectedPage]),
          actions: [
            IconButton(icon: Icon(icons[selectedPage]), onPressed: () {}),
            // IconButton(icon: Icon(Icons.more_vert_rounded), onPressed: () {}),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Item 1'),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  child: Text('Sign Out'),
                  onTap: () async {
                    final api = Provider.of<APIManager>(context, listen: false);
                    final currentUser = FirebaseAuth.instance.currentUser;
                    api.put(table: "tenant", newData: {"tenantId":currentUser!.uid,"fcmToken":""});
                    await EmailAuthService().signout(context);
                    _googleAuthService.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SignupPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                isDarkModeNotifier.value = !isDarkModeNotifier.value;
              },
              icon: ValueListenableBuilder(
                valueListenable: isDarkModeNotifier,
                builder: (context, isDarkMode, child) {
                  return isDarkMode
                      ? Icon(Icons.light_mode)
                      : Icon(Icons.dark_mode);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
