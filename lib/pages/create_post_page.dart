import 'package:facebook_clone/components/components.dart';
import 'package:facebook_clone/utils/user_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/models.dart';
import 'package:facebook_clone/utils/posts_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({
    Key? key,
    this.pagingController,
  }) : super(key: key);

  final PagingController<int, Post>? pagingController;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

final _formKey = GlobalKey<FormState>();

class _CreatePostPageState extends State<CreatePostPage> {
  final textController = TextEditingController();
  bool isTextEmpty = true;
  late Post post;

  @override
  Widget build(BuildContext context) {
    post = Post(
        text: textController.text,
        createdTime: DateTime.now(),
        updatedTime: DateTime.now(),
        userId: Provider.of<UserManager>(context, listen: false)
            .currentUser
            .userId!);

    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            const Text(
              'Create Post',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ElevatedButton(
                onPressed: isTextEmpty
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<PostsManager>(context, listen: false)
                              .addPost(post);
                          if (widget.pagingController != null) {
                            widget.pagingController!.refresh();
                          }
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                child: const Text('Post'),
              ),
            ),
          ],
        ),
        Container(
          constraints: const BoxConstraints(minHeight: 200),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  TextFormField(
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          isTextEmpty = false;
                        } else {
                          isTextEmpty = true;
                        }
                      });
                    },
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'What is on your mind',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == '' || value!.isEmpty) {
                        return 'Please enter some text.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const Text(
          'Preview',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Flexible(
            child: SingleChildScrollView(
                child: PostCard(
          post: post,
        )))
      ]),
    ));
  }
}
