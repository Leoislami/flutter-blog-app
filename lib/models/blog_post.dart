class BlogPost {
  final int id;
  final String title;
  final String content;

  BlogPost({required this.id, required this.title, required this.content});

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String? ??
          'No Content', // Standardwert, falls null
    );
  }
}
