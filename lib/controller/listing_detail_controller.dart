import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/favorites_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingDetailController extends GetxController {
  final _item = Rxn<ListingVM>();
  final isItemLoading = false.obs;

  ListingVM get item => _item.value as ListingVM;
  ListingVM? get itemNullable => _item.value;

  final currentImage = 0.obs;
  final isFav = false.obs;
  final showPhoneNumber = false.obs;
  final similarAds = <ListingVM>[].obs;
  final isSimilarLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is ListingVM) {
      _setItem(args);
      return;
    }

    if (args is Map) {
      final dynamic rawId = args['listingId'] ?? args['id'];
      final int? listingId = rawId != null ? int.tryParse(rawId.toString()) : null;
      if (listingId != null) {
        _loadListingById(listingId);
        return;
      }
    }

    // If we get here, args are invalid. Keep screen in a safe state.
    _item.value = null;
  }

  void _setItem(ListingVM vm) {
    _item.value = vm;
    isFav.value = vm.favorited;
    currentImage.value = 0;
    loadSimilarAds();
  }

  Future<void> _loadListingById(int id) async {
    isItemLoading.value = true;
    try {
      final auth = AuthService.to;
      final token = auth.isLoggedIn.value ? auth.accessToken.value : null;
      final response = await ApiService.getListingById(id, token: token);
      if (response != null && response['success'] == true && response['data'] != null) {
        final vm = ListingVM.fromJson(response['data']);
        _setItem(vm);
      } else {
        _item.value = null;
      }
    } catch (e) {
      print('❌ Error loading listing $id: $e');
      _item.value = null;
    } finally {
      isItemLoading.value = false;
    }
  }

  Future<void> loadSimilarAds() async {
    isSimilarLoading.value = true;
    try {
      final current = _item.value;
      if (current == null) return;
      final auth = AuthService.to;
      final token = auth.isLoggedIn.value ? auth.accessToken.value : null;

      final response = await ApiService.getListings(
        category: current.categoryId,
        pageSize: 6, // Fetch a few more to filter current one
        token: token,
      );
      
      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'];
        final all = data.map((json) => ListingVM.fromJson(json)).toList();
        
        // Filter out current listing and limit to 4
        similarAds.assignAll(
          all.where((ad) => ad.id != current.id).take(4).toList()
        );
      }
    } catch (e) {
      print('❌ Error loading similar ads: $e');
    } finally {
      isSimilarLoading.value = false;
    }
  }

  bool get isLoggedIn {
    try {
      return AuthService.to.isLoggedIn.value;
    } catch (_) {
      return false;
    }
  }

  bool get isOwner {
    try {
      final auth = AuthService.to;
      final current = _item.value;
      if (current == null) return false;
      return auth.isLoggedIn.value && auth.userEmail.value == current.user?.email;
    } catch (_) {
      return false;
    }
  }

  int get imageCount {
    final current = _item.value;
    return current != null && current.images.isNotEmpty ? current.images.length : 1;
  }

  void setImage(int i) {
    currentImage.value = i;
  }

  void prev() {
    final current = _item.value;
    if (current == null || current.images.isEmpty) return;
    currentImage.value = (currentImage.value - 1).clamp(
      0,
      current.images.length - 1,
    );
  }

  void next() {
    final current = _item.value;
    if (current == null || current.images.isEmpty) return;
    currentImage.value = (currentImage.value + 1).clamp(
      0,
      current.images.length - 1,
    );
  }

  Future<void> toggleFav() async {
    final auth = AuthService.to;
    if (!auth.isLoggedIn.value) {
      auth.showLoginPrompt();
      return;
    }

    final current = _item.value;
    if (current == null) return;

    // Optimistic UI update
    isFav.value = !isFav.value;

    try {
      final result = await ApiService.toggleFavorite(auth.accessToken.value, current.id);
      if (result == null || result['success'] != true) {
        // Rollback on failure
        isFav.value = !isFav.value;
        Get.snackbar("Error", result?['message'] ?? "Could not update favorite status");
      } else {
        // Refresh favorites screen if it's already in memory
        if (Get.isRegistered<FavoritesController>()) {
          Get.find<FavoritesController>().refreshFavorites();
        }
      }
    } catch (e) {
      // Rollback on error
      isFav.value = !isFav.value;
      print('❌ Error toggling favorite: $e');
    }
  }

  void togglePhone() {
    showPhoneNumber.value = !showPhoneNumber.value;
  }

  Future<void> makeCall() async {
    final current = _item.value;
    if (current == null) return;
    final phone = current.contactPhone.isNotEmpty ? current.contactPhone : current.user?.phone;
    if (phone == null || phone.isEmpty) return;
    
    print('📞 Attempting to call: $phone');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone.replaceAll(RegExp(r'[^0-9+]'), ''),
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        print('❌ Could not launch dialer for $phone');
        Get.snackbar("Error", "Could not open dialer for this number: $phone");
      }
    } catch (e) {
      print('❌ Error launching dialer: $e');
    }
  }
}
