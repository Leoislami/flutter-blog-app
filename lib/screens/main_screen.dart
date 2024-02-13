import 'package:flutter/material.dart';
import 'package:flutter_blog_app/screens/blog/blog_new_page.dart';
import 'package:flutter_blog_app/screens/home_page.dart';
import 'package:flutter_blog_app/screens/login_page.dart';

class MainMenuItem {
  static final List<MainMenuItem> items = _getMenuItems();

  final IconData icon;
  final String text;
  final Widget page;
  final GlobalKey<NavigatorState> navigatorKey;

  MainMenuItem({required this.icon, required this.text, required this.page})
      : navigatorKey = GlobalKey<NavigatorState>();
}

List<MainMenuItem> _getMenuItems() => [
      MainMenuItem(icon: Icons.home, text: "Home", page: const HomePage()),
      MainMenuItem(icon: Icons.home, text: "Login", page: LoginPage()),
      MainMenuItem(
          icon: Icons.add, text: "New Blog", page: const BlogNewPage()),
    ];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedMenuItem = MainMenuItem.items[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMenuItem.text),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: Drawer(
        // Hamburger-Menü mit Navigationselementen
        child: ListView(
          padding: EdgeInsets.zero,
          children: MainMenuItem.items.map((item) {
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.text),
              onTap: () {
                setState(() {
                  selectedIndex = MainMenuItem.items.indexOf(item);
                  Navigator.of(context).pop(); // Schließt das Drawer-Menü
                });
              },
            );
          }).toList(),
        ),
      ),
      body: Navigator(
        key: selectedMenuItem.navigatorKey,
        onGenerateRoute: (settings) =>
            MaterialPageRoute(builder: (context) => selectedMenuItem.page),
      ),
    );
  }
}
