import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openDb() async {
  final database = openDatabase(
    join(await getDatabasesPath(), "FbDb.db"),
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Users (userId INTEGER PRIMARY KEY, realName TEXT, profileName TEXT, photoUrl TEXT, createdTime REAL, updatedTime REAL)');
      await db.execute(
          'CREATE TABLE Posts (postId INTEGER PRIMARY KEY, userId INTEGER, createdTime REAL, updatedTime REAL, text TEXT, photoUrl TEXT)');
      debugPrint("Done");
    },
    version: 1,
  );
  return database;
}

Future<List<Post>> loadPosts() async {
  final database = await openDb();
  final postMaps = await database.query('Posts');
  List<Post> posts = [];

  for (Map<String, dynamic> pm in postMaps) {
    posts.add(Post.fromMap(pm));
  }

  return posts;
}

Future<void> delete(Post post) async {
  final database = await openDb();
  await database.delete('Posts', where: 'postId = ?', whereArgs: [post.postId]);

  debugPrint('Success deleting');
}

Future<void> createPost(Post post) async {
  final database = await openDb();
  debugPrint(post.toMap().toString());
  await database.insert('Posts', post.toMap());
}




// await db.execute('''

      //   CREATE TABLE Users (
      //     userId INTEGER,
      //     realName TEXT,
      //     profileName TEXT,
      //     profileUrl TEXT,
      //     createdTime INTEGER,
      //     updatedTime INTEGER
      //     )

      // ''');

      // await db.execute('''

      //   CREATE TABLE Posts (
      //     postId INTEGER PRIMARY KEY,
      //     userId INTEGER,
      //     FOREIGN KEY(userId) REFERENCES Users(userId),
      //     createdTime INTEGER,
      //     updatedTime INTEGER,
      //     text TEXT,
      //     photoUrl TEXT
      //     )

      // ''');

      // await db.execute('''

      //   CREATE TABLE Likes (
      //     likeId INTEGER,
      //     userId INTEGER,
      //     FOREIGN KEY(userId) REFERENCES Users(userId),
      //     postId INTEGER,
      //     FOREIGN KEY(postId) REFERENCES Posts(postId),
      //     createdTime INTEGER,
      //     updatedTime INTEGER
      //   )

      // ''');

      // await db.execute('''

      //   CREATE TABLE Comments (
      //     commentId INTEGER,
      //     userId INTEGER,
      //     FOREIGN KEY(userId) REFERENCES Users(userId),
      //     postId INTEGER,
      //     FOREIGN KEY(postId) REFERENCES Posts(postId),
      //     commentText TEXT,
      //     createdTime INTEGER,
      //     updatedTime INTEGER
      //   )

      // ''');
