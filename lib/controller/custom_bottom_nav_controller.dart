import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/favorites_controller.dart';
import 'package:guyana_center_frontend/screens/home_screen.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';

class CustomBottomNavController extends GetxController {
  final RxInt index = 0.obs;

  void changeTab(int i) {
    index.value = i;
  }

  void goToTab(int i) {
    // Check if user is logged in for Sell (2), Favorites (3), and Settings (4)
    if ((i == 2 || i == 3 || i == 4) && !AuthService.to.isLoggedIn.value) {
      AuthService.to.showLoginPrompt();
      return; // Do not navigate
    }

    index.value = i;
    
    // Refresh favorites when switching to that tab
    if (i == 3 && Get.isRegistered<FavoritesController>()) {
      Get.find<FavoritesController>().refreshFavorites();
    }

    // If we are on a detail screen (pushed via Get.to), 
    // we need to go back to the home/main screen to show the selected tab.
    if (Get.currentRoute != '/home' && Get.currentRoute != '/') {
       Get.until((route) => route.settings.name == '/home' || route.settings.name == '/');
    }
  }
}
