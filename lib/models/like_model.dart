class Like {
  int? likeId;
  int userId;
  int postOrCommentId;

  Like({
    this.likeId,
    required this.userId,
    required this.postOrCommentId,
  });
}
