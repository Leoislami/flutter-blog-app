import 'package:flutter/material.dart';

// Definiert den Zustand für die Seite, auf der ein neuer Blog erstellt werden kann.
class BlogNewPage extends StatefulWidget {
  const BlogNewPage({super.key});

  @override
  State<BlogNewPage> createState() => _BlogNewPageState();
}

class _BlogNewPageState extends State<BlogNewPage> {
  // Controller für die Texteingabe des Blogtitels.
  final TextEditingController _titleController = TextEditingController();
  // Controller für die Texteingabe des Bloginhalts.
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Scaffold stellt die Grundstruktur der Seite bereit.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Blog'), // Titel der AppBar.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding für den Inhalt.
        child: Column(
          children: [
            // Eingabefeld für den Titel des neuen Blogs.
            TextField(
              controller: _titleController, // Verwendet den _titleController.
              decoration: const InputDecoration(
                labelText: 'Blog Title', // Label über dem Eingabefeld.
                border: OutlineInputBorder(), // Umrandung des Eingabefelds.
              ),
            ),
            const SizedBox(height: 16), // Abstand zwischen den Eingabefeldern.
            // Eingabefeld für den Inhalt des neuen Blogs.
            TextField(
              controller:
                  _contentController, // Verwendet den _contentController.
              decoration: const InputDecoration(
                labelText: 'Blog Content', // Label über dem Eingabefeld.
                border: OutlineInputBorder(), // Umrandung des Eingabefelds.
              ),
              maxLines: null, // Erlaubt mehrzeilige Eingabe.
              keyboardType:
                  TextInputType.multiline, // Tastatur für mehrzeiligen Text.
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Hier würde die Logik zum Speichern des neuen Blogs stehen.
          // Zum Beispiel könnten Sie den Blog zu einer Liste hinzufügen oder in einer Datenbank speichern.
          // Derzeit nur ein Platzhalter, der den Titel und Inhalt in der Konsole ausgibt.
          print('Saving new blog with title: ${_titleController.text}');
          print('Content: ${_contentController.text}');
        },
        child: const Icon(Icons.save), // Icon des Buttons.
      ),
    );
  }
}






// import 'package:flutter/material.dart';

// class BlogNewPage extends StatefulWidget {
//   const BlogNewPage({super.key});

//   @override
//   State<BlogNewPage> createState() => _BlogNewPageState();
// }

// class _BlogNewPageState extends State<BlogNewPage> {
//   @override
//   Widget build(BuildContext context) {
//     // Scaffold mit AppBar und einem leeren Platzhalter für den Inhalt.
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create New Blog'), // Titel für die neue Blog-Seite.
//       ),
//       // Hier könnte der Inhalt für das Erstellen eines neuen Blogs eingefügt werden.
//       body: const Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Widgets für die Eingabe des neuen Blogs (z.B. Textfelder).
//             // ...
//           ],
//         ),
//       ),
//       // Floating Action Button zum Speichern des neuen Blogs.
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Logik zum Speichern des neuen Blogs einfügen.
//         },
//         child: const Icon(Icons.save),
//       ),
//     );
//   }
// }
