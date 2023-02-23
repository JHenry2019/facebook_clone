import 'package:facebook_clone/pages/home_page.dart';
import 'package:facebook_clone/utils/tabs_manager.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/profile_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

int pageNum = 0;
List<Widget> pages = [
  const HomePage(),
  const Center(
    child: Placeholder(
      color: Colors.red,
    ),
  ),
  const Center(
    child: Placeholder(
      color: Colors.blue,
    ),
  ),
  const ProfilePage(),
  const Center(
    child: Placeholder(
      color: Colors.yellow,
    ),
  ),
  const Center(
    child: Placeholder(
      color: Colors.pink,
    ),
  ),
];

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<TabsManager, UserManager>(
        builder: (context, tabsManager, userManager, child) {
      return Scaffold(
        body: pages[tabsManager.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabsManager.currentIndex,
          selectedItemColor: Colors.blue[700],
          onTap: (index) => tabsManager.changeToTab(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              label: 'Watch',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      );
    });
  }
}
