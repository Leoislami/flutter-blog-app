import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/screens/blog/blog_detail_page.dart';
import 'package:flutter_blog_app/services/blog_service.dart';
import 'package:flutter_blog_app/services/blog_api.dart';
import 'package:provider/provider.dart';

/// HomePage ist die Hauptseite der Blog-App, die eine Liste von Blogs anzeigt.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog"),
      ),
      body: RefreshIndicator(
        // Ermöglicht das Herunterziehen zum Aktualisieren der Blog-Liste.
        onRefresh: () async {
          context.read<BlogProvider>().readBlogsWithLoadingState();
        },
        child: const BlogListWidget(), // Anzeige der Blog-Liste
      ),
    );
  }
}

/// BlogListWidget ist ein Widget, das die Blog-Liste anzeigt.
class BlogListWidget extends StatelessWidget {
  const BlogListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    BlogProvider blogProvider = context.watch<BlogProvider>();

    return Stack(
      children: [
        // Zeigt eine Nachricht an, wenn keine Blogs vorhanden sind.
        blogProvider.blogs.isEmpty && !blogProvider.isLoading
            ? const Center(
                child: Text('No blogs yet.'),
              )
            // ListView, das die Blogs anzeigt.
            : ListView.builder(
                itemCount: blogProvider.blogs.length,
                itemBuilder: (context, index) {
                  var blog = blogProvider.blogs[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: BlogWidget(blog: blog), // Einzelnes Blog-Widget
                  );
                },
              ),
        // Zeigt einen Ladeindikator an, während die Blogs geladen werden.
        if (blogProvider.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

/// BlogWidget ist ein Widget, das ein einzelnes Blog anzeigt.
class BlogWidget extends StatelessWidget {
  const BlogWidget({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        // Navigiert zur Detailseite des Blogs beim Klicken.
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
                // Zeigt den Titel des Blogs.
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Zeigt den Inhalt des Blogs.
                Text(blog.content),
                const SizedBox(height: 8.0),
                // Zeigt das Veröffentlichungsdatum und Like-Button an.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      blog.publishedDateString,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    // Like-Button, um den Like-Status zu ändern.
                    IconButton(
                      icon: Icon(
                        blog.isLikedByUser()
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () async {
                        var blogProvider = context.read<BlogProvider>();
                        await blogProvider.toggleBlogLike(blog.id);
                        blogProvider.readBlogsWithLoadingState();
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
