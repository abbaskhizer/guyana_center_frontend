import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/favItem.dart';

class FavoritesController extends GetxController {
  final tab = FavTab.ads.obs;

  // ===== Ads tab UI =====
  final searchCtrl = TextEditingController();
  final query = "".obs;

  // filters like figma: All, Vehicles, Real estate, Jobs...
  final adFilters = const <String>[
    "All",
    "Vehicles",
    "Real estate",
    "Jobs",
    "Electronics",
    "Fashion",
  ];
  final selectedFilter = "All".obs;

  // ===== Data =====
  final favoriteAds = <FavItemVM>[].obs; // empty => show empty state
  final savedSearches = <SavedSearchVM>[].obs; // empty => show empty state

  @override
  void onInit() {
    super.onInit();

    // Demo data (remove if you load from API)
    favoriteAds.assignAll([
      FavItemVM(
        title: "ACER Aspire Easy i5",
        price: "\$3,400",
        location: "Chaguanas",
        imageUrl: "https://picsum.photos/500?random=11",
        badge: "New",
      ),
      FavItemVM(
        title: "Macbook Pro M1",
        price: "\$7,199",
        location: "Port of Spain",
        imageUrl: "https://picsum.photos/500?random=12",
        badge: "Urgent",
      ),
      FavItemVM(
        title: "Canon 80D DSLR Camera",
        price: "\$2,600",
        location: "San Fernando",
        imageUrl: "https://picsum.photos/500?random=13",
        badge: "Featured",
        featured: true,
      ),
    ]);

    savedSearches.assignAll([
      SavedSearchVM(
        title: "Apartment",
        subtitle: "Real estate",
        query: "2 bed",
        location: "Port of Spain",
      ),
      SavedSearchVM(
        title: "Toyota",
        subtitle: "Vehicles",
        query: "Hilux",
        location: "Central",
      ),
      SavedSearchVM(
        title: "iPhone",
        subtitle: "Electronics",
        query: "13 Pro",
        location: "North East",
      ),
    ]);

    searchCtrl.addListener(() => query.value = searchCtrl.text);
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }

  void setTab(FavTab t) => tab.value = t;

  void setFilter(String f) => selectedFilter.value = f;

  void clearSearch() {
    searchCtrl.clear();
    query.value = "";
  }

  // Visible ads (filter + search)
  List<FavItemVM> get visibleAds {
    final q = query.value.trim().toLowerCase();
    final f = selectedFilter.value;

    return favoriteAds.where((e) {
      final filterOk = f == "All"
          ? true
          : e.title.toLowerCase().contains(f.toLowerCase());
      final searchOk = q.isEmpty
          ? true
          : (e.title.toLowerCase().contains(q) ||
                e.location.toLowerCase().contains(q) ||
                e.price.toLowerCase().contains(q));
      return filterOk && searchOk;
    }).toList();
  }

  void toggleFav(int indexInVisible) {
    final v = visibleAds;
    if (indexInVisible < 0 || indexInVisible >= v.length) return;
    final item = v[indexInVisible];

    // remove from main list
    favoriteAds.removeWhere(
      (x) =>
          x.title == item.title &&
          x.price == item.price &&
          x.location == item.location &&
          x.imageUrl == item.imageUrl,
    );
  }

  void removeSavedSearch(int index) {
    if (index < 0 || index >= savedSearches.length) return;
    savedSearches.removeAt(index);
  }

  void runSavedSearch(SavedSearchVM s) {
    Get.snackbar("Search", "Searching: ${s.title} • ${s.query}");
  }
}
