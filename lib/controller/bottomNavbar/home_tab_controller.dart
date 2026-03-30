import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';

import 'package:guyana_center_frontend/screens/all_category_screen.dart';
import 'package:guyana_center_frontend/screens/browse_listing_screen.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/browse_controller.dart';
import 'package:guyana_center_frontend/controller/custom_bottom_nav_controller.dart';

class HomeTabController extends GetxController {
  final selectedCategoryIndex = 0.obs;

  final categories = <BrowseCategoryVM>[
    const BrowseCategoryVM(
      id: "all",
      title: "All",
      subtitle: "Browse all categories",
      tint: Color(0xFFEFF5FF),
      icon: Icons.apps,
    ),
    const BrowseCategoryVM(
      id: "vehicles",
      title: "Vehicles",
      subtitle: "Cars, trucks, motorcycles & more",
      tint: Color(0xFFFFF2E8),
      assetImage: "assets/vehicle.png",
    ),
    const BrowseCategoryVM(
      id: "real_estate",
      title: "Real Estate",
      subtitle: "Properties for sale & rent",
      tint: Color(0xFFFFF0F0),
      assetImage: "assets/realestate.png",
    ),
    const BrowseCategoryVM(
      id: "jobs",
      title: "Jobs",
      subtitle: "Full-time, part-time & freelance work",
      tint: Color(0xFFFFF8E8),
      assetImage: "assets/jobs.png",
    ),
    const BrowseCategoryVM(
      id: "electronics",
      title: "Electronics",
      subtitle: "Phones, laptops, gadgets & tech",
      tint: Color(0xFFEFF5FF),
      assetImage: "assets/electronics.png",
    ),
    const BrowseCategoryVM(
      id: "fashion",
      title: "Fashion",
      subtitle: "Clothing, shoes & accessories",
      tint: Color(0xFFFFF1F8),
      assetImage: "assets/fashion.png",
    ),
    const BrowseCategoryVM(
      id: "home_garden",
      title: "Home & Garden",
      subtitle: "Furniture, decor & garden supplies",
      tint: Color(0xFFF0FFF7),
      assetImage: "assets/home&gardan.png",
    ),
    const BrowseCategoryVM(
      id: "sports_hobbies",
      title: "Sports & Hobbies",
      subtitle: "Sports gear, instruments & crafts",
      tint: Color(0xFFFFF6E8),
      assetImage: "assets/sports&hobbies.png",
    ),
    const BrowseCategoryVM(
      id: "kids",
      title: "Kids' Stuff",
      subtitle: "Toys, clothing & baby essentials",
      tint: Color(0xFFEFF8FF),
      assetImage: "assets/kids.png",
    ),
    const BrowseCategoryVM(
      id: "pets",
      title: "Pets & Animals",
      subtitle: "Pets, accessories & pet services",
      tint: Color(0xFFFFF2E8),
      assetImage: "assets/pet&animals.png",
    ),
    const BrowseCategoryVM(
      id: "health_beauty",
      title: "Health & Beauty",
      subtitle: "Skincare, supplements & wellness",
      tint: Color(0xFFF4F1FF),
      assetImage: "assets/health&beauty.png",
    ),
    const BrowseCategoryVM(
      id: "services",
      title: "Services",
      subtitle: "Auto repair, cleaning & more",
      tint: Color(0xFFEFF5FF),
      assetImage: "assets/service.png",
    ),
    const BrowseCategoryVM(
      id: "business",
      title: "Business",
      subtitle: "Office equipment & commercial",
      tint: Color(0xFFF0FFF7),
      assetImage: "assets/bussiness.png",
    ),
  ].obs;

  /// ✅ HOME LIST (show "All" + only 4 categories)
  List<BrowseCategoryVM> get homeCategories {
    final allItem = categories.firstWhere(
      (c) => c.id.toLowerCase() == "all",
      orElse: () => const BrowseCategoryVM(
        id: "all",
        title: "All",
        subtitle: "Browse all categories",
        tint: Color(0xFFEFF5FF),
        assetImage: "assets/logo.png",
      ),
    );

    final first4 = categories
        .where((c) => c.id.toLowerCase() != "all")
        .take(4)
        .toList();

    return [allItem, ...first4];
  }

  /// ✅ ALL CATEGORIES SCREEN LIST (exclude "All")
  List<BrowseCategoryVM> get allCategoriesForScreen =>
      categories.where((c) => c.id.toLowerCase() != "all").toList();

  void selectHomeCategory(int i) {
    final list = homeCategories;
    if (i < 0 || i >= list.length) return;
    selectedCategoryIndex.value = i;
  }

  /// ✅ "See All" screen -> send list WITHOUT "All"
  void openAllCategoriesScreen() {
    Get.to(() => AllCategoryScreen(categories: allCategoriesForScreen));
  }

  /// ✅ Home category tap:
  /// if "All" -> open all categories screen
  /// else -> open listing screen
  void openFromHomeCategory(int i) {
    final list = homeCategories;
    if (i < 0 || i >= list.length) return;

    final cat = list[i];
    if (cat.id.toLowerCase() == "all") {
      openAllCategoriesScreen();
      return;
    }

    Get.to(() => CategoryListingsScreen(category: cat));
  }

  void goTOLogin() => Get.toNamed('/login');

  // Featured listings from API
  final featuredListings = <ListingVM>[].obs;
  final isLoadingFeatured = false.obs;

  final properties = <ListingVM>[].obs;
  final isLoadingProperties = false.obs;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadFeaturedListings();
    loadRealEstateListings();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void performSearch() {
    final query = searchController.text.trim();
    if (query.isEmpty) return;

    // Switch to Browse tab (index 1)
    if (Get.isRegistered<CustomBottomNavController>()) {
      Get.find<CustomBottomNavController>().goToTab(1);
      
      // Pass the query to BrowseController
      // We need to make sure BrowseController is initialized
      // (Get.put was used in BrowseScreen, so it should be there if we navigated once, 
      // but to be safe we can use Get.find or just put it if not exists)
      
      try {
        final browseController = Get.find<BrowseController>();
        browseController.setSearch(query);
      } catch (e) {
        // If not registered yet, we can't easily set it before navigation completes
        // but typically tabs are initialized early or we can use a shared state.
        // For now, simple find should work.
      }
    }
  }

  Future<void> loadFeaturedListings() async {
    isLoadingFeatured.value = true;
    try {
      final auth = AuthService.to;
      final token = auth.isLoggedIn.value ? auth.accessToken.value : null;

      final result = await ApiService.getListings(
        page: 1,
        pageSize: 10,
        sort: 'newest',
        token: token,
      );

      if (result != null && result['data'] != null) {
        final listingsData = result['data'] as List;
        print("Featured listings data: ${listingsData.length} items");
        if (listingsData.isNotEmpty) {
          print("First listing images: ${listingsData.first['images']}");
        }
        featuredListings.value = List<ListingVM>.from(
          listingsData.map((item) => ListingVM.fromJson(item)),
        );
        if (featuredListings.isNotEmpty) {
          print("First ListingVM imageUrl: ${featuredListings.first.imageUrl}");
        }
      }
    } catch (e) {
      print('Error loading featured listings: $e');
    } finally {
      isLoadingFeatured.value = false;
    }
  }

  Future<void> loadRealEstateListings() async {
    isLoadingProperties.value = true;
    try {
      final auth = AuthService.to;
      final token = auth.isLoggedIn.value ? auth.accessToken.value : null;

      final result = await ApiService.getListings(
        page: 1,
        pageSize: 10,
        sort: 'newest',
        category: 'real_estate',
        token: token,
      );

      if (result != null && result['data'] != null) {
        final listingsData = result['data'] as List;
        properties.value = List<ListingVM>.from(
          listingsData.map((item) => ListingVM.fromJson(item)),
        );
      }
    } catch (e) {
      print('Error loading real estate listings: $e');
    } finally {
      isLoadingProperties.value = false;
    }
  }

  Future<void> togglePropertyFav(int index) async {
    if (index < 0 || index >= properties.length) return;
    final item = properties[index];

    final auth = AuthService.to;
    if (!auth.isLoggedIn.value) {
      auth.showLoginPrompt();
      return;
    }

    try {
      final result = await ApiService.toggleFavorite(auth.accessToken.value, item.id);
      if (result != null && result['success'] == true) {
        // Update local state instead of full reload for smoother UX
        final newFavorited = result['favorited'] as bool;
        properties[index] = item.copyWith(
          favorited: newFavorited,
        );
        properties.refresh();
      }
    } catch (e) {
      print('❌ Error toggling property favorite: $e');
    }
  }

  Future<void> toggleListingFav(ListingVM item) async {
    final auth = AuthService.to;
    if (!auth.isLoggedIn.value) {
      auth.showLoginPrompt();
      return;
    }

    try {
      final result = await ApiService.toggleFavorite(auth.accessToken.value, item.id);
      if (result != null && result['success'] == true) {
        // Find and update the item in the list
        final index = featuredListings.indexWhere((l) => l.id == item.id);
        if (index != -1) {
          featuredListings[index] = item.copyWith(
            favorited: result['favorited'] as bool,
          );
          featuredListings.refresh();
        }
      }
    } catch (e) {
      print('❌ Error toggling listing favorite: $e');
    }
  }
}

class PropertyVM {
  final String title;
  final String location;
  final String price;
  final String meta;
  final ImageProvider image;
  final bool isFav;

  const PropertyVM({
    required this.title,
    required this.location,
    required this.price,
    required this.meta,
    required this.image,
    this.isFav = false,
  });

  PropertyVM copyWith({
    String? title,
    String? location,
    String? price,
    String? meta,
    ImageProvider? image,
    bool? isFav,
  }) {
    return PropertyVM(
      title: title ?? this.title,
      location: location ?? this.location,
      price: price ?? this.price,
      meta: meta ?? this.meta,
      image: image ?? this.image,
      isFav: isFav ?? this.isFav,
    );
  }
}
