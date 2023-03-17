import 'package:facebook_clone/components/circular_profile.dart';
import 'package:facebook_clone/models/friend_request_model.dart';
import 'package:facebook_clone/utils/globals.dart';
import 'package:facebook_clone/utils/other_users_manager.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../utils/date_calculator.dart';

class UserCard extends StatefulWidget {
  const UserCard(
      {super.key,
      required this.user,
      required this.userState,
      required this.time});

  final User user;
  final UserStates userState;
  final DateTime time;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OtherUsersManager>(
        builder: (context, otherUsersManager, child) {
      Map<UserStates, Widget> buttons = {
        UserStates.friend: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[350],
                ),
                onPressed: () {
                  otherUsersManager.unfriend(
                      widget.user.userId!,
                      Provider.of<UserManager>(context, listen: false)
                          .currentUser
                          .userId!);
                },
                child: const Text('Remove Friend'),
              ),
            ),
          ],
        ),
        UserStates.nonFriend: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                ),
                onPressed: () {
                  otherUsersManager.sendRequest(FriendRequest(
                    fromUserId: Provider.of<UserManager>(context, listen: false)
                        .currentUser
                        .userId!,
                    toUserId: widget.user.userId!,
                    isDone: 0,
                    requestedTime: DateTime.now(),
                    acceptedTime: DateTime.now(),
                  ));
                },
                child: const Text(
                  'Add friend',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        UserStates.requested: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[350],
                ),
                onPressed: () {
                  otherUsersManager.cancelRequet(FriendRequest(
                    fromUserId: Provider.of<UserManager>(context, listen: false)
                        .currentUser
                        .userId!,
                    toUserId: widget.user.userId!,
                    isDone: 0,
                    requestedTime: DateTime.now(),
                    acceptedTime: DateTime.now(),
                  ));
                },
                child: const Text('Cancel Request'),
              ),
            ),
          ],
        ),
        UserStates.beingRequested: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                ),
                onPressed: () {
                  otherUsersManager.acceptRequest(FriendRequest(
                    toUserId: Provider.of<UserManager>(context, listen: false)
                        .currentUser
                        .userId!,
                    fromUserId: widget.user.userId!,
                    isDone: 1,
                    requestedTime: DateTime.now(),
                    acceptedTime: DateTime.now(),
                  ));
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
                onPressed: () {
                  otherUsersManager.declineRequest(FriendRequest(
                    fromUserId: widget.user.userId!,
                    toUserId: Provider.of<UserManager>(context, listen: false)
                        .currentUser
                        .userId!,
                    isDone: 0,
                    requestedTime: DateTime.now(),
                    acceptedTime: DateTime.now(),
                  ));
                },
                child: const Text('Delete'),
              ),
            ),
          ],
        ),
      };

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
                          widget.userState == UserStates.nonFriend
                              ? const Text('')
                              : Text(DateTimeCalculator.calculateTime(
                                  widget.time)),
                        ],
                      ),
                    ),
                    const Text('1 mutual friend'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: buttons[widget.userState],
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
