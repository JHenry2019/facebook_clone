import 'package:facebook_clone/pages/create_post_page.dart';
import 'package:facebook_clone/utils/db_methods.dart';
import 'package:facebook_clone/utils/posts_manager.dart';
import 'package:flutter/material.dart';
import 'package:facebook_clone/utils/models.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostsManager>(builder: (context, postsManager, child) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                  const Expanded(
                    child: Text(
                      'facebook',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePostPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                  ),
                ],
              ),
              FutureBuilder(
                future: loadPosts().then((value) => postsManager.posts = value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: postsManager.posts
                          .map(
                            (Post post) => TextButton(
                              onPressed: () {
                                postsManager.deletePost(post);
                              },
                              child: Text(post.text),
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
