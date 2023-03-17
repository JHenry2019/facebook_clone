import 'package:facebook_clone/models/friend_request_model.dart';
import 'package:facebook_clone/utils/db_methods.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'globals.dart';

class OtherUsersManager extends ChangeNotifier {
  Map<UserStates, List<User>> otherUsers = {};

  Future<void> acceptRequest(FriendRequest fr) async {
    await acceptFriendRequest(fr);

    User acceptedUser = otherUsers[UserStates.beingRequested]!
        .firstWhere((user) => user.userId == fr.fromUserId);
    otherUsers[UserStates.beingRequested]!
        .removeWhere((user) => user.userId == fr.fromUserId);
    otherUsers[UserStates.friend]!.add(acceptedUser);

    notifyListeners();
  }

  Future<void> declineRequest(FriendRequest fr) async {
    await deleteFriendRequest(fr);

    User declinedUser = otherUsers[UserStates.beingRequested]!
        .firstWhere((user) => user.userId == fr.fromUserId);
    otherUsers[UserStates.beingRequested]!
        .removeWhere((user) => user.userId == fr.fromUserId);
    otherUsers[UserStates.nonFriend]!.add(declinedUser);

    notifyListeners();
  }

  Future<void> sendRequest(FriendRequest fr) async {
    await createFriendRequest(fr);

    User sentUser = otherUsers[UserStates.nonFriend]!
        .firstWhere((user) => user.userId == fr.toUserId);
    otherUsers[UserStates.nonFriend]!
        .removeWhere((user) => user.userId == fr.toUserId);
    otherUsers[UserStates.requested]!.add(sentUser);

    notifyListeners();
  }

  Future<void> cancelRequet(FriendRequest fr) async {
    await deleteFriendRequest(fr);

    User canceledUser = otherUsers[UserStates.requested]!
        .firstWhere((user) => user.userId == fr.toUserId);
    otherUsers[UserStates.requested]!
        .removeWhere((user) => user.userId == fr.toUserId);
    otherUsers[UserStates.nonFriend]!.add(canceledUser);

    notifyListeners();
  }

  Future<void> unfriend(int user1, int user2) async {
    await removeFriend(user1, user2);

    User removedUser = otherUsers[UserStates.friend]!
        .firstWhere((user) => user.userId == user1);
    otherUsers[UserStates.friend]!.removeWhere((user) => user.userId == user1);
    otherUsers[UserStates.nonFriend]!.add(removedUser);

    notifyListeners();
  }
}
