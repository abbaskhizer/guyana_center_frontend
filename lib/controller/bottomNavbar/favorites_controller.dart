import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/favItem.dart';
import 'package:guyana_center_frontend/screens/browse_ads_listing_screen.dart';
import 'package:guyana_center_frontend/screens/browse_searches_listing_screen.dart';

class FavoritesController extends GetxController {
  final tab = FavTab.ads.obs;

  final searchCtrl = TextEditingController();
  final query = "".obs;

  final adFilters = const <String>[
    "All",
    "Vehicles",
    "Real estate",
    "Jobs",
    "Electronics",
    "Fashion",
  ];
  final selectedFilter = "All".obs;

  final favoriteAds = <FavItemVM>[].obs;
  final savedSearches = <SavedSearchVM>[].obs;

  @override
  void onInit() {
    super.onInit();

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

  void openBrowseAds() {
    Get.to(() => const BrowseAdsListingScreen());
  }

  void openBrowseSearches() {
    Get.to(() => const BrowseSearchesListingScreen());
  }

  void runSavedSearch(SavedSearchVM s) {
    Get.snackbar("Search", "Searching: ${s.title} • ${s.query}");
  }
}
