import 'package:facebook_clone/components/user_card.dart';
import 'package:facebook_clone/utils/db_methods.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

List<User> users = [];

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (context, userManager, child) {
        return SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                  const Expanded(
                    child: Text(
                      'Friends',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: loadUsers(userManager.currentUser.userId!)
                            .then((value) => users = value.toList()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children: users
                                  .map((user) => UserCard(user: user))
                                  .toList(),
                            );
                          } else {
                            return const SizedBox(
                              height: 600,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
