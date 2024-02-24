import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blog_app/models/blog.dart';

class BlogRepository {
  static BlogRepository instance = BlogRepository._privateConstructor();
  BlogRepository._privateConstructor();

  final CollectionReference<Blog> _blogCollection =
  FirebaseFirestore.instance.collection('blogs').withConverter<Blog>(
    fromFirestore: (snapshots, _) => Blog.fromJson(snapshots.data()!, snapshots.id),
    toFirestore: (blog, _) => blog.toJson(),
  );

  Future<List<Blog>> getBlogPosts() async {
    QuerySnapshot<Blog> snapshot = await _blogCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  Future<void> addBlogPost(Blog blog) async {
    await _blogCollection.add(blog);
  }

  Future<void> deleteBlogPost(String blogId) async {
    await _blogCollection.doc(blogId).delete();
  }

  Future<void> toggleLikeInfo(String userId, String blogId) async {
    DocumentSnapshot<Blog> doc = await _blogCollection.doc(blogId).get();
    if (doc.exists) {
      Blog blog = doc.data()!;
      blog.likedBy = List.from(blog.likedBy);

      if (blog.likedBy.contains(userId)) {
        blog.likedBy.remove(userId);
      } else {
        blog.likedBy.add(userId);
      }
      await _blogCollection.doc(blogId).set(blog);
    }
  }

  Future<void> updateBlogPost(
      {required String blogId, String? title, String? content}) async {
    final blog = _blogCollection.doc(blogId);
    if (title != null) await blog.update({'title': title});
    if (content != null) await blog.update({'content': content});
  }
}
