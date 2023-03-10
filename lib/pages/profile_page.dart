import 'package:facebook_clone/pages/create_post_page.dart';
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Posts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Filters',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            const CircularProfile(radius: 18),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreatePostPage(),
                                  ),
                                );
                              },
                              child: const Text("What's on your mind?"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
                      return const SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
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
