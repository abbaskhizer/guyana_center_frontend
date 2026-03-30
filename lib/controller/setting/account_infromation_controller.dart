import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:path/path.dart' as path;

class AccountController extends GetxController {
  // Account info
  final fullName = "".obs;
  final email = "".obs;
  final phone = "".obs;

  final emailVerified = false.obs;
  final phoneVerified = false.obs;

  // Connected accounts
  final googleConnected = false.obs;
  final googleEmail = "".obs;

  final facebookConnected = false.obs;

  // Track login method
  final loginMethod = "email".obs; // "email", "google", "facebook"

  // Membership
  final planName = "Pro Digital Plan".obs;
  final planDesc = "Unlimited pins ·Priority \nsupport".obs;
  final planPrice = "\$20/mo".obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();

    // Web load latency fix: Listen for AuthService updates
    ever(AuthService.to.userName, (_) => _loadUserData());
    ever(AuthService.to.userEmail, (_) => _loadUserData());
    ever(AuthService.to.userPhone, (_) => _loadUserData());
  ever(AuthService.to.userPhotoUrl, (_) => _loadUserData()); // Listen for photo updates
    ever(AuthService.to.isVerified, (_) => _loadUserData());
  }

  void _loadUserData() {
    fullName.value = AuthService.to.userName.value ?? "User";
    email.value = AuthService.to.userEmail.value ?? "Not provided";
    phone.value = AuthService.to.userPhone.value ?? "Not provided";
    emailVerified.value = AuthService.to.isVerified.value;
    loginMethod.value = AuthService.to.loginMethod.value;

    // Set connected accounts based on login method
    if (loginMethod.value == 'google') {
      googleConnected.value = true;
      googleEmail.value = email.value;
    } else if (loginMethod.value == 'facebook') {
      facebookConnected.value = true;
    } else {
      googleConnected.value = false;
      facebookConnected.value = false;
    }
  }

  // Actions
  void editField({
    required String title,
    required RxString field,
    required String currentValue,
  }) async {
    final result = await Get.dialog<String>(
      _EditDialog(title: title, initialValue: currentValue == "Not provided" ? "" : currentValue),
    );

    if (result != null && result.trim().isNotEmpty && result != currentValue) {
      // Call API to update
      final token = AuthService.to.accessToken.value;
      if (token.isEmpty) return;

      Map<String, dynamic> updateData = {};
      if (title == "Full Name") updateData["name"] = result.trim();
      if (title == "Phone") updateData["phone"] = result.trim();

      if (updateData.isEmpty) return;

      final response = await ApiService.updateProfile(token, updateData);

      if (response != null && !response.containsKey('error')) {
        field.value = result.trim();
        // Update AuthService state too so it persists across other screens
        if (title == "Full Name") AuthService.to.userName.value = result.trim();
        if (title == "Phone") AuthService.to.userPhone.value = result.trim();

        Get.snackbar("Success", "$title updated");
      } else {
        Get.snackbar("Error", response?['message'] ?? "Failed to update $title");
      }
    }
  }

  void connectGoogle() {
    googleConnected.value = true;
    Get.snackbar("Google", "Connected (demo)");
  }

  void disconnectGoogle() {
    googleConnected.value = false;
    Get.snackbar("Google", "Disconnected (demo)");
  }

  void connectFacebook() {
    facebookConnected.value = true;
    Get.snackbar("Facebook", "Connected (demo)");
  }

  void disconnectFacebook() {
    facebookConnected.value = false;
    Get.snackbar("Facebook", "Disconnected (demo)");
  }

  void deleteAccount() async {
    final theme = Get.theme;
    final cs = theme.colorScheme;

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete account?"),
        content: const Text(
          "Once deleted, all your data will be permanently lost. This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
            ),
            child: const Text("Delete Permanently"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final token = AuthService.to.accessToken.value;
      if (token.isEmpty) return;

      final response = await ApiService.deleteAccount(token);

      if (response != null && !response.containsKey('error')) {
        Get.snackbar("Deleted", "Your account has been permanently removed.");

        // Finalize logout and clear state
        await AuthService.to.logout();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Error", response?['message'] ?? "Failed to delete account");
      }
    }
  }

  // Profile photo methods
  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    // Show action sheet to choose source
    final source = await Get.bottomSheet<ImageSource>(
      Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose Photo Source",
              style: Get.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => Get.back(result: ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Take Photo"),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Get.theme.colorScheme.outlineVariant),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => Get.back(result: ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text("Choose from Gallery"),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Get.theme.colorScheme.outlineVariant),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    if (source == null) return;

    XFile? pickedFile;
    if (source == ImageSource.camera) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      final token = AuthService.to.accessToken.value;
      if (token.isEmpty) {
        Get.snackbar("Error", "Please login first",
          snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Show loading
      Get.snackbar(
        "Uploading",
        "Please wait while we upload your photo...",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      try {
        // Upload the photo to the backend
        final response = await ApiService.uploadProfilePhoto(
          token,
          pickedFile.path,
        );

        if (response != null && !response.containsKey('error')) {
          // Update the photo URL in AuthService with the server path
          final photoUrl = response['photoUrl'];
          AuthService.to.userPhotoUrl.value = photoUrl;

          Get.snackbar("Success", "Profile photo updated",
            snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar("Error", response?['message'] ?? "Failed to upload photo",
            snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to upload photo: $e",
          snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> removeProfileImage() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Remove photo?"),
        content: const Text("Are you sure you want to remove your profile photo?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.error,
              foregroundColor: Get.theme.colorScheme.onError,
            ),
            child: const Text("Remove"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final token = AuthService.to.accessToken.value;
      if (token.isEmpty) {
        Get.snackbar("Error", "Please login first",
          snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Update profile to remove photo URL
      final response = await ApiService.updateProfile(
        token,
        {'photoUrl': null},
      );

      if (response != null && !response.containsKey('error')) {
        AuthService.to.userPhotoUrl.value = null;
        Get.snackbar("Success", "Profile photo removed",
          snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", response?['message'] ?? "Failed to remove photo",
          snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}

/// Small edit dialog widget
class _EditDialog extends StatelessWidget {
  const _EditDialog({required this.title, required this.initialValue});

  final String title;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController(text: initialValue);

    return AlertDialog(
      title: Text("Edit $title"),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => Get.back(result: ctrl.text),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () => Get.back(result: ctrl.text),
          child: const Text("Save"),
        ),
      ],
    );
  }
}
