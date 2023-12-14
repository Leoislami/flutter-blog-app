import 'package:flutter/material.dart';
import 'package:flutter_blog_app/screens/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blueGrey, scaffoldBackgroundColor: Colors.grey),
      // darkTheme: ThemeData.dark(),
      home: const Home(),
    );
  }
}
