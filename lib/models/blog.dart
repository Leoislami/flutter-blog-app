import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  String id;
  String authorId;
  String title;
  String content;
  DateTime publishedAt;
  List<String> likedBy;

  Blog({
    this.id = '',
    required this.authorId,
    required this.title,
    required this.content,
    required this.publishedAt,
    this.likedBy = const [],
  });

  String get publishedDateString =>
      "${publishedAt.day}.${publishedAt.month}.${publishedAt.year}";

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'title': title,
      'content': content,
      'publishedAt': publishedAt,
      'likedBy': likedBy,
    };
  }

  factory Blog.fromJson(Map<String, dynamic> map, String id) {
    return Blog(
      id: id,
      authorId: map['authorId']! as String,
      title: map['title']! as String,
      content: map['content']! as String,
      publishedAt: (map['publishedAt'] as Timestamp).toDate(),
      likedBy: (map['likedBy']! as List).cast<String>(),
    );
  }
}
