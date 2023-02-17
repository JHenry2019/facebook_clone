import 'package:facebook_clone/utils/models.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openDb() async {
  final database = openDatabase(
    join(await getDatabasesPath(), "FbDb.db"),
    onCreate: (db, version) => db.execute(
        'CREATE TABLE post (id INTEGER PRIMARY KEY, text TEXT, likes INTEGER)'),
    version: 1,
  );
  return database;
}

Future<List<Post>> loadPosts() async {
  final database = await openDb();
  final postMaps = await database.query('post');
  List<Post> posts = [];

  for (Map<String, dynamic> pm in postMaps) {
    posts.add(Post.fromMap(pm));
  }

  return posts;
}

Future<void> delete(Post post) async {
  final database = await openDb();
  await database.delete('post', where: 'id = ?', whereArgs: [post.postId]);

  debugPrint('Success deleting');
}

Future<void> createPost(Post post) async {
  final database = await openDb();
  await database.insert('post', post.toMap());
}
