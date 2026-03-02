import 'package:get/get.dart';

class SettingController extends GetxController {
  // demo user
  final userName = "Nasha Montone".obs;
  final userEmail = "nasha@email.com".obs;
  final initials = "NM".obs;

  void signOut() {
    Get.snackbar("Sign Out", "Signed out (demo)");
  }
}
