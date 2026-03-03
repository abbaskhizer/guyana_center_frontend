import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Text(
              "Menu",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            SizedBox(height: 10),
            ListTile(leading: Icon(Icons.home_outlined), title: Text("Home")),
            ListTile(
              leading: Icon(Icons.category_outlined),
              title: Text("Categories"),
            ),
            ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text("Favorites"),
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text("Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
