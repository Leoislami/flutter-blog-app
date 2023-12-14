import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';

// Definiert die Detailseite für einen Blog-Beitrag.
class BlogDetailPage extends StatelessWidget {
  final Blog blog;
  const BlogDetailPage({required this.blog, super.key});

  @override
  Widget build(BuildContext context) {
    // Ein Scaffold, das die Grundstruktur der Seite bereitstellt.
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title), // Zeigt den Titel des Blogs in der AppBar.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Innerer Abstand für den Body.
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Inhalte linksbündig ausrichten.
          children: <Widget>[
            Text(blog.title,
                style: Theme.of(context).textTheme.headlineSmall), // Blogtitel.
            const SizedBox(height: 8.0), // Abstandshalter.
            Text(blog.content), // Der Inhalt des Blogs.
            const SizedBox(height: 8.0), // Weitere Abstandshalter.
            Text(
                blog
                    .publishedDateString, // Veröffentlichungsdatum als formatierter String.
                style: Theme.of(context)
                    .textTheme
                    .bodySmall), // Kleinerer Textstil.
          ],
        ),
      ),
    );
  }
}
