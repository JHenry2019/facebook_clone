import 'package:facebook_clone/components/circular_profile.dart';
import 'package:facebook_clone/utils/db_methods.dart';
import 'package:facebook_clone/utils/posts_manager.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:provider/provider.dart';
import '../utils/date_calculator.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: loadUser(widget.post.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: const EdgeInsets.all(5),
              child: Card(
                elevation: 2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const CircularProfile(
                              radius: 18,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!.profileName),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(DateTimeCalculator.calculateTime(
                                        widget.post.updatedTime)),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Icon(
                                      Icons.public,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            const Icon(Icons.more_horiz),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Provider.of<PostsManager>(context,
                                        listen: false)
                                    .deletePost(widget.post);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 100),
                        padding: const EdgeInsets.all(8),
                        child: Text(widget.post.text),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(Icons.thumb_up_off_alt_outlined),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Like'),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(Icons.insert_comment_outlined),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Comment'),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(Icons.subdirectory_arrow_right_outlined),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Share'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
