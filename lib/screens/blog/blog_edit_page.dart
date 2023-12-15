import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/services/blog_repository.dart';
import 'package:provider/provider.dart';

class BlogEditPage extends StatefulWidget {
  final Blog blog;
  const BlogEditPage({required this.blog, super.key});

  @override
  _BlogEditPageState createState() => _BlogEditPageState();
}

class _BlogEditPageState extends State<BlogEditPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog.title);
    _contentController = TextEditingController(text: widget.blog.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Blog"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: "Content",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some content";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateBlog,
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateBlog() async {
    if (!formKey.currentState!.validate()) return;

    final blogProvider = Provider.of<BlogProvider>(context, listen: false);
    final updatedBlog = Blog(
      id: widget.blog.id,
      title: _titleController.text,
      content: _contentController.text,
      publishedAt: DateTime.now(),
    );

    await BlogRepository.instance.updateBlogPost(
      blogId: widget.blog.id,
      title: _titleController.text,
      content: _contentController.text,
    );
    blogProvider.readBlogs();

    Navigator.of(context).pop();
  }
}
