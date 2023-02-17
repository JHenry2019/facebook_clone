import 'package:facebook_clone/utils/db_methods.dart';
import 'package:facebook_clone/utils/models.dart';
import 'package:flutter/material.dart';

class PostsManager extends ChangeNotifier {
  List<Post> posts = [];

  void addPosts(List<Post> posts) {
    this.posts = posts;
    notifyListeners();
  }

  void addPost(Post post) async {
    await createPost(post);
    posts.add(post);
    notifyListeners();
  }

  void deletePost(Post post) async {
    posts.remove(post);
    await delete(post);
    notifyListeners();
  }
}
