import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: ((context, userManager, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(userManager.currentUser.profileName),
              ElevatedButton(
                onPressed: () {
                  userManager.logOutUser();
                },
                child: const Text('Log out'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
