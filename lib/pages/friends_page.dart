import 'package:facebook_clone/components/user_card.dart';
import 'package:facebook_clone/utils/other_users_manager.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/db_methods.dart';
import '../utils/globals.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

UserStates currentPage = UserStates.friend;

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserManager, OtherUsersManager>(
      builder: (context, userManager, otherUsersManager, child) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                    label: const Text("Friends"),
                    selected: currentPage == UserStates.friend,
                    onSelected: (value) => setState(() {
                      currentPage = UserStates.friend;
                    }),
                  ),
                  ChoiceChip(
                    label: const Text("Requests"),
                    selected: currentPage == UserStates.beingRequested,
                    onSelected: (value) => setState(() {
                      currentPage = UserStates.beingRequested;
                    }),
                  ),
                  ChoiceChip(
                    label: const Text("Requested"),
                    selected: currentPage == UserStates.requested,
                    onSelected: (value) => setState(() {
                      currentPage = UserStates.requested;
                    }),
                  ),
                  ChoiceChip(
                    label: const Text("Others"),
                    selected: currentPage == UserStates.nonFriend,
                    onSelected: (value) => setState(() {
                      currentPage = UserStates.nonFriend;
                    }),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: loadOtherUsers(userManager.currentUser.userId!)
                            .then((value) {
                          otherUsersManager.otherUsers = value['users'];
                          otherUsersManager.times = value['times'];
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children:
                                  otherUsersManager.otherUsers[currentPage]!
                                      .map((user) => UserCard(
                                            user: user,
                                            userState: currentPage,
                                            time: otherUsersManager
                                                .times[user.userId]!,
                                          ))
                                      .toList(),
                            );
                          } else {
                            return const SizedBox(
                              height: 400,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
