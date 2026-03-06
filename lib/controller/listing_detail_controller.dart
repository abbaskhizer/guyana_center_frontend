import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';

class ListingDetailController extends GetxController {
  late final BrowseListingVM item;

  final currentImage = 0.obs;
  final isFav = false.obs;

  final highlights = const <String>[
    'Fully serviced with soft close doors',
    '27 inch rims dry, slightly lowered',
    'Can be sold with or without music system',
  ];

  final musicSystemIncludes = const <String>[
    '12" Hifonics subwoofers (x2) + 15" EVs (2) housed box',
    '2K TPL 4-channel amps Class D',
    'TBC proline Power Cable + Apple 3 aluminium insert amp',
    'TBC proline DSP + 4x4 Midway',
  ];

  final batterySystem = const <String>[
    '1 Headunit (Pioneer 7600) Class D + Blockbake V15SE',
    '2x HJ Power SP120 + 2x Shakard Safeway 0/1W',
  ];

  @override
  void onInit() {
    super.onInit();
    item = Get.arguments as BrowseListingVM;
  }

  void setImage(int i) {
    currentImage.value = i;
  }

  void prev() {
    currentImage.value = (currentImage.value - 1).clamp(
      0,
      item.gallery.length - 1,
    );
  }

  void next() {
    currentImage.value = (currentImage.value + 1).clamp(
      0,
      item.gallery.length - 1,
    );
  }

  void toggleFav() {
    isFav.value = !isFav.value;
  }
}
