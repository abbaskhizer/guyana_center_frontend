import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final featuredListings = <ListingVM>[
    const ListingVM(
      "Toyota Hilux 2022",
      "Georgetown",
      "\$185,000",
      AssetImage("assets/images/car1.jpg"),
      badge: "Urgent",
    ),
    const ListingVM(
      "Nissan June 2018",
      "Linden",
      "\$120,000",
      AssetImage("assets/images/car2.jpg"),
    ),
    const ListingVM(
      "Toyota Aqua 2015",
      "Berbice",
      "\$95,000",
      AssetImage("assets/images/car3.jpg"),
    ),
    const ListingVM(
      "Nissan Frontier 2021",
      "Georgetown",
      "\$210,000",
      AssetImage("assets/images/car1.jpg"),
      badge: "Featured",
    ),
  ].obs;
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
