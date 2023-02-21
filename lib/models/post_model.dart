class Post {
  int? postId;
  int userId;
  DateTime createdTime;
  DateTime updatedTime;
  String text;
  String? photoUrl;

  Post({
    this.postId,
    required this.userId,
    required this.createdTime,
    required this.updatedTime,
    required this.text,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'createdTime': createdTime.millisecondsSinceEpoch,
      'updatedTime': updatedTime.millisecondsSinceEpoch,
      'text': text,
      'photoUrl': photoUrl,
    };
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'],
      userId: map['userId'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(map['createdTime']),
      updatedTime: DateTime.fromMillisecondsSinceEpoch(map['updatedTime']),
      text: map['text'],
    );
  }

  @override
  String toString() {
    return 'Post{id: $postId, text: $text}';
  }
}
