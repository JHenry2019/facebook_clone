class Post {
  int? postId;
  String text;
  int likes;

  Post({
    this.postId,
    required this.text,
    this.likes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'likes': likes,
    };
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['id'],
      text: map['text'],
      likes: map['likes'],
    );
  }

  @override
  String toString() {
    return 'Post{id: $postId, text: $text, likes: $likes}';
  }
}

class User {
  int userId;
  String realName;
  String profileName;

  User({
    required this.userId,
    required this.realName,
    required this.profileName,
  });

  @override
  String toString() {
    return "User{id: $userId, realName: $realName, profileName: $profileName";
  }
}
