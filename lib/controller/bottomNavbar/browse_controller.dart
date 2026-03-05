import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';

class BrowseController extends GetxController {
  final searchText = ''.obs;

  final chips = <String>['All', 'Vehicles'].obs;
  final activeChip = 0.obs;

  final isGrid = true.obs;
  final sortLabel = 'Sort'.obs;

  final listings = <BrowseListingVM>[].obs;

  // ✅ Figma style popular searches
  final popularSearches = <String>[
    'Toyota Hilux 2024',
    'Apartment for Rent',
    'iPhone 15 Pro Max',
    'Office Furniture Set',
    'BMW 3 Series',
  ];

  @override
  void onInit() {
    super.onInit();
    listings.assignAll(_seed());
  }

  void setSearch(String v) => searchText.value = v.trim();

  void clearSearch() => searchText.value = '';

  void setChip(int i) {
    if (i < 0 || i >= chips.length) return;
    activeChip.value = i;
  }

  void toggleView() => isGrid.value = !isGrid.value;

  List<BrowseListingVM> get filtered {
    final q = searchText.value.toLowerCase();
    final chip = chips[activeChip.value].toLowerCase();

    bool chipOk(BrowseListingVM x) =>
        chip == 'all' ? true : x.category.toLowerCase() == chip;

    final base = listings.where(chipOk);

    if (q.isEmpty) return base.toList();

    return base.where((x) {
      return x.title.toLowerCase().contains(q) ||
          x.location.toLowerCase().contains(q) ||
          x.category.toLowerCase().contains(q);
    }).toList();
  }

  bool get showEmptyState => searchText.value.isNotEmpty && filtered.isEmpty;

  List<BrowseListingVM> _seed() => [
    BrowseListingVM(
      id: '1',
      title: 'Toyota Hiace, 2014, TDW',
      price: '\$180,000',
      location: 'Port of Spain',
      category: 'Vehicles',
      imageUrl:
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200',
      gallery: [
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200',
        'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=1200',
        'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=1200',
        'https://images.unsplash.com/photo-1549924231-f129b911e442?w=1200',
      ],
      featured: true,
      description:
          'Toyota Hiace Super GL Gas. Not heavy T, inspected and ready for immediate transfer.\n\n• Fully powered\n• 27 rims, slightly lowered\n• Can be sold with or without music system',
    ),
    BrowseListingVM(
      id: '2',
      title: 'Toyota Hilux 2021 SR5',
      price: '\$165,000',
      location: 'San Fernando',
      category: 'Vehicles',
      imageUrl:
          'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=1200',
      gallery: [
        'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=1200',
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200',
      ],
      description: 'Clean condition, ready to go.',
    ),
  ];
}
