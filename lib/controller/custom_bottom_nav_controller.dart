import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/home_screen.dart';

class CustomBottomNavController extends GetxController {
  final RxInt index = 0.obs;

  void changeTab(int i) {
    index.value = i;
  }

  void goToTab(int i) {
    index.value = i;

    Get.offAll(() => HomeScreen());
  }
}
