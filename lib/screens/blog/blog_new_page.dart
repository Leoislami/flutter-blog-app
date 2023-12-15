import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/services/blog_repository.dart';
import 'package:provider/provider.dart';

/// BlogNewPage ermöglicht das Erstellen neuer Blog-Beiträge.
class BlogNewPage extends StatefulWidget {
  const BlogNewPage({super.key});

  @override
  State<BlogNewPage> createState() => _BlogNewPageState();
}

/// Verschiedene Zustände, die die Seite während des Erstellungsprozesses haben kann.
enum _PageStates { loading, editing, done }

class _BlogNewPageState extends State<BlogNewPage> {
  final formKey = GlobalKey<FormState>();
  var pageState = _PageStates.editing;
  var title = "";
  var content = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Blog"),
      ),
      body: Builder(builder: (context) {
        switch (pageState) {
          case _PageStates.loading:
            // Anzeigen eines Ladeindikators während der Blog erstellt wird.
            return const Center(child: CircularProgressIndicator());
          case _PageStates.done:
            // Anzeigen einer Bestätigungsnachricht nach erfolgreicher Erstellung.
            return Center(child: Text("Blog '$title' created!"));
          case _PageStates.editing:
            // Formular zum Erstellen eines neuen Blogs.
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    // Textfeld für den Titel des Blogs.
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return "Please enter title with 4 or more characters";
                        }
                        return null;
                      },
                      onSaved: (value) => title = value!,
                    ),
                    const SizedBox(height: 20),
                    // Textfeld für den Inhalt des Blogs.
                    TextFormField(
                      maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: "Content",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 10) {
                          return "Please enter content with 10 or more characters";
                        }
                        return null;
                      },
                      onSaved: (value) => content = value!,
                    ),
                    const SizedBox(height: 20),
                    // Button zum Speichern des neuen Blogs.
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            pageState = _PageStates.loading;
                          });
                          formKey.currentState!.save();
                          await _createBlog();
                          setState(() {
                            pageState = _PageStates.done;
                          });
                        }
                      },
                      child: const Text("Save"),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            );
        }
      }),
    );
  }

  /// Funktion zum Erstellen eines neuen Blog-Beitrags.
  Future<void> _createBlog() async {
    var blogProvider = context.read<BlogProvider>();
    await Future.delayed(
        const Duration(seconds: 1)); // Simuliert eine Netzwerkverzögerung.
    await BlogRepository.instance.addBlogPost(Blog(
      title: title,
      content: content,
      publishedAt: DateTime.now(),
    ));
    blogProvider.readBlogs(); // Aktualisiert die Blog-Liste im BlogProvider.
  }
}

// BlogForm ist ein nicht implementiertes Widget, das in zukünftigen Versionen verwendet werden könnte.
class BlogForm extends StatefulWidget {
  const BlogForm({super.key});

  @override
  State<BlogForm> createState() => _BlogFormState();
}

class _BlogFormState extends State<BlogForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
