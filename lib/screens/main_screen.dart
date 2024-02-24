import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/screens/blog/blog_new_page.dart';
import 'package:flutter_blog_app/screens/home_page.dart';
import 'package:flutter_blog_app/screens/login_page.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

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
    final authProvider = Provider.of<MyAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(selectedMenuItem.text),
            const Spacer(),
            if (authProvider.user != null && authProvider.user?.photoURL != null)
              PopupMenuButton(
                offset: Offset(0, 50), // Adjust the vertical offset as needed
                icon: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(authProvider.user!.photoURL!),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                },
              ),
            if (authProvider.user == null || authProvider.user?.photoURL == null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Icon(Icons.login),
              ),
          ],
        ),
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
