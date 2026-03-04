// listing_detail_controller.dart
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';

class ListingDetailController extends GetxController {
  late final BrowseListingVM item;

  final currentImage = 0.obs;
  final isFav = false.obs;

  @override
  void onInit() {
    super.onInit();
    item = Get.arguments as BrowseListingVM;
  }

  void setImage(int i) => currentImage.value = i;
  void prev() => currentImage.value = (currentImage.value - 1).clamp(
    0,
    item.gallery.length - 1,
  );
  void next() => currentImage.value = (currentImage.value + 1).clamp(
    0,
    item.gallery.length - 1,
  );

  void toggleFav() => isFav.value = !isFav.value;
}
