import 'package:flutter/material.dart';
import 'package:get/get.dart';



import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/services/firebase_auth_service.dart';

class LoginSignupController extends GetxController {
  // mode
  final isLogin = true.obs;

  // visibility
  final isPasswordHidden = true.obs;
  final isConfirmHidden = true.obs;

  // signup extras
  final agreedToTerms = false.obs;

  // loading state
  final isLoading = false.obs;

  // controllers
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      if (args.containsKey('email')) {
        emailCtrl.text = args['email'] ?? "";
      }
      if (args.containsKey('isLogin')) {
        isLogin.value = args['isLogin'] ?? true;
      }
    } else if (args is String) {
      emailCtrl.text = args;
    }
  }

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
      Get.snackbar("Invalid password", "Password must be at least 6 characters");
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
        Get.snackbar("Terms required", "Please agree to the Terms & Privacy Policy");
        return;
      }
    }

    isLoading.value = true;

    if (isLogin.value) {
      final response = await ApiService.login(email, pass);
      isLoading.value = false;
      if (response != null && response.containsKey('accessToken')) {
        final userData = response['user'] as Map<String, dynamic>?;
        AuthService.to.onLoginSuccess(
          response['accessToken'], 
          email,
          id: userData?['id'],
          name: userData?['name'],
          phone: userData?['phone'],
        );
        Get.offAllNamed('/home');
      } else {
        Get.snackbar("Error", response?['message'] ?? "Login failed");
      }
    } else {
      final name = fullNameCtrl.text.trim();
      final response = await ApiService.signup(email, pass, name: name);
      isLoading.value = false;
      if (response != null && response.containsKey('message') && !response.containsKey('error')) {
        Get.snackbar("Success", response['message']);
        Get.toNamed('/verification', arguments: email);
      } else {
        Get.snackbar("Error", response?['message'] ?? "Registration failed");
      }
    }
  }

  void continueWithGoogle() async {
    await FirebaseAuthService.to.handleGoogleSignIn();
  }

  void continueWithFacebook() async {
    await FirebaseAuthService.to.handleFacebookSignIn();
  }

  void forgotPassword() {
    Get.toNamed('/forgot-password');
  }
}
