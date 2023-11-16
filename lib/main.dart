import 'package:flutter/material.dart';
import 'package:flutter_blog_app/screens/create_blog_post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/blog_post.dart';

Future<List<BlogPost>> fetchBlogPosts() async {
  final response = await http.get(Uri.parse(
      'https://d-cap-blog-backend.whitepond-b96fee4b.westeurope.azurecontainerapps.io//entries'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => BlogPost.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load blog posts');
  }
}

void main() {
  runApp(const BlogApp());
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BlogHomePage(),
    );
  }
}

class BlogHomePage extends StatefulWidget {
  const BlogHomePage({super.key});

  @override
  _BlogHomePageState createState() => _BlogHomePageState();
}

class _BlogHomePageState extends State<BlogHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blog App')),
      body: FutureBuilder<List<BlogPost>>(
        future: fetchBlogPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                BlogPost post = snapshot.data![index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.content),
                );
              },
            );
          } else {
            return Center(child: Text('No posts found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateBlogPostPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Create Blog',
      ),
    );
  }
}
