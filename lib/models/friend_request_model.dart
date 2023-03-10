class FriendRequest {
  int fromUserId;
  int toUserId;
  int isDone;

  FriendRequest(
      {required this.fromUserId, required this.toUserId, required this.isDone});

  void accept() {
    isDone = 1;
  }

  Map<String, dynamic> toMap() {
    return {
      "fromUserId": fromUserId,
      "toUserId": toUserId,
      "isDone": isDone,
    };
  }

  static FriendRequest fromMap(Map<String, dynamic> map) {
    return FriendRequest(
        fromUserId: map['fromUserId'],
        toUserId: map['toUserId'],
        isDone: map['isDone']);
  }
}
