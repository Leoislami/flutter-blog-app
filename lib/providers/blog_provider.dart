import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/services/blog_repository.dart';

class BlogProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Blog> _blogs = [];

  List<Blog> get blogs => _blogs;

  BlogProvider() {
    _startRefreshTimer();
    readBlogsWithLoadingState();
  }

  /// Refresh every Minute
  void _startRefreshTimer() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      readBlogs();
    });
  }

  Future<void> readBlogsWithLoadingState() async {
    isLoading = true;
    notifyListeners();

    await readBlogs(withNotifying: false);

    isLoading = false;
    notifyListeners();
  }

  Future<void> readBlogs({bool withNotifying = true}) async {
    _blogs = await BlogRepository.instance.getBlogPosts();
    if (withNotifying) {
      notifyListeners();
    }
  }
}
