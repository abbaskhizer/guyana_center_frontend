import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:flutter/material.dart';

/// Lightweight singleton that tracks authentication state across the app.
class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final _storage = const FlutterSecureStorage();
  final isLoggedIn = false.obs;

  final accessToken = "".obs;
  final userEmail = RxnString();
  final userName = RxnString();
  final userPhone = RxnString();
  final userId = RxnInt();
  final userPhotoUrl = RxnString();
  final isVerified = false.obs;
  final loginMethod = "email".obs; // "email", "google", "facebook"

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: 'jwt_token');

    if (token != null) {
      // Very basic local restore before backend validation
      accessToken.value = token;

      // Load saved login method
      final savedLoginMethod = await _storage.read(key: 'login_method');
      if (savedLoginMethod != null) {
        loginMethod.value = savedLoginMethod;
      }

      // Let's ask the backend if the token is STILL valid
      final response = await ApiService.checkAuthStatus(token);
      print('Auth check response: $response');
      if (response != null && !response.containsKey('error')) {
        // Token is good! Backend returned user info
        userEmail.value = response['email'];
        userName.value = response['name']; // Load real name from backend
        userPhone.value = response['phone']; // Load phone from backend
        userId.value = response['id']; // Load user ID
        userPhotoUrl.value = response['photoUrl'] ?? response['photoURL']; // Load photo URL from backend
        isVerified.value = response['isVerified'] ?? false; // Load verification status
        isLoggedIn.value = true;
        print('User logged in: ${userName.value} <${userEmail.value}> photoUrl: ${userPhotoUrl.value}, loginMethod: ${loginMethod.value}');
      } else {
        // Token expired/invalid — log them out locally
        print('Token invalid, logging out');
        await logout();
      }
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> onLoginSuccess(String token, String email, {int? id, String? name, String? phone, bool verified = true, String? loginMethod}) async {
    print('onLoginSuccess called with: email=$email, name=$name, id=$id');
    accessToken.value = token;
    userEmail.value = email;
    userName.value = name;
    userPhone.value = phone;
    userId.value = id;
    isVerified.value = verified;
    isLoggedIn.value = true;
    if (loginMethod != null) {
      this.loginMethod.value = loginMethod;
      // Save login method to secure storage
      await _storage.write(key: 'login_method', value: loginMethod);
    }

    await _storage.write(key: 'jwt_token', value: token);

    // Fetch full user profile from backend to ensure we have all data
    try {
      final profile = await ApiService.checkAuthStatus(token);
      print('Profile after login: $profile');
      if (profile != null && !profile.containsKey('error')) {
        userEmail.value = profile['email'] ?? userEmail.value;
        userName.value = profile['name'] ?? userName.value;
        userPhone.value = profile['phone'] ?? userPhone.value;
        userId.value = profile['id'] ?? userId.value;
        userPhotoUrl.value = profile['photoUrl'] ?? profile['photoURL'];
        isVerified.value = profile['isVerified'] ?? verified;
        print('Profile updated: ${userName.value} <${userEmail.value}> photoUrl: ${userPhotoUrl.value}');
      }
    } catch (e) {
      print('Failed to fetch user profile after login: $e');
    }
  }

  Future<void> logout() async {
    accessToken.value = "";
    userEmail.value = null;
    userName.value = null;
    userPhone.value = null;
    userId.value = null;
    userPhotoUrl.value = null;
    isVerified.value = false;
    isLoggedIn.value = false;
    loginMethod.value = "email";

    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'login_method');
  }

  void showLoginPrompt() {
    Get.snackbar(
      "Login Required",
      "Please login to access this feature.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFEF4444), // red-500
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      mainButton: TextButton(
        onPressed: () {
          if (Get.isSnackbarOpen) Get.back();
          Get.toNamed('/login');
        },
        child: const Text(
          "LOGIN",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
