// lib/screens/new_blog_screen.dart
import 'package:flutter/material.dart';

class NewBlogScreen extends StatelessWidget {
  const NewBlogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Blog'),
      ),
      body: const Center(
        child: Text('Form to create a new blog will go here'),
        // Fügen Sie hier Ihre Formularwidgets ein
      ),
    );
  }
}
