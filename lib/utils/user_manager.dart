import 'package:facebook_clone/models/user_model.dart';
import 'package:flutter/material.dart';
import '../utils/db_methods.dart';

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
    isLoggedIn = true;
    notifyListeners();
  }

  void logOutUser() {
    currentUser = User(
        userId: 0,
        realName: "Default account",
        profileName: "Default account",
        mail: "default@gmail.com",
        password: "",
        createdTime: DateTime.now(),
        updatedTime: DateTime.now());
    isLoggedIn = false;
    notifyListeners();
  }
}
