import 'package:facebook_clone/components/circular_profile.dart';
import 'package:facebook_clone/models/friend_request_model.dart';
import 'package:facebook_clone/utils/friend_request_manager.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key, required this.user});

  final User user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FriendRequestManager>(
        builder: (context, friendRequestsManager, child) {
      return Card(
        child: Row(
          children: [
            const CircularProfile(radius: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.user.profileName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('1 min ago'),
                        ],
                      ),
                    ),
                    const Text('1 mutual friend'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: friendRequestsManager.isFriend(
                              Provider.of<UserManager>(context, listen: false)
                                  .currentUser
                                  .userId!,
                              widget.user.userId!)
                          ? Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[350],
                                    ),
                                    onPressed: () {
                                      friendRequestsManager.unfriend(
                                          widget.user.userId!,
                                          Provider.of<UserManager>(context,
                                                  listen: false)
                                              .currentUser
                                              .userId!);
                                    },
                                    child: const Text('Remove Friend'),
                                  ),
                                ),
                              ],
                            )
                          : friendRequestsManager.isRequested(
                                  widget.user.userId!,
                                  Provider.of<UserManager>(context,
                                          listen: false)
                                      .currentUser
                                      .userId!)
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[600],
                                        ),
                                        onPressed: () {
                                          friendRequestsManager
                                              .confirmFriendRequest(
                                                  widget.user.userId!,
                                                  Provider.of<UserManager>(
                                                          context,
                                                          listen: false)
                                                      .currentUser
                                                      .userId!);
                                        },
                                        child: const Text(
                                          'Accept',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[350],
                                        ),
                                        onPressed: () {},
                                        child: const Text('Delete'),
                                      ),
                                    ),
                                  ],
                                )
                              : friendRequestsManager.isRequested(
                                      Provider.of<UserManager>(context,
                                              listen: false)
                                          .currentUser
                                          .userId!,
                                      widget.user.userId!)
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[350],
                                            ),
                                            onPressed: () {
                                              friendRequestsManager
                                                  .removeFriendRequest(
                                                      FriendRequest(
                                                fromUserId:
                                                    Provider.of<UserManager>(
                                                            context,
                                                            listen: false)
                                                        .currentUser
                                                        .userId!,
                                                toUserId: widget.user.userId!,
                                                isDone: 0,
                                              ));
                                            },
                                            child: const Text('Cancel Request'),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue[600],
                                            ),
                                            onPressed: () {
                                              friendRequestsManager
                                                  .addFriendRequest(
                                                      FriendRequest(
                                                fromUserId:
                                                    Provider.of<UserManager>(
                                                            context,
                                                            listen: false)
                                                        .currentUser
                                                        .userId!,
                                                toUserId: widget.user.userId!,
                                                isDone: 0,
                                              ));
                                            },
                                            child: const Text(
                                              'Add friend',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[350],
                                            ),
                                            onPressed: () {},
                                            child: const Text('Remove'),
                                          ),
                                        ),
                                      ],
                                    ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
