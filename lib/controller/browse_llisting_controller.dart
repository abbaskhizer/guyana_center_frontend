import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/favorites_controller.dart';

class BrowseListingController extends GetxController {
  late BrowseCategoryVM category;

  final listingsCount = "0".obs;
  final updated = "0".obs;
  final rating = "4.8".obs;

  final chips = <String>[].obs;
  final chipIndex = 0.obs;

  final search = "".obs;
  final sort = "Newest".obs;
  final isGrid = true.obs;
  final sorts = const ["Newest", "Price: Low", "Price: High"];

  final currentPage = 1.obs;
  final totalPages = 1.obs;

  final pageSize = 10;

  final allListings = <ListingVM>[].obs;
  final isLoading = false.obs;

  void initWithCategory(BrowseCategoryVM cat) {
    category = cat;

    chips.value = ["All"];
    chipIndex.value = 0;

    search.value = "";
    sort.value = "Newest";
    isGrid.value = true;

    currentPage.value = 1;

    rating.value = "4.8";

    // Load listings from API
    loadListings();
  }

  Future<void> loadListings() async {
    isLoading.value = true;
    try {
      String? sortParam;
      switch (sort.value) {
        case "Price: Low":
          sortParam = "price-low";
          break;
        case "Price: High":
          sortParam = "price-high";
          break;
        case "Newest":
        default:
          sortParam = "newest";
          break;
      }

      final auth = AuthService.to;
      final token = auth.isLoggedIn.value ? auth.accessToken.value : null;

      final result = await ApiService.getListings(
        category: category.id == "all" ? null : category.id,
        search: search.value.isEmpty ? null : search.value,
        sort: sortParam,
        page: currentPage.value,
        pageSize: pageSize,
        token: token,
      );

      if (result != null && result['data'] != null) {
        final listingsData = result['data'] as List;
        print("Category listings data: ${listingsData.length} items");
        if (listingsData.isNotEmpty) {
          print("First listing images raw: ${listingsData.first['images']}");
        }
        allListings.value = List<ListingVM>.from(
          listingsData.map((item) => ListingVM.fromJson(item)),
        );
        if (allListings.isNotEmpty) {
          print("First ListingVM imageUrl: ${allListings.first.imageUrl}");
        }

        // Update pagination info
        final total = result['total'] ?? 0;
        listingsCount.value = "$total";
        totalPages.value = result['totalPages'] ?? 1;

        // Calculate new listings in last 24h (simplified)
        updated.value = "${(total * 0.02).toInt()}";
      } else {
        allListings.value = [];
        listingsCount.value = "0";
        totalPages.value = 1;
      }
    } catch (e) {
      print('Error loading listings: $e');
      allListings.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(ListingVM item) async {
    final auth = AuthService.to;
    if (!auth.isLoggedIn.value) {
      auth.showLoginPrompt();
      return;
    }

    try {
      final result = await ApiService.toggleFavorite(auth.accessToken.value, item.id);
      if (result != null && result['success'] == true) {
        // Update local item
        final index = allListings.indexWhere((l) => l.id == item.id);
        if (index != -1) {
          allListings[index] = item.copyWith(
            favorited: result['favorited'] as bool,
          );
          allListings.refresh();
          
          // Refresh favorites screen if it's already in memory
          if (Get.isRegistered<FavoritesController>()) {
            Get.find<FavoritesController>().refreshFavorites();
          }
        }
      }
    } catch (e) {
      print('❌ Error toggling favorite in BrowseListingController: $e');
    }
  }

  void _recalcPages() {
    // Recalculation happens on server side now
    loadListings();
  }

  void setChip(int i) {
    if (i < 0 || i >= chips.length) return;
    chipIndex.value = i;
    currentPage.value = 1;
    _recalcPages();
  }

  void setSearch(String v) {
    search.value = v;
    currentPage.value = 1;
    _recalcPages();
  }

  void setSort(String v) {
    sort.value = v;
    currentPage.value = 1;
    loadListings();
  }

  void toggleView() => isGrid.value = !isGrid.value;

  void goToPage(int p) {
    if (p < 1 || p > totalPages.value) return;
    currentPage.value = p;
    loadListings();
  }

  List<ListingVM> get filteredListings {
    // All filtering is done server-side now
    return allListings;
  }

  int get totalFilteredCount => int.tryParse(listingsCount.value) ?? 0;
}
