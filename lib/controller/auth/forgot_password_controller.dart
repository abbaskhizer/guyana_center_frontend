import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/auth/verification_code_screen.dart';
import 'package:guyana_center_frontend/services/api_services.dart';

class ForgotPasswordController extends GetxController {
  final emailCtrl = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }

  Future<void> sendResetLink() async {
    final email = emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar("Invalid email", "Please enter a valid email address");
      return;
    }

    isLoading.value = true;
    final response = await ApiService.forgotPassword(email);
    isLoading.value = false;

    if (response != null && response.containsKey('message') && !response.containsKey('error')) {
      Get.snackbar("Success", response['message']);
      Get.to(
        () => const VerificationCodeScreen(),
        arguments: {'email': email, 'isPasswordReset': true},
      );
    } else {
      Get.snackbar("Error", response?['message'] ?? "Failed to send reset link");
    }
  }
}
