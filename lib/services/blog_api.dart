import 'dart:async';
import 'package:flutter_blog_app/models/blog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogApi {
  // Static instance + private Constructor for simple Singleton-approach
  static BlogApi instance = BlogApi._privateConstructor();
  BlogApi._privateConstructor();

  static const String _baseUrl = "cloud.appwrite.io";
  static const String _dbPath = "/v1/databases/blog-db/collections";
  static const String _appWriteProjectId = "6568509f75ac404ff6ae";
  static const String _appWriteApiKey =
      "ac0f362d0cf82fe3d138195e142c0a87a88cee4e2c48821192fb307e1a1c74ee694246f90082b4441aa98a2edaddead28ed6d18cf08c4de0df90dcaeeb53d14f14fb9eeb2edec6708c9553434f1d8df8f8acbfbefd35cccb70f2ab0f9a334dfd979b6052f6e8b8610d57465cbe8d71a7f65e8d48aede789eef6b976b1fe9b2e2";

  static const String _blogCollectionId = "$_dbPath/blogs/documents";
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Appwrite-Project': _appWriteProjectId,
    'X-Appwrite-key': _appWriteApiKey,
  };

  Future<List<Blog>> getBlogs() async {
    const Map<String, String> query = {
      "queries[0]": "orderDesc('\$createdAt')",
      "queries[1]": "limit(1000)",
    };
    try {
      final response = await http.get(
        Uri.https(_baseUrl, _blogCollectionId, query),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> blogsJson = jsonDecode(response.body)["documents"];
        var blogs = blogsJson.map((json) => Blog.fromJson(json)).toList();
        return blogs;
      } else {
        throw Exception(
            'Failed to load blogs. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load blogs');
    }
  }

  Future<Blog> getBlog({required String blogId}) async {
    try {
      final response = await http.get(
        Uri.https(_baseUrl, "$_blogCollectionId/$blogId"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> blogJson = jsonDecode(response.body);
        return Blog.fromJson(blogJson);
      } else {
        throw Exception(
            'Failed to load blog. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load blog');
    }
  }

  Future<void> addBlog(
      {required String title,
      required String content,
      String? headerImageUrl}) async {
    try {
      final response = await http.post(
        Uri.https(_baseUrl, _blogCollectionId),
        headers: _headers,
        body: jsonEncode({
          "documentId": "unique()",
          "data": {
            "title": title,
            "content": content,
            "headerImageUrl": headerImageUrl,
          }
        }),
      );
      if (response.statusCode != 201) {
        throw Exception(
            'Failed to create blog. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create blog');
    }
  }

  Future<void> patchBlog(
      {required String blogId,
      String? title,
      String? content,
      String? headerImageUrl,
      List<String>? userIdsWithLikes}) async {
    var patchBody = {
      "document": blogId,
      "data": {
        if (title != null) "title": title,
        if (content != null) "content": content,
        if (headerImageUrl != null) "headerImageUrl": headerImageUrl,
        if (userIdsWithLikes != null) "userIdsWithLikes": userIdsWithLikes,
      }
    };
    try {
      final response = await http.patch(
        Uri.https(_baseUrl, "$_blogCollectionId/$blogId"),
        headers: _headers,
        body: jsonEncode(patchBody),
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update blog. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update blog');
    }
  }

  Future<void> deleteBlog({required String blogId}) async {
    try {
      final response = await http.delete(
        Uri.https(_baseUrl, "$_blogCollectionId/$blogId"),
        headers: _headers,
      );
      if (response.statusCode != 204) {
        throw Exception(
            'Failed to delete blog. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete blog');
    }
  }

  Future<void> toggleBlogLike(String blogId, String userId) async {
    final Uri uri = Uri.https(_baseUrl, '/path/to/like/toggle/endpoint');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({
        "blogId": blogId,
        "userId": userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle like');
    }
  }
}
