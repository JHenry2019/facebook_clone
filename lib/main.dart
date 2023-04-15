import 'package:facebook_clone/pages/base_page.dart';
import 'package:facebook_clone/pages/log_in_page.dart';
import 'package:facebook_clone/utils/db_methods.dart';
import 'package:facebook_clone/utils/likes_manager.dart';
import 'package:facebook_clone/utils/other_users_manager.dart';
import 'package:facebook_clone/utils/posts_manager.dart';
import 'package:facebook_clone/utils/tabs_manager.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facebook_clone/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

int currentUserId = 0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  currentUserId = sharedPreferences.getInt('currentUserId') ?? 0;

  if (!sharedPreferences.containsKey('firstTimeInstall')) {
    await initMockData();
    sharedPreferences.setBool('firstTimeInstall', true);
  }

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
        create: (context) => OtherUsersManager(),
      ),
      ChangeNotifierProvider(create: (context) => LikesManager()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<int?> loadCurrentUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final int? currentUserId = sharedPreferences.getInt('currentUserId');

    return currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId != 0) {
      Provider.of<UserManager>(context, listen: false)
          .logInUserById(currentUserId, context);
    } else {
      Provider.of<UserManager>(context, listen: false).currentUser = User(
          userId: 0,
          realName: "Default account",
          profileName: "Default account",
          mail: "default@gmail.com",
          password: "",
          createdTime: DateTime.now(),
          updatedTime: DateTime.now());
    }
    return MaterialApp(
      title: 'Facebook Clone',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: Consumer<UserManager>(
        builder: (context, userManager, child) =>
            userManager.isLoggedIn ? const BasePage() : const LogInPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
