import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/services/blog_service.dart';
import 'package:flutter_blog_app/services/blog_api.dart';

/// BlogProvider ist verantwortlich für die Verwaltung des Zustands der Blog-Liste.
/// Es verwendet ChangeNotifier, um Änderungen an den Konsumenten zu melden.
class BlogProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Blog> _blogs = [];

  // Getter, um auf die private Blog-Liste von außen zuzugreifen.
  List<Blog> get blogs => _blogs;

  // Konstruktor initialisiert den Timer und liest die Blogs beim Start.
  BlogProvider() {
    _startRefreshTimer();
    readBlogsWithLoadingState();
  }

  /// Startet einen Timer, der die Blog-Liste jede Minute aktualisiert.
  void _startRefreshTimer() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      readBlogs();
    });
  }

  /// Liest die Blogs und setzt den Ladezustand während des Lesevorgangs.
  /// Dies wird verwendet, um Ladeindikatoren in der Benutzeroberfläche anzuzeigen.
  Future<void> readBlogsWithLoadingState() async {
    isLoading = true;
    notifyListeners();

    await readBlogs(withNotifying: false);

    isLoading = false;
    notifyListeners();
  }

  /// Liest die Blogs vom BlogRepository.
  /// Die Option withNotifying steuert, ob die Listener nach dem Lesen benachrichtigt werden sollen.
  Future<void> readBlogs({bool withNotifying = true}) async {
    _blogs = await BlogService.instance.getBlogs();
    if (withNotifying) {
      notifyListeners();
    }
  }

  Future<void> addBlog(String title, String content,
      {String? headerImageUrl}) async {
    isLoading = true;
    notifyListeners();
    await BlogService.instance.addBlog(
        title: title, content: content, headerImageUrl: headerImageUrl);
    await readBlogsWithLoadingState();
  }

  Future<void> updateBlog(String blogId, String title, String content) async {
    isLoading = true;
    notifyListeners();

    await BlogService.instance.patchBlog(
      blogId: blogId,
      title: title,
      content: content,
    );

    await readBlogsWithLoadingState();
  }

  Future<void> deleteBlog(String blogId) async {
    isLoading = true;
    notifyListeners();

    await BlogService.instance.deleteBlog(blogId: blogId);

    await readBlogsWithLoadingState();
  }

  Future<void> toggleBlogLike(String blogId, String userId) async {
    await BlogApi.instance.toggleBlogLike(blogId, userId);
    await readBlogsWithLoadingState(); // Liest die Blogs erneut, um die UI zu aktualisieren
  }
}
