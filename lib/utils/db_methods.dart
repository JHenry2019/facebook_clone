import 'package:facebook_clone/models/friend_request_model.dart';

import '../models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'globals.dart';

Future<Database> openDb() async {
  final database = openDatabase(
    join(await getDatabasesPath(), "FbDb.db"),
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Users (userId INTEGER PRIMARY KEY, realName TEXT, profileName TEXT, profileUrl TEXT, mail TEXT, password TEXT, createdTime INTEGER, updatedTime INTEGER)');
      await db.execute(
          'CREATE TABLE Posts (postId INTEGER PRIMARY KEY, userId INTEGER, createdTime INTEGER, updatedTime INTEGER, text TEXT, photoUrl TEXT)');
      await db.execute(
          'CREATE TABLE FriendRequests (id INTEGER PRIMARY KEY, fromUserId INTEGER, toUserId INTEGER, isDone INTEGER)');
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

Future<Map<UserStates, List<User>>> loadOtherUsers(int userId) async {
  final database = await openDb();
  final users =
      await database.query('Users', where: 'userId != ?', whereArgs: [userId]);
  List<User> otherUsers = users.map((user) => User.fromMap(user)).toList();

  final friendsMap = await database.query('FriendRequests',
      where: 'fromUserId = ? or toUserId = ?', whereArgs: [userId, userId]);
  List<FriendRequest> friendRequests =
      friendsMap.map((friend) => FriendRequest.fromMap(friend)).toList();

  List<User> friends = [];
  List<User> nonFriends = [];
  List<User> requestedUsers = [];
  List<User> beingRequestedUsers = [];

  for (User user in otherUsers) {
    if (friendRequests.any((fr) =>
        ((user.userId == fr.fromUserId && userId == fr.toUserId) ||
            (userId == fr.fromUserId && user.userId == fr.toUserId)) &&
        fr.isDone == 1)) {
      friends.add(user);
    } else if (friendRequests.any((fr) =>
        user.userId == fr.toUserId &&
        userId == fr.fromUserId &&
        fr.isDone == 0)) {
      requestedUsers.add(user);
    } else if (friendRequests.any((fr) =>
        user.userId == fr.fromUserId &&
        userId == fr.toUserId &&
        fr.isDone == 0)) {
      beingRequestedUsers.add(user);
    } else {
      nonFriends.add(user);
    }
  }

  return {
    UserStates.friend: friends,
    UserStates.nonFriend: nonFriends,
    UserStates.requested: requestedUsers,
    UserStates.beingRequested: beingRequestedUsers,
  };
}

Future<void> createFriendRequest(FriendRequest fr) async {
  final database = await openDb();
  await database.insert('FriendRequests', fr.toMap());
}

Future<void> deleteFriendRequest(FriendRequest fr) async {
  final database = await openDb();
  await database.delete('FriendRequests',
      where:
          "(fromUserId = ? and toUserId = ?) or (toUserId = ? and fromUserId = ?)",
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

// Future<Map<String, List<User>> loadOtherUsers(int currentUserId) async {
//   final database = await openDb();
//   final friendsMap = await database.query('FriendRequests', where: '(fromUserId = ? or toUserId = ?) and isDone = 1', whereArgs: [currentUserId, currentUserId]);
//   List<FriendRequest> friends = friendsMap.map((friend) => FriendRequest.fromMap(friend)).toList();

// }