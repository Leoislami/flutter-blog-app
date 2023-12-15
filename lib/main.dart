import 'package:flutter/material.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

// GlobalKey wird verwendet, um auf den NavigatorState außerhalb des Baumes zuzugreifen.
final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

/// MainApp ist die Hauptklasse, die die Anwendung initialisiert und einrichtet.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ein ChangeNotifierProvider wird verwendet, um den Zustand der Blogs in der gesamten App zu verwalten.
    return ChangeNotifierProvider(
      create: (_) => BlogProvider(),
      child: MaterialApp(
        navigatorKey:
            mainNavigatorKey, // Globaler Navigator-Schlüssel für die Navigation.
        title: 'Flutter Blog App', // Titel der Anwendung.
        theme: ThemeData.dark().copyWith(
          // Verwendung des dunklen Themes mit Anpassungen.
          useMaterial3: true, // Aktiviert Material Design 3-Stil.
          appBarTheme: const AppBarTheme(
            color: Colors.black, // Setzt die Farbe der AppBar im Dark Mode.
          ),
        ),
        home:
            const MainScreen(), // Setzt MainScreen als Startbildschirm der App.
      ),
    );
  }
}
