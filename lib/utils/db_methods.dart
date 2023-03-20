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
          'CREATE TABLE FriendRequests (id INTEGER PRIMARY KEY, fromUserId INTEGER, toUserId INTEGER, isDone INTEGER, requestedTime INTEGER, acceptedTime INTEGER)');
      await db.execute(
          'CREATE TABLE Likes (id INTEGER PRIMARY KEY, userId INTEGER, postId INTEGER, likedTime INTEGER)');
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

Future<Map<String, dynamic>> loadOtherUsers(int userId) async {
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

  Map<int, DateTime> times = {};

  for (User user in otherUsers) {
    if (friendRequests.any((fr) =>
        ((user.userId == fr.fromUserId && userId == fr.toUserId) ||
            (userId == fr.fromUserId && user.userId == fr.toUserId)) &&
        fr.isDone == 1)) {
      friends.add(user);
      times[user.userId!] = friendRequests
          .firstWhere((fr) =>
              ((user.userId == fr.fromUserId && userId == fr.toUserId) ||
                  (userId == fr.fromUserId && user.userId == fr.toUserId)) &&
              fr.isDone == 1)
          .acceptedTime;
    } else if (friendRequests.any((fr) =>
        user.userId == fr.toUserId &&
        userId == fr.fromUserId &&
        fr.isDone == 0)) {
      requestedUsers.add(user);
      times[user.userId!] = friendRequests
          .firstWhere((fr) =>
              user.userId == fr.toUserId &&
              userId == fr.fromUserId &&
              fr.isDone == 0)
          .requestedTime;
    } else if (friendRequests.any((fr) =>
        user.userId == fr.fromUserId &&
        userId == fr.toUserId &&
        fr.isDone == 0)) {
      beingRequestedUsers.add(user);
      times[user.userId!] = friendRequests
          .firstWhere((fr) =>
              user.userId == fr.fromUserId &&
              userId == fr.toUserId &&
              fr.isDone == 0)
          .requestedTime;
    } else {
      nonFriends.add(user);
      times[user.userId!] = DateTime.now();
    }
  }

  return {
    'users': {
      UserStates.friend: friends,
      UserStates.nonFriend: nonFriends,
      UserStates.requested: requestedUsers,
      UserStates.beingRequested: beingRequestedUsers,
    },
    'times': times,
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

Future<void> createLike(Like like) async {
  final database = await openDb();
  await database.insert('Likes', like.toMap());
}

Future<void> deleteLike(int userId, int postId) async {
  final database = await openDb();
  await database.delete('Likes',
      where: 'userId = ? and postId = ?', whereArgs: [userId, postId]);
}

Future<bool> isLiked(int userId, int postId) async {
  final database = await openDb();
  final likes = await database.query('Likes',
      where: 'userId = ? and postId = ?', whereArgs: [userId, postId]);
  if (likes.isEmpty) {
    return false;
  } else {
    return true;
  }
}

Future<int> countLikes(int postId) async {
  final database = await openDb();
  final likes =
      await database.query('Likes', where: 'postId = ?', whereArgs: [postId]);
  return likes.length;
}

Future<Map<String, int>> getCountLikes() async {
  final database = await openDb();
  final likes = await database.query('Likes');
  Map<String, int> likesByPost = {};
  for (var like in likes) {
    if (likesByPost.containsKey(like['postId'])) {
      likesByPost[like['postId'].toString()] =
          likesByPost[like['postId'].toString()]! + 1;
    } else {
      likesByPost[like['postId'].toString()] = 1;
    }
  }
  return likesByPost;
}
