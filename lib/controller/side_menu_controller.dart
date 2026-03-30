import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/custom_bottom_nav_controller.dart';
import 'package:guyana_center_frontend/screens/message_screen.dart';
import 'package:guyana_center_frontend/screens/all_category_screen.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';

class SideMenuController extends GetxController {
  final menuItems = <String>[
    'Home',
    'Browse Listings',
    'Categories',
    'Messages',
    'About',
    'Contact',
  ];

  final selectedIndex = 0.obs;

  void selectMenu(int index) {
    selectedIndex.value = index;
    
    // Attempt to close side menu
    Get.back();
    
    // If CustomBottomNavController is active, we can navigate tabs
    if (Get.isRegistered<CustomBottomNavController>()) {
      final bottomNav = Get.find<CustomBottomNavController>();
      if (index == 0) {
        bottomNav.goToTab(0); // HomeTabScreen
      } else if (index == 1) {
        bottomNav.goToTab(1); // BrowseScreen
      } else if (index == 2) {
        // Categories - Navigate to All Categories screen
        final categories = <BrowseCategoryVM>[
          const BrowseCategoryVM(id: "vehicles", title: "Vehicles", subtitle: "Cars, trucks, motorcycles & more", tint: Color(0xFFFFF2E8), assetImage: "assets/vehicle.png"),
          const BrowseCategoryVM(id: "real_estate", title: "Real Estate", subtitle: "Properties for sale & rent", tint: Color(0xFFFFF0F0), assetImage: "assets/realestate.png"),
          const BrowseCategoryVM(id: "jobs", title: "Jobs", subtitle: "Full-time, part-time & freelance work", tint: Color(0xFFFFF8E8), assetImage: "assets/jobs.png"),
          const BrowseCategoryVM(id: "electronics", title: "Electronics", subtitle: "Phones, laptops, gadgets & tech", tint: Color(0xFFEFF5FF), assetImage: "assets/electronics.png"),
          const BrowseCategoryVM(id: "fashion", title: "Fashion", subtitle: "Clothing, shoes & accessories", tint: Color(0xFFFFF1F8), assetImage: "assets/fashion.png"),
          const BrowseCategoryVM(id: "home_garden", title: "Home & Garden", subtitle: "Furniture, decor & garden supplies", tint: Color(0xFFF0FFF7), assetImage: "assets/home&gardan.png"),
          const BrowseCategoryVM(id: "sports_hobbies", title: "Sports & Hobbies", subtitle: "Sports gear, instruments & crafts", tint: Color(0xFFFFF6E8), assetImage: "assets/sports&hobbies.png"),
          const BrowseCategoryVM(id: "kids", title: "Kids' Stuff", subtitle: "Toys, clothing & baby essentials", tint: Color(0xFFEFF8FF), assetImage: "assets/kids.png"),
          const BrowseCategoryVM(id: "pets", title: "Pets & Animals", subtitle: "Pets, accessories & pet services", tint: Color(0xFFFFF2E8), assetImage: "assets/pet&animals.png"),
          const BrowseCategoryVM(id: "health_beauty", title: "Health & Beauty", subtitle: "Skincare, supplements & wellness", tint: Color(0xFFF4F1FF), assetImage: "assets/health&beauty.png"),
          const BrowseCategoryVM(id: "services", title: "Services", subtitle: "Auto repair, cleaning & more", tint: Color(0xFFEFF5FF), assetImage: "assets/service.png"),
          const BrowseCategoryVM(id: "business", title: "Business", subtitle: "Office equipment & commercial", tint: Color(0xFFF0FFF7), assetImage: "assets/bussiness.png"),
        ];
        Get.to(() => AllCategoryScreen(categories: categories));
      } else if (index == 3) {
        Get.to(() => const MessagesScreen());
      }
      // For Pricing, About, Contact -> Add actual navigation here later
    }
  }

  void onLoginTap() {
    Get.toNamed('/login');
  }

  void onCreateAdTap() {
    if (!AuthService.to.isLoggedIn.value) {
      AuthService.to.showLoginPrompt();
    } else {
      Get.back(); // close menu
      if (Get.isRegistered<CustomBottomNavController>()) {
        final bottomNav = Get.find<CustomBottomNavController>();
        bottomNav.goToTab(2); // SellScreen
      }
    }
  }

  void onSignInTap() {
    Get.toNamed('/login');
  }
}
