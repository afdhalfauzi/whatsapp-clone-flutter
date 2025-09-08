import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/mqtt/mqtt_app_state.dart';
import 'package:flutter_application_1/mqtt/mqtt_connection.dart';
import 'package:flutter_application_1/views/pages/calls_page.dart';
import 'package:flutter_application_1/views/pages/communities_page.dart';
import 'package:flutter_application_1/views/pages/chat/chats_page.dart';
import 'package:flutter_application_1/views/pages/update_page.dart';
import 'package:flutter_application_1/views/widgets/appbar_widget.dart';
import 'package:flutter_application_1/views/widgets/floatingbutton_widget.dart';
import 'package:flutter_application_1/views/widgets/navbar_widget.dart';
import 'package:provider/provider.dart';

List<Widget> pages = [ChatPage(), UpdatePage(), CommunitiesPage(), CallsPage()];
List<Widget> fabButtons = [
  FloatingbuttonNewChatWidget(),
  FloatingbuttonNewStatusWidget(),
  FloatingbuttonNewCommunityWidget(),
  FloatingbuttonNewCallWidget()
];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  late final PageController _pageController;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedPageNotifier.value);

    // Listen to notifier and animate to page if changed from navbar
    selectedPageNotifier.addListener(() {
      if (_pageController.hasClients &&
          _pageController.page?.round() != selectedPageNotifier.value) {
        _pageController.jumpToPage(selectedPageNotifier.value);
      }
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          appBar: AppbarWidget(),
          floatingActionButton: fabButtons[selectedPage],
          bottomNavigationBar: NavbarWidget(),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              selectedPageNotifier.value = index;
            },
            children: pages,
          ),
        );
      }
    );
  }
}
