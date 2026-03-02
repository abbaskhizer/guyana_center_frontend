import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/auth/verification_code_screen.dart';

class ForgotPasswordController extends GetxController {
  final emailCtrl = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }

  Future<void> sendResetLink() async {
    Get.to(() => const VerificationCodeScreen());
  }
}
