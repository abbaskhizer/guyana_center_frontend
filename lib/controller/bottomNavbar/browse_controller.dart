import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';

class BrowseController extends GetxController {
  final searchText = ''.obs;

  final chips = <String>['All', 'Vehicles'].obs;
  final activeChip = 0.obs;

  final isGrid = true.obs;
  final sortLabel = 'Sort'.obs;
  final forceEmptyState = false.obs;

  final listings = <BrowseListingVM>[].obs;

  final popularSearches = const <String>[
    'Toyota Hilux 2024',
    'Apartment for Rent',
    'iPhone 15 Pro Max',
    'Office Furniture Set',
    'BMW 3 Series',
  ];

  String defaultSearchHint(bool web) =>
      web ? '2BR House POS' : 'JBB House FOEx';

  bool get hasQuery => searchText.value.trim().isNotEmpty;

  String displayQuery(bool web) {
    final value = searchText.value.trim();
    return value.isEmpty ? defaultSearchHint(web) : value;
  }

  String get emptyStateTitleQuery {
    final value = searchText.value.trim();
    return value.isEmpty ? 'Search' : value;
  }

  @override
  void onInit() {
    super.onInit();
    listings.assignAll(_seed());
  }

  void setSearch(String value) {
    searchText.value = value.trimLeft();
  }

  void clearSearch() {
    searchText.value = '';
    forceEmptyState.value = false;
  }

  void setChip(int index) {
    if (index < 0 || index >= chips.length) return;
    activeChip.value = index;
  }

  void toggleView() {
    isGrid.value = !isGrid.value;
  }

  void setGridView() {
    isGrid.value = true;
  }

  void setListView() {
    isGrid.value = false;
  }

  void setSort(String label) {
    sortLabel.value = label;
  }

  List<BrowseListingVM> get filtered {
    final query = searchText.value.trim().toLowerCase();
    final chip = chips[activeChip.value].toLowerCase();

    bool chipFilter(BrowseListingVM item) {
      if (chip == 'all') return true;
      return item.category.toLowerCase() == chip;
    }

    final base = listings.where(chipFilter);

    if (query.isEmpty) return base.toList();

    return base.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
    }).toList();
  }

  bool get showEmptyState =>
      forceEmptyState.value || (hasQuery && filtered.isEmpty);

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
