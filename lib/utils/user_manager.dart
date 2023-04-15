import 'package:facebook_clone/models/user_model.dart';
import 'package:flutter/material.dart';
import '../utils/db_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager extends ChangeNotifier {
  User currentUser;
  bool isLoggedIn = false;

  UserManager({required this.currentUser});

  void signUpUser(User user) async {
    await createUser(user);
    notifyListeners();
  }

  void logInUser(String mail, String password, BuildContext context) async {
    currentUser = await logIn(mail, password).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      throw Exception("Something went wrong");
    });

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setInt('currentUserId', currentUser.userId!);

    isLoggedIn = true;

    notifyListeners();
  }

  void logOutUser() async {
    isLoggedIn = false;

    currentUser = User(
        userId: 0,
        realName: "Default account",
        profileName: "Default account",
        mail: "default@gmail.com",
        password: "",
        createdTime: DateTime.now(),
        updatedTime: DateTime.now());

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.remove('currentUserId');

    notifyListeners();
  }

  void logInUserById(int id, BuildContext context) async {
    currentUser = await logInById(id).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      throw Exception("Something went wrong");
    });

    isLoggedIn = true;

    notifyListeners();
  }
}
