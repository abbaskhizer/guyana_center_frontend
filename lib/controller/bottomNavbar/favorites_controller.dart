import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/favItem.dart';
import 'package:guyana_center_frontend/screens/browse_ads_listing_screen.dart';
import 'package:guyana_center_frontend/screens/browse_searches_listing_screen.dart';

class FavoritesController extends GetxController {
  final tab = FavTab.ads.obs;

  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  void setTab(FavTab t) {
    tab.value = t;

    pageController.animateToPage(
      t == FavTab.ads ? 0 : 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void onPageChanged(int index) {
    tab.value = index == 0 ? FavTab.ads : FavTab.searches;
  }

  void openBrowseAds() {
    Get.to(() => BrowseAdsListingScreen());
  }

  void openBrowseSearches() {
    Get.to(() => BrowseSearchesListingScreen());
  }
}
