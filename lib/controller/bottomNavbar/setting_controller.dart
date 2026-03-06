import 'package:get/get.dart';

enum SettingsTab {
  account,
  notifications,
  privacy,
  security,
  preferences,
  billing,
}

class SettingController extends GetxController {
  final userName = "Nasha Montone".obs;
  final userEmail = "nasha@email.com".obs;
  final initials = "NM".obs;

  final selectedTab = SettingsTab.account.obs;

  void changeTab(SettingsTab tab) {
    selectedTab.value = tab;
  }

  void signOut() {
    Get.snackbar("Sign Out", "Signed out (demo)");
  }
}
