import 'package:facebook_clone/utils/db_methods.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class LikesManager extends ChangeNotifier {
  Map<String, int> likes = {};

  Future<void> getLikeCount(int postId) async {
    int count = await countLikes(postId);
    likes[postId.toString()] = count;
    notifyListeners();
  }

  Future<void> likePost(Like like) async {
    await createLike(like);
    likes[like.postId.toString()] = likes[like.postId.toString()]! + 1;
    notifyListeners();
  }

  Future<void> unlikePost(int userId, int postId) async {
    await deleteLike(userId, postId);
    likes[postId.toString()] = likes[postId.toString()]! - 1;
    notifyListeners();
  }
}
