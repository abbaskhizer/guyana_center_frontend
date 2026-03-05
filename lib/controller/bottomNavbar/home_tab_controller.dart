import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';

import 'package:guyana_center_frontend/screens/all_category_screen.dart.dart';
import 'package:guyana_center_frontend/screens/auth/login_signup_screen.dart';
import 'package:guyana_center_frontend/screens/browse_listing_screen.dart';

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

  void goTOLogin() => Get.to(const LoginSignupScreen());

  final featuredListings = <ListingVM>[
    const ListingVM(
      "Toyota Hilux 2022",
      "Georgetown",
      "\$185,000",
      NetworkImage(
        "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=800",
      ),
      badge: "Urgent",
    ),
    const ListingVM(
      "Nissan Juke 2018",
      "Linden",
      "\$120,000",
      NetworkImage(
        "https://images.pexels.com/photos/358070/pexels-photo-358070.jpeg?auto=compress&cs=tinysrgb&w=800",
      ),
    ),
    const ListingVM(
      "Toyota Aqua 2015",
      "Berbice",
      "\$95,000",
      NetworkImage(
        "https://images.pexels.com/photos/120049/pexels-photo-120049.jpeg?auto=compress&cs=tinysrgb&w=800",
      ),
    ),
    const ListingVM(
      "Nissan Frontier 2021",
      "Georgetown",
      "\$210,000",
      NetworkImage(
        "https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg?auto=compress&cs=tinysrgb&w=800",
      ),
      badge: "Featured",
    ),
  ].obs;

  final properties = <PropertyVM>[
    const PropertyVM(
      title: "Modern Villa with Pool",
      location: "Palm Beach, FL",
      price: "\$850,000",
      meta: "4 beds  •  3 baths",
      image: NetworkImage(
        "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=900",
      ),
      isFav: true,
    ),
    const PropertyVM(
      title: "Luxury Estate",
      location: "Malibu, CA",
      price: "\$1,200,000",
      meta: "5 beds  •  4 baths",
      image: NetworkImage(
        "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg?auto=compress&cs=tinysrgb&w=900",
      ),
    ),
    const PropertyVM(
      title: "City Apartment",
      location: "New York, NY",
      price: "\$250,000",
      meta: "2 beds  •  2 baths",
      image: NetworkImage(
        "https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg?auto=compress&cs=tinysrgb&w=900",
      ),
    ),
  ].obs;

  void togglePropertyFav(int index) {
    if (index < 0 || index >= properties.length) return;
    final p = properties[index];
    properties[index] = p.copyWith(isFav: !p.isFav);
  }
}

class ListingVM {
  final String title;
  final String location;
  final String price;
  final ImageProvider image;
  final String? badge;

  const ListingVM(
    this.title,
    this.location,
    this.price,
    this.image, {
    this.badge,
  });
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
