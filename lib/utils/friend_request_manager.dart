import 'package:facebook_clone/models/friend_request_model.dart';
import 'package:facebook_clone/utils/db_methods.dart';
import 'package:flutter/material.dart';

class FriendRequestManager extends ChangeNotifier {
  List<FriendRequest> friendRequests = [];

  // void updateFriendRequests() async {
  //   friendRequests = await loadFriendRequests();
  // }

  void addFriendRequest(FriendRequest friendRequest) async {
    if (!checkAlreadyExist(friendRequest)) {
      await createFriendRequest(friendRequest);
      friendRequests.add(friendRequest);
    }
    notifyListeners();
  }

  void removeFriendRequest(FriendRequest friendRequest) async {
    if (checkAlreadyExist(friendRequest)) {
      friendRequests.removeWhere((fr) =>
          fr.fromUserId == friendRequest.fromUserId &&
          fr.toUserId == friendRequest.toUserId &&
          fr.isDone == friendRequest.isDone);
      await deleteFriendRequest(friendRequest);
    }
    notifyListeners();
  }

  void confirmFriendRequest(int fromUserId, int toUserId) async {
    await acceptFriendRequest(
        FriendRequest(fromUserId: fromUserId, toUserId: toUserId, isDone: 1));
    for (int i = 0; i < friendRequests.length; i++) {
      if ((friendRequests[i].fromUserId == fromUserId &&
          friendRequests[i].toUserId == toUserId)) {
        friendRequests[i].isDone = 1;
      }
    }
    notifyListeners();
  }

  void unfriend(int user1, int user2) async {
    await removeFriend(user1, user2);
    friendRequests.removeWhere((fr) =>
        ((fr.fromUserId == user1 && fr.toUserId == user2) ||
            (fr.fromUserId == user2 && fr.toUserId == user1)));
    notifyListeners();
  }

  bool checkAlreadyExist(FriendRequest friendRequest) {
    for (FriendRequest fr in friendRequests) {
      if ((fr.fromUserId == friendRequest.fromUserId &&
              fr.toUserId == friendRequest.toUserId) ||
          (fr.fromUserId == friendRequest.toUserId &&
              fr.toUserId == friendRequest.fromUserId)) {
        return true;
      }
    }
    return false;
  }

  List<int> getFriendRequestByUser(int userId) {
    List<int> requestedUsers = [];
    for (FriendRequest fr in friendRequests) {
      if (fr.fromUserId == userId) {
        requestedUsers.add(fr.toUserId);
      }
    }
    return requestedUsers;
  }

  bool isRequested(int fromUserId, int toUserId) {
    for (FriendRequest fr in friendRequests) {
      if (fr.fromUserId == fromUserId && fr.toUserId == toUserId) {
        return true;
      }
    }
    return false;
  }

  bool isFriend(int user1, int user2) {
    for (FriendRequest fr in friendRequests) {
      if ((fr.fromUserId == user1 && fr.toUserId == user2 && fr.isDone == 1) ||
          (fr.fromUserId == user2 && fr.toUserId == user1 && fr.isDone == 1)) {
        return true;
      }
    }
    return false;
  }
}
