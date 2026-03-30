import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/custom_bottom_nav_controller.dart';

import 'package:guyana_center_frontend/screens/bottomNavbar/browse_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/home_tab_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/favorites_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/sell_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/setting_screen.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // ✅ SINGLE instance
  final CustomBottomNavController c = Get.put(
    CustomBottomNavController(),
    permanent: true,
  );

  final pages = const [
    HomeTabScreen(),
    BrowseScreen(),
    SellScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWebDesktop = kIsWeb && screenWidth >= 600;

    return Scaffold(
      body: Column(
        children: [
          if (isWebDesktop) const WebHeader(),

          Expanded(
            child: Obx(
              () => IndexedStack(index: c.index.value, children: pages),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWebDesktop ? null : CustomBottomNavBar(),
    );
  }
}
