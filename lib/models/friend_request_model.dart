class FriendRequest {
  int fromUserId;
  int toUserId;
  int isDone;
  DateTime requestedTime;
  DateTime acceptedTime;

  FriendRequest({
    required this.fromUserId,
    required this.toUserId,
    required this.isDone,
    required this.requestedTime,
    required this.acceptedTime,
  });

  void accept() {
    isDone = 1;
  }

  Map<String, dynamic> toMap() {
    return {
      "fromUserId": fromUserId,
      "toUserId": toUserId,
      "isDone": isDone,
      "requestedTime": requestedTime.millisecondsSinceEpoch,
      "acceptedTime": acceptedTime.millisecondsSinceEpoch,
    };
  }

  static FriendRequest fromMap(Map<String, dynamic> map) {
    return FriendRequest(
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      isDone: map['isDone'],
      requestedTime: DateTime.fromMillisecondsSinceEpoch(map['requestedTime']),
      acceptedTime: DateTime.fromMillisecondsSinceEpoch(map['acceptedTime']),
    );
  }
}
