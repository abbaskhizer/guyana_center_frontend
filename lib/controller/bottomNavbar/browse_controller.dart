import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/services/api_services.dart';

class BrowseController extends GetxController {
  final searchText = ''.obs;
  final isLoading = false.obs;

  final isGrid = true.obs;
  final sortLabel = 'Newest'.obs;
  final forceEmptyState = false.obs;

  final listings = <BrowseListingVM>[].obs;

  final popularSearches = const <String>[
    'Toyota Hilux 2024',
    'Apartment for Rent',
    'iPhone 15 Pro Max',
    'Office Furniture Set',
    'BMW 3 Series',
  ];

  String defaultSearchHint(bool web) => 'Search Ads';

  bool get hasQuery => searchText.value.trim().isNotEmpty;

  String displayQuery(bool web) {
    final value = searchText.value.trim();
    return value.isEmpty ? defaultSearchHint(web) : value;
  }

  String get emptyStateTitleQuery {
    final value = searchText.value.trim();
    return value.isEmpty ? 'Search' : value;
  }

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    
    // Listen to search text changes with debounce
    debounce(searchText, (v) {
      if (v.trim().isEmpty) {
        listings.clear();
      } else {
        fetchListings();
      }
    }, time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchListings() async {
    try {
      isLoading.value = true;
      final query = searchText.value.trim();

      // Map display label to backend enum value
      String? sortValue;
      if (sortLabel.value == 'Price: Low to High') sortValue = 'price-low';
      if (sortLabel.value == 'Price: High to Low') sortValue = 'price-high';
      if (sortLabel.value == 'Newest') sortValue = 'newest';

      final response = await ApiService.getListings(
        search: query.isEmpty ? null : query,
        sort: sortValue,
      );

      if (response != null && response['data'] != null) {
        final List<dynamic> data = response['data'];
        listings.assignAll(data.map((item) => _mapToListingVM(item)).toList());
      } else {
        listings.clear();
      }
    } catch (e) {
      print('Error fetching listings: $e');
      listings.clear();
    } finally {
      isLoading.value = false;
    }
  }

  BrowseListingVM _mapToListingVM(dynamic item) {
    List<String> images = [];
    if (item['images'] is List) {
      images = List<String>.from(item['images']);
    }

    String finalImageUrl = 'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=1200';
    if (images.isNotEmpty) {
      final first = images[0];
      if (first.startsWith('http')) {
        finalImageUrl = first;
      } else {
        final path = first.startsWith('/') ? first.substring(1) : first;
        finalImageUrl = '${ApiService.baseUrl}/$path';
      }
    }

    final galleryUrls = images.map((img) {
      if (img.startsWith('http')) return img;
      final path = img.startsWith('/') ? img.substring(1) : img;
      return '${ApiService.baseUrl}/$path';
    }).toList();

    return BrowseListingVM(
      id: item['id']?.toString() ?? '',
      title: item['title'] ?? '',
      brand: item['brand'] ?? '',
      model: item['model'] ?? '',
      price: '\$${item['price']}',
      location: item['location'] ?? '',
      category: item['category']?.toString() ?? 'Other',
      imageUrl: finalImageUrl,
      gallery: galleryUrls,
      featured: item['featured'] ?? false,
      description: item['description'] ?? '',
      condition: item['condition'] ?? 'Negotiable',
      trim: item['trim'] ?? '',
      fuel: item['fuelType'] ?? '',
      transmission: item['transmission'] ?? '',
    );
  }

  void setSearch(String value) {
    searchController.text = value;
    searchText.value = value;
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    forceEmptyState.value = false;
    listings.clear();
  }

  void toggleView() {
    isGrid.value = !isGrid.value;
  }

  void setGridView() {
    isGrid.value = true;
  }

  void setListView() {
    isGrid.value = false;
  }

  void setSort(String label) {
    sortLabel.value = label;
    fetchListings();
  }

  List<BrowseListingVM> get filtered => listings;

  bool get isLandingState =>
      listings.isEmpty && !hasQuery && !forceEmptyState.value && !isLoading.value;

  bool get showEmptyState =>
      !isLoading.value && (forceEmptyState.value || (hasQuery && listings.isEmpty));
}
