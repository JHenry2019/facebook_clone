import 'package:facebook_clone/utils/db_methods.dart';
import 'package:facebook_clone/utils/likes_manager.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key, required this.post});
  final Post post;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: isLiked(
                Provider.of<UserManager>(context, listen: false)
                    .currentUser
                    .userId!,
                widget.post.postId!)
            .then((value) => _isLiked = value),
        builder: (context, snapshot) {
          return TextButton(
            onPressed: () async {
              if (_isLiked) {
                Provider.of<LikesManager>(context, listen: false).unlikePost(
                    Provider.of<UserManager>(context, listen: false)
                        .currentUser
                        .userId!,
                    widget.post.postId!);
              } else {
                Provider.of<LikesManager>(context, listen: false).likePost(Like(
                    userId: Provider.of<UserManager>(context, listen: false)
                        .currentUser
                        .userId!,
                    postId: widget.post.postId!,
                    likedTime: DateTime.now()));
              }
              setState(() {
                _isLiked = !_isLiked;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                  color: _isLiked ? Colors.blue : Colors.grey,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'Like',
                  style: TextStyle(
                    color: _isLiked ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
