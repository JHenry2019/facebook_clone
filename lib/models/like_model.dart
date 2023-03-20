class Like {
  int? likeId;
  int userId;
  int postId;
  DateTime likedTime;

  Like({
    this.likeId,
    required this.userId,
    required this.postId,
    required this.likedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': likeId,
      'userId': userId,
      'postId': postId,
      'likedTime': likedTime.millisecondsSinceEpoch,
    };
  }

  static Like fromMap(Map<String, dynamic> map) {
    return Like(
      likeId: map['id'],
      userId: map['userId'],
      postId: map['postId'],
      likedTime: DateTime.fromMillisecondsSinceEpoch(map['likedTime']),
    );
  }
}
