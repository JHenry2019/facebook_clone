import 'package:flutter/material.dart';
import '../utils/db_methods.dart';
import '../utils/likes_manager.dart';
import 'package:provider/provider.dart';

class LikeCount extends StatefulWidget {
  const LikeCount({super.key, required this.postId});
  final int postId;

  @override
  State<LikeCount> createState() => _LikeCountState();
}

class _LikeCountState extends State<LikeCount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FutureBuilder(
          future: countLikes(widget.postId).then((value) =>
              Provider.of<LikesManager>(context)
                  .likes[widget.postId.toString()] = value),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(Provider.of<LikesManager>(context)
                  .likes[widget.postId.toString()]
                  .toString());
            } else {
              return const Text('');
            }
          })),
    );
  }
}
