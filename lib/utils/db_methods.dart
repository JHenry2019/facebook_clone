import 'package:facebook_clone/models/friend_request_model.dart';

import '../models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openDb() async {
  final database = openDatabase(
    join(await getDatabasesPath(), "FbDb.db"),
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Users (userId INTEGER PRIMARY KEY, realName TEXT, profileName TEXT, profileUrl TEXT, mail TEXT, password TEXT, createdTime INTEGER, updatedTime INTEGER)');
      await db.execute(
          'CREATE TABLE Posts (postId INTEGER PRIMARY KEY, userId INTEGER, createdTime INTEGER, updatedTime INTEGER, text TEXT, photoUrl TEXT)');
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

Future<List<Post>> loadPostsByUser(int userId) async {
  final database = await openDb();
  final postMaps =
      await database.query('Posts', where: 'userId = ?', whereArgs: [userId]);
  List<Post> posts = [];

  for (Map<String, dynamic> pm in postMaps) {
    posts.add(Post.fromMap(pm));
  }

  return posts;
}

Future<void> delete(Post post) async {
  final database = await openDb();
  await database.delete('Posts', where: 'postId = ?', whereArgs: [post.postId]);
}

Future<void> createPost(Post post) async {
  final database = await openDb();
  await database.insert('Posts', post.toMap());
}

Future<void> createUser(User user) async {
  final database = await openDb();
  await database.insert('Users', user.toMap());
}

Future<User> logIn(String mail, String password) async {
  final database = await openDb();
  final users =
      await database.query('Users', where: 'mail = ?', whereArgs: [mail]);

  if (users.isEmpty) {
    return Future.error(Exception("User does not exits."));
  } else {
    final user = User.fromMap(users[0]);

    if (password == user.password) {
      return user;
    } else {
      return Future.error(Exception("Wrong Password"));
    }
  }
}

Future<User> loadUser(int userId) async {
  final database = await openDb();
  final users =
      await database.query('Users', where: 'userId = ?', whereArgs: [userId]);
  return User.fromMap(users[0]);
}

Future<List<User>> loadUsers(int userId) async {
  final database = await openDb();
  final users =
      await database.query('Users', where: 'userId != ?', whereArgs: [userId]);
  List<User> otherUsers = users.map((user) => User.fromMap(user)).toList();
  return otherUsers;
}

Future<void> createFriendRequest(FriendRequest fr) async {
  final database = await openDb();
  await database.insert('FriendRequests', fr.toMap());
}

Future<void> deleteFriendRequest(FriendRequest fr) async {
  final database = await openDb();
  await database.delete('FriendRequests',
      where: "fromUserId = ? and toUserId = ?",
      whereArgs: [fr.fromUserId, fr.toUserId]);
}

Future<void> acceptFriendRequest(FriendRequest fr) async {
  final database = await openDb();
  await database.update('FriendRequests', fr.toMap(),
      where: "fromUserId = ? and toUserId = ?",
      whereArgs: [fr.fromUserId, fr.toUserId]);
}

Future<void> removeFriend(int user1, int user2) async {
  final database = await openDb();
  await database.delete('FriendRequests',
      where: "fromUserId = ? and toUserId = ?", whereArgs: [user1, user2]);
  await database.delete('FriendRequests',
      where: "fromUserId = ? and toUserId = ?", whereArgs: [user2, user1]);
}

Future<List<FriendRequest>> loadFriendRequests() async {
  final database = await openDb();
  final friendRequests = await database.query('FriendRequests');
  return friendRequests
      .map((friendRequest) => FriendRequest.fromMap(friendRequest))
      .toList();
}

  // await database.execute('DROP TABLE IF EXISTS FriendRequest');
  // await database
  //     .execute(
  //         'CREATE TABLE FriendRequests (id INTEGER PRIMARY KEY, fromUserId INTEGER, toUserId INTEGER, isDone INTEGER)')
  //     .then((value) => print('Hi'));