import 'package:get/get.dart';

class PrivacyController extends GetxController {
  // Profile visibility
  final isPublic = true.obs;

  // Activity & Content
  final showActivityStatus = true.obs;
  final showSavedBoards = true.obs;
  final searchEngineIndexing = false.obs;

  // ✅ used by segmented control
  void setVisibility(bool v) => isPublic.value = v;
}
