import 'package:facebook_clone/pages/base_page.dart';
import 'package:facebook_clone/pages/log_in_page.dart';
import 'package:facebook_clone/utils/friend_request_manager.dart';
import 'package:facebook_clone/utils/posts_manager.dart';
import 'package:facebook_clone/utils/tabs_manager.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facebook_clone/models/models.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PostsManager>(
        create: (context) => PostsManager(),
      ),
      ChangeNotifierProvider<TabsManager>(
        create: (context) => TabsManager(),
      ),
      ChangeNotifierProvider<UserManager>(
        create: (context) => UserManager(
            currentUser: User(
                realName: "Default account",
                profileName: "Default account",
                mail: "default@gmail.com",
                password: "",
                createdTime: DateTime.now(),
                updatedTime: DateTime.now())),
      ),
      ChangeNotifierProvider(
        create: (context) => FriendRequestManager(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(builder: (context, userManager, child) {
      return MaterialApp(
        title: 'Facebook Clone',
        theme: ThemeData(primarySwatch: Colors.grey),
        home: userManager.isLoggedIn ? const BasePage() : const LogInPage(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
