import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/browse_controller.dart';
import 'package:guyana_center_frontend/controller/custom_bottom_nav_controller.dart';
import 'package:guyana_center_frontend/modal/favItem.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';
import 'package:guyana_center_frontend/modal/fav_search.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends GetxController {
  final tab = FavTab.ads.obs;
  late final PageController pageController;

  final favoriteAds = <ListingVM>[].obs;
  final isLoadingAds = false.obs;

  // Saved Searches state
  final searches = <SavedSearchItem>[].obs;
  
  final searchQuery = "".obs;
  final selectedCategory = "All".obs;
  final searchInputText = "".obs; // For the "Add Keyword" text field
  late final TextEditingController searchInputController;

  static const String _searchesKey = 'saved_search_keywords';

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    searchInputController = TextEditingController();
    
    // Sync controller and Rx variable
    searchInputController.addListener(() {
      searchInputText.value = searchInputController.text;
    });

    loadFavoriteAds();
    loadSearchesFromStorage();
  }

  @override
  void onClose() {
    pageController.dispose();
    searchInputController.dispose();
    super.onClose();
  }

  Future<void> loadSearchesFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? searchesJson = prefs.getString(_searchesKey);
      debugPrint('💾 Loading saved search keywords...');
      if (searchesJson != null) {
        final List<dynamic> decoded = jsonDecode(searchesJson);
        final List<SavedSearchItem> items = decoded.map((x) => SavedSearchItem.fromJson(x)).toList();
        searches.assignAll(items);
        searches.refresh();
        debugPrint('✅ Loaded ${items.length} keywords from storage');
      } else {
        debugPrint('ℹ️ No saved keywords found in storage');
      }
    } catch (e) {
      debugPrint('❌ Error loading saved searches: $e');
    }
  }

  Future<void> saveSearchesToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(searches.map((x) => x.toJson()).toList());
      await prefs.setString(_searchesKey, encoded);
      debugPrint('💾 Saved ${searches.length} keywords to storage');
    } catch (e) {
      debugPrint('❌ Error saving searches: $e');
    }
  }

  Future<void> loadFavoriteAds() async {
    final auth = AuthService.to;
    if (!auth.isLoggedIn.value) {
      favoriteAds.clear();
      return;
    }

    isLoadingAds.value = true;
    try {
      final response = await ApiService.getFavorites(auth.accessToken.value);
      if (response != null && response['data'] != null) {
        final List<dynamic> data = response['data'];
        favoriteAds.assignAll(data.map((item) => ListingVM.fromJson(item)).toList());
        favoriteAds.refresh();
      }
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
    } finally {
      isLoadingAds.value = false;
    }
  }

  void refreshFavorites() => loadFavoriteAds();

  void toggleFavorite(ListingVM listing) async {
    final auth = AuthService.to;
    if (!auth.isLoggedIn.value) return;

    if (favoriteAds.any((element) => element.id == listing.id)) {
      favoriteAds.removeWhere((element) => element.id == listing.id);
    } else {
      favoriteAds.add(listing);
    }
    
    await ApiService.toggleFavorite(auth.accessToken.value, listing.id);
    loadFavoriteAds();
  }

  void setTab(FavTab t) {
    tab.value = t;
    pageController.animateToPage(
      t == FavTab.ads ? 0 : 1, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut
    );
  }

  void onPageChanged(int index) {
    tab.value = index == 0 ? FavTab.ads : FavTab.searches;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setSearch(String query) {
    searchQuery.value = query;
  }

  void setSearchInput(String value) {
    searchInputText.value = value;
    if (searchInputController.text != value) {
      searchInputController.text = value;
    }
  }

  void addSearch() {
    if (searchInputText.value.trim().isEmpty) return;
    
    final newItem = SavedSearchItem(
      title: searchInputText.value.trim(),
      icon: "assets/search_ic.png",
    );
    
    searches.insert(0, newItem);
    setSearchInput(""); // Use method to clear both
    saveSearchesToStorage();
  }

  void removeSearch(int index) {
    searches.removeAt(index);
    saveSearchesToStorage();
  }

  void toggleAlerts(int index) {
    searches[index].alertsOn.toggle();
    saveSearchesToStorage();
  }

  void viewSearch(SavedSearchItem item) {
    final query = item.title.trim();
    if (query.isEmpty) return;

    if (Get.isRegistered<CustomBottomNavController>()) {
      Get.find<CustomBottomNavController>().goToTab(1);
      
      final browseController = Get.isRegistered<BrowseController>() 
          ? Get.find<BrowseController>() 
          : Get.put(BrowseController());
          
      browseController.setSearch(query);
    }
  }

  String _labelToId(String label) {
    switch (label.toLowerCase()) {
      case 'real estate': return 'real_estate';
      case 'electronics': return 'electronics';
      case 'vehicles': return 'vehicles';
      case 'jobs': return 'jobs';
      case 'fashion': return 'fashion';
      case 'home & garden': return 'home_garden';
      case 'sports & hobbies': return 'sports_hobbies';
      case "kids' stuff": return 'kids';
      case 'pets & animals': return 'pets';
      case 'health & beauty': return 'health_beauty';
      case 'services': return 'services';
      case 'business': return 'business';
      default: return label.toLowerCase();
    }
  }

  List<ListingVM> get filteredAds {
    final catId = _labelToId(selectedCategory.value);
    
    return favoriteAds.where((ad) {
      final matchesSearch = ad.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          ad.location.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      final matchesCategory = selectedCategory.value == "All" || 
          ad.categoryId.toLowerCase() == catId;
          
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void openBrowseAds() {
    if (Get.isRegistered<CustomBottomNavController>()) {
      Get.find<CustomBottomNavController>().goToTab(0);
    }
  }

  void openBrowseSearches() {}
}
