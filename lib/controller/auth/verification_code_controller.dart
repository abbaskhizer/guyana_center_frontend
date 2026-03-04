import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationCodeController extends GetxController {
  final pinCtrl = TextEditingController();
  final focusNode = FocusNode();

  final secondsLeft = 14.obs;
  Timer? _timer;

  final email =
      "alex@example.com"; // pass this from previous screen if you want

  @override
  void onInit() {
    super.onInit();
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

  void resendCode() {
    if (secondsLeft.value != 0) return;
    Get.snackbar("Sent", "Verification code resent (demo)");
    _startTimer();
  }

  void verifyCode() {
    final code = pinCtrl.text.trim();
    if (code.length != 6) {
      Get.snackbar("Invalid code", "Please enter the 6-digit code");
      return;
    }
    Get.snackbar("Success", "Code verified (demo)");
  }
}
