import 'package:facebook_clone/components/circular_profile.dart';
import 'package:facebook_clone/utils/db_methods.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import '../models/models.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Post> postsByUser = [];

    return Consumer<UserManager>(
      builder: ((context, userManager, child) {
        return SafeArea(
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                  Expanded(
                    child: Text(
                      userManager.currentUser.profileName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {
                      userManager.logOutUser();
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/cover_photo_example.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 225,
                  ),
                  const Positioned(
                    bottom: -40,
                    child: CircularProfile(
                      radius: 80,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  userManager.currentUser.profileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              FutureBuilder(
                  future: loadPostsByUser(userManager.currentUser.userId!)
                      .then((value) => postsByUser = value.toList()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        children: postsByUser
                            .map((Post post) => PostCard(post: post))
                            .toList(),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ],
          ),
        );
      }),
    );
  }
}
