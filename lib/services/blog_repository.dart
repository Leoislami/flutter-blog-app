import 'package:flutter_blog_app/models/blog.dart';

class BlogRepository {
  Future<List<Blog>> getBlogPosts() async {
    // Simulieren der asynchronen Aufbereitung der Blog-Einträge
    await Future.delayed(const Duration(seconds: 2));

    List<Blog> blogPosts = [
      Blog(
        title: "Flutter ist toll!",
        content:
            "Mit Flutter hebst du deine App-Entwicklung auf ein neues Level. Probier es aus!",
        publishedAt: DateTime.now(),
      ),
      Blog(
        title: "Der Kurs ist dabei abzuheben",
        content:
            "Fasten your seatbelts, we are ready for takeoff! 🚀 Jetzt geht's ans Eingemachte. Bleib dabei!",
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Blog(
        title: "Klasse erzeugt eine super App",
        content:
            "Während dem aktiven Plenum hat die Klasse alles rausgeholt und eine tolle App gebaut. Alle waren begeistert dabei und haben viel gelernt.",
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    return blogPosts;
  }
}
