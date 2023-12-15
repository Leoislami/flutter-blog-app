import 'package:flutter/material.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/screens/main_screen.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MainApp());
// }

// final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var colorScheme = ColorScheme.fromSeed(
//       seedColor: Colors.cyanAccent,
//     );
//     return ChangeNotifierProvider(
//       create: (_) => BlogProvider(),
//       child: MaterialApp(
//         navigatorKey: mainNavigatorKey,
//         title: "Interaction and State",
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: colorScheme,
//           scaffoldBackgroundColor: colorScheme.surfaceVariant,
//           appBarTheme: AppBarTheme(
//             backgroundColor: colorScheme.surfaceVariant,
//           ),
//           textTheme: const TextTheme(
//             titleLarge: TextStyle(
//               fontSize: 30,
//             ),
//           ),
//         ),
//         home: const MainScreen(),
//       ),
//     );
//   }
// }

void main() {
  runApp(const MainApp());
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
