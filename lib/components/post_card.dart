import 'package:facebook_clone/components/circular_profile.dart';
import 'package:facebook_clone/utils/posts_manager.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(children: [
          Row(
            children: [
              const CircularProfile(),
              const SizedBox(
                width: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Name'),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('10 mins ago'),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
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
                  Provider.of<PostsManager>(context, listen: false)
                      .deletePost(widget.post);
                },
              ),
            ],
          ),
          Text(widget.post.text),
          SizedBox(
            height: 200,
            child: Container(color: Colors.blue),
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
  }
}
