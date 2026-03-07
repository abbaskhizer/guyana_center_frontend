import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/fav_search.dart';

class BrowseSearchesListingController extends GetxController {
  final selectedCategory = "All".obs;

  final categories = <Map<String, dynamic>>[
    {"label": "All", "icon": Icons.visibility_outlined},
    {"label": "Vehicles", "icon": Icons.directions_car_outlined},
    {"label": "Electronics", "icon": Icons.laptop_mac_outlined},
    {"label": "Fashion", "icon": Icons.checkroom_outlined},
  ].obs;

  final searches = <SavedSearchItem>[
    SavedSearchItem(title: "Toyota Corolla 2020", icon: "assets/van.png"),
    SavedSearchItem(title: "MacBook Pro M2", icon: "assets/e.png"),
    SavedSearchItem(title: "2 Bedroom Apartment", icon: "assets/home.png"),
    SavedSearchItem(title: "Nike Air Jordan Retro", icon: "assets/shirt.png"),
  ].obs;

  void setCategory(String value) {
    selectedCategory.value = value;
  }

  void toggleAlerts(int index) {
    searches[index].alertsOn.value = !searches[index].alertsOn.value;
    searches.refresh();
  }

  void removeSearch(int index) {
    searches.removeAt(index);
  }

  void viewSearch(SavedSearchItem item) {
    Get.snackbar(
      "View Search",
      item.title,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
  }

  void searchMore() {
    Get.snackbar(
      "Search",
      "Find more deals",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
  }
}
