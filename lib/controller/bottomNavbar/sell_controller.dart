import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/add_categoryVM.dart';

enum ContactMethod { chat, call }

class SellController extends GetxController {
  // steps: 1,2,3
  final step = 1.obs;

  // ===== Step 1 =====
  final categories = <AddCategory>[
    const AddCategory("Vehicles", Icons.directions_car_filled_outlined),
    const AddCategory("Real Estate", Icons.home_work_outlined),
    const AddCategory("Electronics", Icons.electrical_services_outlined),
    const AddCategory("Businesses", Icons.storefront_outlined),
    const AddCategory("Fashion", Icons.checkroom_outlined),
    const AddCategory("Home &\nGarden", Icons.chair_outlined),
    const AddCategory("Services", Icons.handyman_outlined),
    const AddCategory("Other", Icons.more_horiz_rounded),
  ];

  final selectedCategory = 0.obs;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final descCount = 0.obs;

  final conditionIndex = 0.obs; // 0,1,2
  static const int maxDesc = 500;

  // ===== Step 2 =====
  final images = <String>[].obs; // urls/paths
  final priceCtrl = TextEditingController();
  final negotiable = false.obs;

  // ===== Step 3 =====
  final areas = const [
    "Port of Spain",
    "Chaguanas",
    "San Fernando",
    "Arima",
    "Couva",
    "Cunupia",
  ];
  final selectedArea = "Select your area".obs;

  final phoneCtrl = TextEditingController(text: "");
  final contactMethod = ContactMethod.chat.obs;

  @override
  void onInit() {
    super.onInit();

    descCtrl.addListener(() {
      final t = descCtrl.text;
      if (t.length > maxDesc) {
        descCtrl.text = t.substring(0, maxDesc);
        descCtrl.selection = TextSelection.collapsed(offset: maxDesc);
      }
      descCount.value = descCtrl.text.length;
    });
  }

  // ----- navigation -----
  void setStep(int s) => step.value = s.clamp(1, 3);

  void goBack() {
    if (step.value > 1) {
      step.value--;
    } else {
      Get.back();
    }
  }

  void continueNext() {
    if (step.value < 3) {
      step.value++;
      return;
    }
    Get.snackbar("Ready", "Post ad for free (demo)");
  }

  // ----- step 1 -----
  void selectCategoryIndex(int i) => selectedCategory.value = i;
  void setCondition(int i) => conditionIndex.value = i.clamp(0, 2);

  // ----- step 2 -----
  void addMockPhoto() {
    if (images.length >= 10) return;
    images.add(
      "https://picsum.photos/400?random=${DateTime.now().millisecondsSinceEpoch}",
    );
  }

  void removePhoto(int i) {
    if (i < 0 || i >= images.length) return;
    images.removeAt(i);
  }

  // ----- step 3 -----
  void setArea(String v) => selectedArea.value = v;
  void setContactMethod(ContactMethod m) => contactMethod.value = m;

  @override
  void onClose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
