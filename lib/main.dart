import 'package:flutter/material.dart';
import 'package:flutter_blog_app/screens/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definiert die globale Theme-Konfiguration der App.
    return MaterialApp(
      title: 'Flutter Blog App', // Der Titel der App.
      theme: ThemeData
          .dark(), // Aktiviert den Dark Mode mit einem vordefinierten Dark Theme.
      home: const MainScreen(), // Setzt MainScreen als Startseite der App.
    );
  }
}
