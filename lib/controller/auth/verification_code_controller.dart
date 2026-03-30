import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/auth/login_signup_controller.dart';
import 'package:guyana_center_frontend/services/api_services.dart';


class VerificationCodeController extends GetxController {
  final pinCtrl = TextEditingController();
  final focusNode = FocusNode();

  final secondsLeft = 14.obs;
  Timer? _timer;

  late String email;
  bool isPasswordReset = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      email = args['email'] ?? "example@email.com";
      isPasswordReset = args['isPasswordReset'] ?? false;
    } else if (args is String) {
      email = args;
    } else {
      email = "example@email.com";
    }
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pinCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void _startTimer() {
    _timer?.cancel();
    secondsLeft.value = 14;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value <= 1) {
        t.cancel();
        secondsLeft.value = 0;
      } else {
        secondsLeft.value--;
      }
    });
  }

  Future<void> resendCode() async {
    if (secondsLeft.value != 0) {
      Get.snackbar("Hold on", "Please wait for the timer to finish before resending.");
      return;
    }

    final response = isPasswordReset
        ? await ApiService.forgotPassword(email)
        : await ApiService.resendOtp(email);

    if (response != null && response.containsKey('message') && !response.containsKey('error')) {
      Get.snackbar("Success", "New verification code sent!");
      _startTimer();
    } else {
      Get.snackbar("Error", response?['message'] ?? "Resend failed");
    }
  }

  Future<void> verifyCode() async {
    final code = pinCtrl.text.trim();
    if (code.length != 6) {
      Get.snackbar("Invalid code", "Please enter the 6-digit code");
      return;
    }

    if (isPasswordReset) {
      // For reset, we just navigate to the next screen holding the email and OTP
      Get.toNamed('/reset-password', arguments: {'email': email, 'otp': code});
      return;
    }

    final response = await ApiService.verifyOtp(email, code);
    if (response != null && response.containsKey('message') && !response.containsKey('error')) {
      Get.snackbar("Success", "Account verified! Please log in.");
      // Delete old LoginSignupController to ensure fresh controllers on login screen
      Get.delete<LoginSignupController>(force: true);
      // Navigate to login with arguments
      Get.offNamed('/login', arguments: {'email': email, 'isLogin': true});
    } else {
      Get.snackbar("Error", response?['message'] ?? "Verification failed");
    }
  }
}
