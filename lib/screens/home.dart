import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/services/blog_repository.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final BlogRepository _blogRepository = BlogRepository();

  List<Blog>? blogs;

  @override
  void initState() {
    super.initState();

    // Blog-Einträge asynchron abrufen
    _blogRepository.getBlogPosts().then((blogPosts) {
      setState(() {
        blogs = blogPosts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (blogs == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (blogs!.isEmpty) {
      return const Center(
        child: Text('No blogs yet.'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog"),
      ),
      body: ListView.builder(
        itemCount: blogs!.length,
        itemBuilder: (context, index) {
          var blog = blogs![index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: BlogWidget(blog: blog),
          );
        },
      ),
    );
  }
}

class BlogWidget extends StatelessWidget {
  const BlogWidget({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // TODO: Navigate to Blog Detail Page
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
                        "${blog.publishedAt.day}.${blog.publishedAt.month}.${blog.publishedAt.year}"),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                      ),
                      onPressed: () {
                        // TODO: Like Blog
                      },
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
}
