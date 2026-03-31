import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/home_tab_controller.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/sell_controller.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart'; 
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';

class AgentProfileController extends GetxController {
  final isLoading = false.obs;
  final isOwnProfile = true.obs;
  final listings = <ListingVM>[].obs;
  final sellerUser = Rxn<UserData>();

  @override
  void onInit() {
    super.onInit();
    
    // Handle URL parameters from deep links (e.g., /agent/123)
    final urlId = Get.parameters['id'];
    if (urlId != null) {
      final targetId = int.tryParse(urlId.toString());
      if (targetId != null) {
        isOwnProfile.value = (targetId == AuthService.to.userId.value);
        loadUserListings(targetId);
        return;
      }
    }
    
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('userId') && args['userId'] != null) {
      final targetId = args['userId'] as int;
      isOwnProfile.value = (targetId == AuthService.to.userId.value);
      loadUserListings(targetId);
      if (args.containsKey('user')) {
        sellerUser.value = args['user'] as UserData;
      }
    } else {
      isOwnProfile.value = true;
      // Set sellerUser from AuthService for own profile
      if (AuthService.to.userEmail.value != null) {
        sellerUser.value = UserData(
          id: AuthService.to.userId.value ?? 0,
          name: AuthService.to.userName.value,
          email: AuthService.to.userEmail.value!,
          phone: AuthService.to.userPhone.value,
        );
      }
      // Listen for changes in AuthService
      ever(AuthService.to.userName, (_) => _updateSellerUser());
      ever(AuthService.to.userEmail, (_) => _updateSellerUser());
      ever(AuthService.to.userId, (_) => _updateSellerUser());
      loadUserListings();
    }
  }

  void _updateSellerUser() {
    if (isOwnProfile.value && AuthService.to.userEmail.value != null) {
      sellerUser.value = UserData(
        id: AuthService.to.userId.value ?? 0,
        name: AuthService.to.userName.value,
        email: AuthService.to.userEmail.value!,
        phone: AuthService.to.userPhone.value,
      );
    }
  }

  Future<void> loadUserListings([int? uid]) async {
    final targetId = uid ?? AuthService.to.userId.value;
    if (targetId == null) return;

    isLoading.value = true;
    try {
      final response = await ApiService.getUserListings(targetId);
      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'];
        listings.assignAll(data.map((x) => ListingVM.fromJson(x)).toList());
        
        // If we don't have seller info yet, grab it from the first listing
        if (sellerUser.value == null && listings.isNotEmpty) {
          sellerUser.value = listings.first.user;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteListing(int id) async {
    final token = AuthService.to.accessToken.value;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Ad?", style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text("Are you sure you want to delete this listing? It will be permanently removed from the marketplace."),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text("Cancel", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      isLoading.value = true;
      final response = await ApiService.deleteListing(token, id);
      isLoading.value = false;

      if (response != null && response['success'] == true) {
        // Manually remove to avoid full reload if possible, or just reload
        listings.removeWhere((l) => l.id == id);
        Get.snackbar("Removed", "Listing deleted successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87, colorText: Colors.white, margin: EdgeInsets.all(16));
      } else {
        Get.snackbar("Error", response?['message'] ?? "Failed to delete listing",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red, colorText: Colors.white, margin: EdgeInsets.all(16));
      }
    }
  }

  Future<void> editListing(ListingVM listing) async {
    final sellController = Get.isRegistered<SellController>()
        ? Get.find<SellController>()
        : Get.put(SellController());

    sellController.loadListingToEdit(listing);
    
    // Navigate to sell screen (index 2 of main bottom nav, or just push the screen)
    // For simplicity, let's push the SellScreen specifically or just trigger navigation
    // Since SellScreen is part of the bottom nav, we might need to change the active tab
    // However, to keep focus, we'll just push it as a new route.
    
    final result = await Get.toNamed('/sell'); 
    
    // If update was successful, refresh the list
    if (result == true) {
      loadUserListings();
    }
  }

  int get soldCount => listings.where((l) => l.status == 'sold').length;

  double get earnings {
    double total = 0;
    for (var l in listings) {
      if (l.status == 'sold') {
        // Strip everything except digits and dots
        String p = l.price.replaceAll(RegExp(r'[^0-9.]'), '');
        total += double.tryParse(p) ?? 0.0;
      }
    }
    return total;
  }

  Future<void> markAsSold(int id) async {
    final token = AuthService.to.accessToken.value;
    isLoading.value = true;
    
    // We only need to update the status
    final response = await ApiService.updateListing(
      token: token,
      id: id,
      status: 'sold',
    );
    
    isLoading.value = false;

    if (response != null && response['success'] == true) {
      Get.snackbar("Success", "Listing marked as sold!",
          backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      
      // refresh home tab if it's open
      if (Get.isRegistered<HomeTabController>()) {
        Get.find<HomeTabController>().loadFeaturedListings();
      }
      
      loadUserListings(); // Refresh everything
    } else {
      Get.snackbar("Error", response?['message'] ?? "Failed to mark as sold",
          backgroundColor: Colors.red.withOpacity(.1));
    }
  }
}
