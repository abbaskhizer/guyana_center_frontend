// controller/home_tab_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/auth/login_signup_screeen.dart';

class HomeTabController extends GetxController {
  final categories = <CategoryVM>[
    const CategoryVM(Icons.directions_car, "Cars", true),
    const CategoryVM(Icons.home_work, "Real Estate"),
    const CategoryVM(Icons.store, "Electronics"),
    const CategoryVM(Icons.work, "Jobs"),
    const CategoryVM(Icons.pets, "Pets"),
    const CategoryVM(Icons.business, "Services"),
    const CategoryVM(Icons.chair, "Furniture"),
    const CategoryVM(Icons.shopping_bag, "Fashion"),
  ].obs;

  // ✅ ALL listing images from internet (NetworkImage)
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
      "Nissan June 2018",
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

  // ✅ ALL property images from internet too
  final properties = <PropertyVM>[
    const PropertyVM(
      "Modern Villa with Pool",
      "\$50,000",
      NetworkImage(
        "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=900",
      ),
    ),
    const PropertyVM(
      "Luxury Estate",
      "\$1,200,000",
      NetworkImage(
        "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg?auto=compress&cs=tinysrgb&w=900",
      ),
    ),
    const PropertyVM(
      "City Apartment",
      "\$250,000",
      NetworkImage(
        "https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg?auto=compress&cs=tinysrgb&w=900",
      ),
    ),
  ].obs;
  void goTOLogin() {
    Get.to(LoginSignupScreen());
  }
}

class CategoryVM {
  final IconData icon;
  final String title;
  final bool active;
  const CategoryVM(this.icon, this.title, [this.active = false]);
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
  final String price;
  final ImageProvider image;
  const PropertyVM(this.title, this.price, this.image);
}
