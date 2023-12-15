import 'package:flutter/material.dart';
import 'package:flutter_blog_app/screens/blog/blog_new_page.dart';
import 'package:flutter_blog_app/screens/home_page.dart';

/// Klasse für Menüelemente, die in der Hauptnavigation verwendet werden.
class MainMenuItem {
  // Liste aller Menüelemente.
  static final List<MainMenuItem> items = _getMenuItems();

  final IconData icon;
  final String text;
  final Widget page;
  final GlobalKey<NavigatorState> navigatorKey;

  // Konstruktor für MainMenuItem.
  MainMenuItem({required this.icon, required this.text, required this.page})
      : navigatorKey = GlobalKey<NavigatorState>();
}

// Erstellt und gibt die Liste der Menüelemente zurück.
List<MainMenuItem> _getMenuItems() => [
      MainMenuItem(icon: Icons.home, text: "Home", page: const HomePage()),
      MainMenuItem(
          icon: Icons.add, text: "New Blog", page: const BlogNewPage()),
    ];

/// MainScreen ist der Hauptbildschirm der App, der die Navigation verwaltet.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0; // Index des aktuell ausgewählten Menüelements.

  @override
  Widget build(BuildContext context) {
    final selectedMenuItem = MainMenuItem.items[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title:
            Text(selectedMenuItem.text), // Titel des ausgewählten Menüelements.
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () =>
                  Scaffold.of(context).openDrawer(), // Öffnet den Drawer.
            );
          },
        ),
      ),
      drawer: Drawer(
        // Drawer-Menü mit allen Menüelementen.
        child: ListView(
          padding: EdgeInsets.zero,
          children: MainMenuItem.items.map((item) {
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.text),
              onTap: () {
                setState(() {
                  selectedIndex = MainMenuItem.items
                      .indexOf(item); // Aktualisiert den ausgewählten Index.
                  Navigator.of(context).pop(); // Schließt den Drawer.
                });
              },
            );
          }).toList(),
        ),
      ),
      body: Navigator(
        key: selectedMenuItem.navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) =>
                selectedMenuItem.page), // Navigiert zur ausgewählten Seite.
      ),
    );
  }
}
