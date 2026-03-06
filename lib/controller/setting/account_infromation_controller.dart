import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  // Account info
  final fullName = "Nasha Montone".obs;
  final email = "nasha@email.com".obs;
  final phone = "+1 555-0123".obs;
  final license = "DL-1234567890".obs;
  final location = "San Jose, CA".obs;

  final emailVerified = true.obs;
  final phoneVerified = true.obs;

  // Connected accounts
  final googleConnected = true.obs;
  final googleEmail = "nasha.m@gmail.com".obs;

  final facebookConnected = false.obs;

  // Membership
  final planName = "Pro Digital Plan".obs;
  final planDesc = "Unlimited pins ·Priority \nsupport".obs;
  final planPrice = "\$20/mo".obs;

  // Actions
  void editField({
    required String title,
    required RxString field,
    required String currentValue,
  }) async {
    final result = await Get.dialog<String>(
      _EditDialog(title: title, initialValue: currentValue),
    );

    if (result != null && result.trim().isNotEmpty) {
      field.value = result.trim();
      Get.snackbar("Updated", "$title updated");
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
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete account?"),
        content: const Text(
          "Once deleted, all your data will be permanently lost.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Get.snackbar("Deleted", "Account deleted (demo)");
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
