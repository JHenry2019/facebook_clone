class Comment {
  int? commentId;
  int userId;
  int postId;
  String commentText;

  Comment({
    this.commentId,
    required this.userId,
    required this.postId,
    required this.commentText,
  });
}
