import 'package:flutter/material.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_blog_app/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => MyAuthProvider(),
      child: const MainApp(),
    ),
  );
}

final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlogProvider(),
      child: MaterialApp(
        navigatorKey: mainNavigatorKey,
        title: 'Flutter Blog App',
        theme: ThemeData.dark().copyWith(
          // Aktiviert den Dark Mode mit Anpassungen
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            color: Colors.black, // Farbe der AppBar im Dark Mode
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}
