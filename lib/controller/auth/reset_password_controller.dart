import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/auth/login_signup_controller.dart';
import 'package:guyana_center_frontend/screens/auth/login_signup_screen.dart';
import 'package:guyana_center_frontend/services/api_services.dart';

class ResetPasswordController extends GetxController {
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmHidden = true.obs;
  final isLoading = false.obs;

  late String email;
  late String otp;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    email = args?['email'] ?? '';
    otp = args?['otp'] ?? '';
  }

  @override
  void onClose() {
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }

  void togglePassword() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirm() => isConfirmHidden.value = !isConfirmHidden.value;

  Future<void> updatePassword() async {
    final pass = passCtrl.text;
    final confirm = confirmCtrl.text;

    if (pass.length < 6) {
      Get.snackbar("Invalid Password", "Password must be at least 6 characters");
      return;
    }
    if (pass != confirm) {
      Get.snackbar("Mismatch", "Passwords do not match");
      return;
    }
    if (email.isEmpty || otp.isEmpty) {
      Get.snackbar("Error", "Missing reset token or email. Try forgot password again.");
      return;
    }

    isLoading.value = true;
    final response = await ApiService.resetPassword(email, otp, pass);
    isLoading.value = false;

    if (response != null && response.containsKey('message') && !response.containsKey('error')) {
      Get.snackbar("Success", response['message']);
      // Explicitly delete to prevent "used after being disposed" error when reusing existing controller
      if (Get.isRegistered<LoginSignupController>()) {
        Get.delete<LoginSignupController>();
      }
      Get.offAll(() => const LoginSignupScreen(isSignup: false));
    } else {
      Get.snackbar("Error", response?['message'] ?? "Failed to reset password");
    }
  }
}
