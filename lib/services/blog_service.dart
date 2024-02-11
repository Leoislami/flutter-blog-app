import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/services/blog_api.dart';

class BlogService {
  // Static instance + private Constructor for simple Singleton-approach
  static BlogService instance = BlogService._privateConstructor();
  BlogService._privateConstructor();

  Future<List<Blog>> getBlogs() async {
    return BlogApi.instance.getBlogs();
  }

  Future<void> addBlog(
      {required String title,
      required String content,
      String? headerImageUrl}) async {
    await BlogApi.instance.addBlog(
        title: title, content: content, headerImageUrl: headerImageUrl);
  }

  Future<void> toggleLikeInfo(BlogProvider blogProvider, Blog blog) async {
    final actualBlog = await BlogApi.instance.getBlog(blogId: blog.id);
    final actualUserLikes = actualBlog.userIdsWithLikes ?? [];

    if (actualUserLikes.contains(dummyAuthUsername)) {
      actualUserLikes.remove(dummyAuthUsername);
    } else {
      actualUserLikes.add(dummyAuthUsername);
    }
    await BlogApi.instance
        .patchBlog(blogId: blog.id, userIdsWithLikes: actualUserLikes);
    await blogProvider.readBlogsWithLoadingState();
  }

  Future<void> patchBlog(BlogProvider blogProvider,
      {required String blogId,
      String? title,
      String? content,
      String? headerImageUrl}) async {
    await BlogApi.instance.patchBlog(
      blogId: blogId,
      title: title,
      content: content,
      headerImageUrl: headerImageUrl,
    );
    await blogProvider.readBlogsWithLoadingState();
  }

  Future<void> deleteBlog(BlogProvider blogProvider, String blogId) async {
    await BlogApi.instance.deleteBlog(blogId: blogId);
    await blogProvider.readBlogsWithLoadingState();
  }
}
