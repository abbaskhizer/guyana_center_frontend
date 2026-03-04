import 'package:get/get.dart';

class CustomBottomNavController extends GetxController {
  final RxInt index = 0.obs;

  void changeTab(int i) {
    index.value = i;
  }
}
