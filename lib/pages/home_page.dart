import 'package:facebook_clone/pages/create_post_page.dart';
import 'package:facebook_clone/utils/db_methods.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/models.dart';
import '../components/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PagingController<int, Post> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> fetchPage(int pageKey) async {
    Future.delayed(const Duration(seconds: 2)).then((value) async {
      try {
        if (!mounted) return;

        final newPosts = await loadMorePosts(pageKey);

        if (newPosts.length < 4) {
          pagingController.appendLastPage(newPosts);
        } else {
          pagingController.appendPage(newPosts, pageKey + newPosts.length);
        }
      } catch (error) {
        pagingController.error = error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: Column(
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
                        builder: (context) {
                          return CreatePostPage(
                            pagingController: pagingController,
                          );
                        },
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
            Expanded(
              child: PagedListView(
                  physics: const BouncingScrollPhysics(),
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Post>(
                    itemBuilder: (context, post, index) => PostCard(
                      post: post,
                      pagingController: pagingController,
                    ),
                    newPageProgressIndicatorBuilder: (context) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    noMoreItemsIndicatorBuilder: (context) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('No more posts')),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
