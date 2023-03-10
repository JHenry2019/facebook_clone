import 'models.dart';

class FriendRequest {
  User requestedUser;
  User acceptedUser;
  bool isDone = false;

  FriendRequest({
    required this.requestedUser,
    required this.acceptedUser,
  });

  void accept() {
    isDone = true;
  }
}
