import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/custom_bottom_nav_controller.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/browse_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/home_tab_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/messages_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/sell_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/setting_screen.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final CustomBottomNavController c = Get.put(CustomBottomNavController());

  final pages = const [
    HomeTabScreen(),
    BrowseScreen(),
    SellScreen(),
    MessagesScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Web on desktop (wide screen) → web layout
    // Web on mobile (narrow) or native app → app layout
    final bool isWebDesktop = kIsWeb && screenWidth >= 600;

    return Scaffold(
      body: Column(
        children: [
          // Web header — only on web desktop
          if (isWebDesktop) const WebHeader(),

          // Page content
          Expanded(child: Obx(() => pages[c.index.value])),
        ],
      ),
      // Bottom navbar — only on app or web mobile (not web desktop)
      bottomNavigationBar: isWebDesktop ? null : CustomBottomNavBar(),
    );
  }
}
