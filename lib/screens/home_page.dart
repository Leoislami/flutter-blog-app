import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/screens/blog/blog_detail_page.dart';
import 'package:flutter_blog_app/services/blog_repository.dart';

// Definiert die Startseite der App mit einer Liste von Blog-Beiträgen.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BlogRepository _blogRepository =
      BlogRepository(); // Instanz des BlogRepository.
  List<Blog>? blogs; // Liste, die Blog-Beiträge enthält.

  @override
  void initState() {
    super.initState();
    // Blog-Einträge asynchron abrufen und den State aktualisieren, wenn sie geladen sind.
    _blogRepository.getBlogPosts().then((blogPosts) {
      if (!mounted) return; // Überprüft, ob das Widget noch im Widget-Baum ist.
      setState(() {
        blogs = blogPosts; // Aktualisiert die Liste der Blog-Beiträge.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Anzeige eines Ladeindikators, wenn die Blogs noch nicht geladen wurden.
    if (blogs == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Anzeige einer Nachricht, wenn keine Blogs vorhanden sind.
    if (blogs!.isEmpty) {
      return const Center(child: Text('No blogs yet.'));
    }

    // Verwendet ein Scaffold-Widget als Basislayout.
    return Scaffold(
      appBar: AppBar(title: const Text("Blog")), // AppBar mit dem Titel "Blog".
      body: ListView.builder(
        itemCount: blogs!.length, // Anzahl der Blog-Beiträge.
        itemBuilder: (context, index) {
          var blog = blogs![index];
          // Erstellt eine Karte für jeden Blog-Beitrag.
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: BlogWidget(blog: blog), // BlogWidget definiert unten.
          );
        },
      ),
    );
  }
}

// Definiert die Darstellung eines einzelnen Blog-Beitrags.
class BlogWidget extends StatelessWidget {
  const BlogWidget({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    // Verwendet MouseRegion, um den Mauszeiger zu ändern, wenn man über das Widget fährt.
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navigiert zur Detailseite des Blogs, wenn auf das Widget getippt wird.
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
                  blog.title, // Der Titel des Blogs.
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8.0), // Abstandshalter.
                Text(blog.content), // Der Inhalt des Blogs.
                const SizedBox(height: 8.0), // Weitere Abstandshalter.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      blog.publishedDateString, // Das Veröffentlichungsdatum des Blogs.
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons.favorite_border), // Icon für Like-Button.
                      onPressed: () {
                        // TODO: Logik zum Liken des Blogs einfügen.
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
