import 'package:facebook_clone/utils/models.dart';
import 'package:facebook_clone/utils/posts_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

final _formKey = GlobalKey<FormState>();

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Create'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: textController,
              validator: (value) {
                if (value == '' || value!.isEmpty) {
                  return 'Please enter some text.';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Post post = Post(text: textController.text);
                  debugPrint(post.toString());
                  Provider.of<PostsManager>(context, listen: false)
                      .addPost(post);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
