import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/screens/blog/blog_detail_page.dart';
import 'package:flutter_blog_app/screens/blog/blog_edit_page.dart';
import 'package:provider/provider.dart';

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
                child: Text('No blogs yet.'),
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
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () async {
                            // Like-Funktionalität
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlogEditPage(blog: blog),
                            ));
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
}