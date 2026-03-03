import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';

class BrowseListingController extends GetxController {
  late BrowseCategoryVM category;

  final listingsCount = "12 400+".obs;
  final updated = "248".obs;
  final rating = "4.8".obs;

  final chips = <String>[].obs;
  final chipIndex = 0.obs;

  final search = "".obs;
  final sort = "Newest".obs;
  final isGrid = true.obs;
  final sorts = const ["Newest", "Price: Low", "Price: High"];

  final currentPage = 1.obs;
  final totalPages = 1.obs;

  final pageSize = 6;

  final allListings = <ListingVM>[
    const ListingVM(
      categoryId: "vehicles",
      subType: "Cars for Sale",
      title: "Toyota Hilux 2024",
      price: "\$185,000",
      location: "Los Angeles, CA",
      badge: "Sale",
      timeAgo: "1 day ago",
      imageUrl:
          "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg",
    ),
    const ListingVM(
      categoryId: "vehicles",
      subType: "Trucks & Vans",
      title: "Nissan Juke 2023",
      price: "\$120,000",
      location: "Charlotte, NY",
      badge: "New",
      timeAgo: "2 days ago",
      imageUrl:
          "https://images.pexels.com/photos/358070/pexels-photo-358070.jpeg",
    ),
    const ListingVM(
      categoryId: "vehicles",
      subType: "Cars for Sale",
      title: "Toyota Aqua 2019",
      price: "\$95,500",
      location: "Atlanta, GA",
      badge: "Sale",
      timeAgo: "3 days ago",
      imageUrl:
          "https://images.pexels.com/photos/120049/pexels-photo-120049.jpeg",
    ),
    const ListingVM(
      categoryId: "vehicles",
      subType: "Motorcycles",
      title: "Nissan Frontier 2021",
      price: "\$170,000",
      location: "San Diego, CA",
      badge: "New",
      timeAgo: "1 day ago",
      imageUrl:
          "https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg",
    ),
    const ListingVM(
      categoryId: "vehicles",
      subType: "Cars for Sale",
      title: "Nissan Qashqai 2020",
      price: "\$105,000",
      location: "Dallas, TX",
      timeAgo: "4 days ago",
      imageUrl:
          "https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg",
    ),
    const ListingVM(
      categoryId: "vehicles",
      subType: "Trucks & SUVs",
      title: "Toyota Corolla 18",
      price: "\$140,000",
      location: "San Jose, CA",
      timeAgo: "5 days ago",
      imageUrl:
          "https://images.pexels.com/photos/244206/pexels-photo-244206.jpeg",
    ),
  ].obs;

  void initWithCategory(BrowseCategoryVM cat) {
    category = cat;

    final source = cat.id == "all"
        ? allListings.toList()
        : allListings.where((e) => e.categoryId == cat.id).toList();

    final set = <String>{"All"};
    for (final x in source) {
      set.add(x.subType);
    }

    chips.value = set.toList();
    chipIndex.value = 0;

    search.value = "";
    sort.value = "Newest";
    isGrid.value = true;

    currentPage.value = 1;

    listingsCount.value = "${source.length}+";
    updated.value = "24h";
    rating.value = "4.8";

    _recalcPages();
  }

  void _recalcPages() {
    final total = _applyAllFiltersOnly().length;
    totalPages.value = (total / pageSize).ceil().clamp(1, 999);
    if (currentPage.value > totalPages.value) {
      currentPage.value = totalPages.value;
    }
  }

  void setChip(int i) {
    if (i < 0 || i >= chips.length) return;
    chipIndex.value = i;
    currentPage.value = 1;
    _recalcPages();
  }

  void setSearch(String v) {
    search.value = v;
    currentPage.value = 1;
    _recalcPages();
  }

  void setSort(String v) {
    sort.value = v;
    currentPage.value = 1;
  }

  void toggleView() => isGrid.value = !isGrid.value;

  void goToPage(int p) {
    if (p < 1 || p > totalPages.value) return;
    currentPage.value = p;
  }

  int _priceToInt(String price) {
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  List<ListingVM> _applyAllFiltersOnly() {
    final q = search.value.trim().toLowerCase();
    final chip = chips.isEmpty ? "All" : chips[chipIndex.value];

    var list = category.id == "all"
        ? allListings.toList()
        : allListings.where((x) => x.categoryId == category.id).toList();

    if (chip != "All") {
      list = list.where((x) => x.subType == chip).toList();
    }

    if (q.isNotEmpty) {
      list = list
          .where(
            (x) =>
                x.title.toLowerCase().contains(q) ||
                x.location.toLowerCase().contains(q),
          )
          .toList();
    }

    if (sort.value == "Price: Low") {
      list.sort((a, b) => _priceToInt(a.price).compareTo(_priceToInt(b.price)));
    } else if (sort.value == "Price: High") {
      list.sort((a, b) => _priceToInt(b.price).compareTo(_priceToInt(a.price)));
    }

    return list;
  }

  List<ListingVM> get filteredListings {
    final list = _applyAllFiltersOnly();
    final start = (currentPage.value - 1) * pageSize;
    final end = (start + pageSize).clamp(0, list.length);
    if (start >= list.length) return [];
    return list.sublist(start, end);
  }

  int get totalFilteredCount => _applyAllFiltersOnly().length;
}
