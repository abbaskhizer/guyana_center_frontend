import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/fav_ads.dart';

class BrowseAdsListingController extends GetxController {
  final searchCtrl = TextEditingController();

  final selectedFilterIndex = 0.obs;

  final filters = <String>[
    "All",
    "Real Estate",
    "Electronics",
    "Vehicles",
    "Home & Garden",
    "Fashion",
    "Services",
  ].obs;

  final items = <BrowseAdsItem>[
    const BrowseAdsItem(
      imageUrl:
          "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80",
      category: "Vehicles",
      title: "Toyota Premio 2018 - Excellent Condition",
      price: "\$8,500,000",
      location: "Georgetown",
      time: "2 hours ago",
      rating: "4.9",
      featured: true,
    ),
    const BrowseAdsItem(
      imageUrl:
          "https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=1200&q=80",
      category: "Real Estate",
      title: "2 Bedroom Apartment for Rent",
      price: "\$180,000/m",
      location: "East Coast Demerara",
      time: "5 hours ago",
      rating: "4.8",
      featured: true,
    ),
    const BrowseAdsItem(
      imageUrl:
          "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=1200&q=80",
      category: "Electronics",
      title: "MacBook Pro M2 13-inch",
      price: "\$420,000",
      location: "New Amsterdam",
      time: "1 hour ago",
      rating: "4.7",
    ),
    const BrowseAdsItem(
      imageUrl:
          "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1200&q=80",
      category: "Home & Garden",
      title: "Modern L-Shape Sofa Set",
      price: "\$145,000",
      location: "Linden",
      time: "3 hours ago",
      rating: "4.6",
    ),
    const BrowseAdsItem(
      imageUrl:
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=1200&q=80",
      category: "Fashion",
      title: "Smart Watch Series 8",
      price: "\$68,000",
      location: "Georgetown",
      time: "6 hours ago",
      rating: "4.5",
    ),
    const BrowseAdsItem(
      imageUrl:
          "https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1200&q=80",
      category: "Services",
      title: "Professional Photography Services",
      price: "\$25,000",
      location: "Berbice",
      time: "1 day ago",
      rating: "4.9",
    ),
    const BrowseAdsItem(
      imageUrl:
          "https://images.unsplash.com/photo-1600585154526-990dced4db0d?auto=format&fit=crop&w=1200&q=80",
      category: "Real Estate",
      title: "3 Bedroom House for Sale",
      price: "\$32,000,000",
      location: "Diamond",
      time: "4 hours ago",
      rating: "4.8",
    ),
    const BrowseAdsItem(
      imageUrl:
          "https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=1200&q=80",
      category: "Vehicles",
      title: "Toyota Hilux Revo 2020",
      price: "\$12,500,000",
      location: "Bartica",
      time: "7 hours ago",
      rating: "4.7",
    ),
  ].obs;

  final query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchCtrl.addListener(() {
      query.value = searchCtrl.text.trim().toLowerCase();
    });
  }

  void setFilter(int index) {
    selectedFilterIndex.value = index;
  }

  String get selectedFilter => filters[selectedFilterIndex.value];

  List<BrowseAdsItem> get filteredItems {
    return items.where((item) {
      final filterMatch = selectedFilter == "All"
          ? true
          : item.category.toLowerCase() == selectedFilter.toLowerCase();

      final searchMatch = query.value.isEmpty
          ? true
          : item.title.toLowerCase().contains(query.value) ||
                item.category.toLowerCase().contains(query.value) ||
                item.location.toLowerCase().contains(query.value);

      return filterMatch && searchMatch;
    }).toList();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
