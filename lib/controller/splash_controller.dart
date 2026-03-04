import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/home_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _nextScreen();
  }

  Future<void> _nextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAll(HomeScreen());
  }
}
