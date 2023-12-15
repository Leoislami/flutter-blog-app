import 'dart:async';
import 'package:flutter_blog_app/models/blog.dart';

/// BlogRepository ist für die Verwaltung der Blog-Daten zuständig.
/// Es verwendet ein Singleton-Muster, um eine einzige Instanz über die App hinweg zu gewährleisten.
class BlogRepository {
  // Statische Instanz für das Singleton-Muster.
  static BlogRepository instance = BlogRepository._privateConstructor();
  BlogRepository._privateConstructor();

  // Privates Array, das alle Blog-Objekte speichert.
  final _blogs = <Blog>[];
  int _nextId = 1; // Nächste ID für neue Blog-Beiträge.
  bool _isInitialized = false; // Flag zur Überprüfung der Initialisierung.

  /// Initialisiert das Repository mit einigen Beispieldaten.
  void _initializeBlogs() {
    addBlogPost(Blog(
      title: "Flutter ist toll!",
      content:
          "Mit Flutter hebst du deine App-Entwicklung auf ein neues Level. Probier es aus!",
      publishedAt: DateTime.now(),
    ));

    addBlogPost(Blog(
      title: "Der Kurs ist dabei abzuheben",
      content:
          "Fasten your seatbelts, we are ready for takeoff! 🚀 Jetzt geht's ans Eingemachte. Bleib dabei!",
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ));

    addBlogPost(Blog(
      title: "Klasse erzeugt eine super App",
      content:
          "Während dem aktiven Plenum hat die Klasse alles rausgeholt und eine tolle App gebaut. Alle waren begeistert dabei und haben viel gelernt.",
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    ));

    _isInitialized = true;
  }

  /// Gibt alle Blog-Beiträge sortiert nach Veröffentlichungsdatum zurück.
  /// Simuliert eine Netzwerkverzögerung.
  Future<List<Blog>> getBlogPosts() async {
    if (!_isInitialized) {
      _initializeBlogs();
    }

    await Future.delayed(const Duration(milliseconds: 500));
    return _blogs..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  /// Erstellt einen neuen Blog-Beitrag und weist ihm eine neue ID zu.
  Future<void> addBlogPost(Blog blog) async {
    blog.id = _nextId++;
    _blogs.add(blog);
  }

  /// Löscht einen Blog-Beitrag.
  Future<void> deleteBlogPost(Blog blog) async {
    _blogs.remove(blog);
  }

  /// Ändert den Like-Status eines Blog-Beitrags.
  Future<void> toggleLikeInfo(int blogId) async {
    final blog = _blogs.firstWhere((blog) => blog.id == blogId);
    blog.isLikedByMe = !blog.isLikedByMe;
  }

  /// Aktualisiert einen Blog-Beitrag mit der gegebenen ID.
  Future<void> updateBlogPost(
      {required int blogId, String? title, String? content}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final blog = _blogs.firstWhere((blog) => blog.id == blogId);
    if (title != null) {
      blog.title = title;
    }
    if (content != null) {
      blog.content = content;
    }
  }
}
