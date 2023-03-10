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
