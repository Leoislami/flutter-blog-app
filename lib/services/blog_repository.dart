import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter_blog_app/models/blog.dart';

class BlogRepository {
  static BlogRepository instance = BlogRepository._privateConstructor();
  BlogRepository._privateConstructor();

  final _blogs = <Blog>[];
  int _nextId = 1;
  bool _isInitialized = false;

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

  Future<List<Blog>> getBlogPosts() async {
    if (!_isInitialized) {
      _initializeBlogs();
    }

    await Future.delayed(const Duration(milliseconds: 500));
    return _blogs..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  Future<void> addBlogPost(Blog blog) async {
    blog.id = _nextId++;
    _blogs.add(blog);
  }

  Future<void> deleteBlogPost(Blog blog) async {
    _blogs.removeWhere((b) => b.id == blog.id);
  }

  Future<void> toggleLikeInfo(int blogId) async {
    // Verwenden Sie firstWhereOrNull aus dem collection-Paket
    final blog = _blogs.firstWhereOrNull((b) => b.id == blogId);

    if (blog != null) {
      blog.isLikedByMe = !blog.isLikedByMe;
    }
  }

  Future<void> updateBlogPost(
      {required int blogId, String? title, String? content}) async {
    final blogIndex = _blogs.indexWhere((b) => b.id == blogId);
    if (blogIndex != -1) {
      final blog = _blogs[blogIndex];
      if (title != null) blog.title = title;
      if (content != null) blog.content = content;
      blog.publishedAt = DateTime.now(); // Optional: Update the published date
    }
  }
}
