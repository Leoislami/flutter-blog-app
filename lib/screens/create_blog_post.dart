import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateBlogPostPage extends StatefulWidget {
  @override
  _CreateBlogPostPageState createState() => _CreateBlogPostPageState();
}

class _CreateBlogPostPageState extends State<CreateBlogPostPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  Future<void> createBlogPost(String title, String content) async {
    final response = await http.post(
      Uri.parse(
          'https://d-cap-blog-backend.whitepond-b96fee4b.westeurope.azurecontainerapps.io//entries'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.of(context).pop(); // Zurück zur Hauptseite
    } else {
      // Fehlerbehandlung
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Blog Post')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Content'),
                onSaved: (value) {
                  _content = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    createBlogPost(_title, _content);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
