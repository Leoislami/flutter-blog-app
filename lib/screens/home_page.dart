import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/screens/blog/blog_detail_page.dart';
import 'package:flutter_blog_app/screens/blog/blog_edit_page.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/blog_repository.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<BlogProvider>().readBlogsWithLoadingState();
        },
        child: const BlogListWidget(),
      ),
    );
  }
}

class BlogListWidget extends StatelessWidget {
  const BlogListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    BlogProvider blogProvider = context.watch<BlogProvider>();

    return Stack(
      children: [
        blogProvider.blogs.isEmpty && !blogProvider.isLoading
            ? const Center(
                child: Text('Es sind noch keine Blogs vorhanden.'),
              )
            : ListView.builder(
                itemCount: blogProvider.blogs.length,
                itemBuilder: (context, index) {
                  var blog = blogProvider.blogs[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: BlogWidget(blog: blog),
                  );
                },
              ),
        if (blogProvider.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

class BlogWidget extends StatelessWidget {
  const BlogWidget({super.key, required this.blog});
  final Blog blog;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlogDetailPage(blog: blog),
          ));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(blog.content),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      blog.publishedDateString,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: _isLikedByMe(blog) ? const Icon(Icons.favorite, color: Colors.red) : const Icon(Icons.favorite_border),
                          onPressed: () {
                            _toggleLike(context, blog);
                          },
                        ),
                        if (blog.authorId == authProvider.user?.uid)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlogEditPage(blog: blog),
                            ));
                          },
                        ),
                        if (blog.authorId == authProvider.user?.uid)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _confirmDelete(context, blog.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleLike(BuildContext context, Blog blog) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      await BlogRepository.instance.toggleLikeInfo(userId, blog.id);

      final blogProvider = Provider.of<BlogProvider>(context, listen: false);
      blogProvider.readBlogs();
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  bool _isLikedByMe(Blog blog) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      return blog.likedBy.contains(userId);
    } else {
      return false;
    }
  }

  Future<void> _confirmDelete(BuildContext context, String blogId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Löschen bestätigen'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bist du dir sicher das du diesen Blog löschen willst?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Löschen'),
              onPressed: () async {
                await BlogRepository.instance.deleteBlogPost(blogId);

                final blogProvider = Provider.of<BlogProvider>(context, listen: false);
                blogProvider.readBlogs();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}