import 'package:get/get.dart';

class SecurityController extends GetxController {
  final twoFactorEnabled = false.obs;

  void toggle2FA(bool v) => twoFactorEnabled.value = v;
}
