import 'package:facebook_clone/pages/base_page.dart';
import 'package:facebook_clone/utils/posts_manager.dart';
import 'package:facebook_clone/utils/tabs_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PostsManager>(
        create: (context) => PostsManager(),
      ),
      ChangeNotifierProvider<TabsManager>(
        create: (context) => TabsManager(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Clone',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const BasePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
