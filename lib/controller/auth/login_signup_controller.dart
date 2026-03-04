import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/auth/forgot_password_screen.dart';

class LoginSignupController extends GetxController {
  // mode
  final isLogin = true.obs;

  // visibility
  final isPasswordHidden = true.obs;
  final isConfirmHidden = true.obs;

  // signup extras
  final agreedToTerms = false.obs;

  // controllers
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  void onClose() {
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }

  void toggleMode(bool login) {
    isLogin.value = login;

    // Optional: clear signup-only fields when switching to login
    if (login) {
      fullNameCtrl.clear();
      confirmCtrl.clear();
      agreedToTerms.value = false;
    }
  }

  void togglePassword() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirm() => isConfirmHidden.value = !isConfirmHidden.value;

  void toggleTerms(bool? v) => agreedToTerms.value = v ?? false;

  bool _isValidEmail(String email) {
    // simple validator; replace with stricter regex if you want
    return email.isNotEmpty && email.contains('@') && email.contains('.');
  }

  Future<void> submit() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    if (!_isValidEmail(email)) {
      Get.snackbar("Invalid email", "Please enter a valid email address");
      return;
    }
    if (pass.length < 6) {
      Get.snackbar(
        "Invalid password",
        "Password must be at least 6 characters",
      );
      return;
    }

    if (!isLogin.value) {
      final name = fullNameCtrl.text.trim();
      final confirm = confirmCtrl.text;

      if (name.isEmpty || name.length < 2) {
        Get.snackbar("Invalid name", "Please enter your full name");
        return;
      }
      if (confirm != pass) {
        Get.snackbar("Password mismatch", "Passwords do not match");
        return;
      }
      if (!agreedToTerms.value) {
        Get.snackbar(
          "Terms required",
          "Please agree to the Terms & Privacy Policy",
        );
        return;
      }
    }

    // DEMO actions (replace with your API calls)
    if (isLogin.value) {
      Get.snackbar("Success", "Logged in (demo)");
    } else {
      Get.snackbar("Success", "Account created (demo)");
    }
  }

  void continueWithGoogle() {
    Get.snackbar("Google", "Continue with Google (demo)");
  }

  void continueWithFacebook() {
    Get.snackbar("Facebook", "Continue with Facebook (demo)");
  }

  void forgotPassword() {
    Get.to(() => const ForgotPasswordScreen());
  }
}
