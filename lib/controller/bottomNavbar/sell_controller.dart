import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/add_categoryVM.dart';

enum ContactMethod { chat, call }

class SellController extends GetxController {
  // steps: 1,2,3
  final step = 1.obs;

  final categories = <AddCategory>[
    const AddCategory("Vehicles", "assets/van.png"),
    const AddCategory("Real Estate", "assets/re.png"),
    const AddCategory("Electronics", "assets/com.png"),
    const AddCategory("Businesses", "assets/b.png"),
    const AddCategory("Fashion", "assets/shirt.png"),
    const AddCategory("Home &\nGarden", "assets/f.png"),
    const AddCategory("Services", "assets/s.png"),
    const AddCategory("Other", "assets/more.png"),
  ];

  final selectedCategory = 0.obs;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final descCount = 0.obs;

  final conditionIndex = 0.obs;
  static const int maxDesc = 500;

  final images = <String>[].obs;
  final priceCtrl = TextEditingController();
  final negotiable = false.obs;

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

  void selectCategoryIndex(int i) => selectedCategory.value = i;
  void setCondition(int i) => conditionIndex.value = i.clamp(0, 2);

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
