import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';

class AllCategoryController extends GetxController {
  final search = ''.obs;
  final expandedId = ''.obs;

  final categories = <BrowseCategoryVM>[].obs;

  void setCategories(List<BrowseCategoryVM> list) {
    categories.assignAll(list);
  }

  void setSearch(String v) => search.value = v;

  List<BrowseCategoryVM> get filtered {
    final q = search.value.trim().toLowerCase();
    if (q.isEmpty) return categories.toList();

    return categories.where((c) {
      final t = (c.title).toLowerCase();
      final s = (c.subtitle).toLowerCase();
      return t.contains(q) || s.contains(q);
    }).toList();
  }

  bool isExpanded(String id) => expandedId.value == id;

  void toggleExpanded(String id) {
    expandedId.value = expandedId.value == id ? '' : id;
  }
}
