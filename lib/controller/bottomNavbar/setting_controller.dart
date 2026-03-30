import 'package:get/get.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';


enum SettingsTab {
  account,
  notifications,
  privacy,
  security,
  preferences,
  billing,
}

class SettingController extends GetxController {
  final userName = "User".obs;
  final userEmail = "".obs;
  final initials = "U".obs;

  final selectedTab = SettingsTab.account.obs;

  @override
  void onInit() {
    super.onInit();
    _updateUserInfo();

    // Listen to changes in AuthService and update local state
    ever(AuthService.to.userName, (_) => _updateUserInfo());
    ever(AuthService.to.userEmail, (_) => _updateUserInfo());
    ever(AuthService.to.userPhotoUrl, (_) => _updateUserInfo());
  }

  void _updateUserInfo() {
    final emailVal = AuthService.to.userEmail.value;
    final nameVal = AuthService.to.userName.value;

    if (emailVal != null) {
      userEmail.value = emailVal;

      if (nameVal != null && nameVal.isNotEmpty) {
        userName.value = nameVal;
        initials.value = nameVal[0].toUpperCase();
      } else if (userEmail.value.isNotEmpty) {
        initials.value = userEmail.value[0].toUpperCase();
        final emailPrefix = userEmail.value.split('@').first;
        if (emailPrefix.isNotEmpty) {
          userName.value = emailPrefix[0].toUpperCase() + emailPrefix.substring(1).toLowerCase();
        }
      }
    }
  }

  void changeTab(SettingsTab tab) {
    selectedTab.value = tab;
  }

  Future<void> signOut() async {
    await AuthService.to.logout();
    Get.offAllNamed('/login');
  }
}
