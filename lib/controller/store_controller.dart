import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/storeVm.dart';

class StoresController extends GetxController {
  static const String filterAll = "all";

  final searchCtrl = TextEditingController();
  final selectedFilter = filterAll.obs;
  final query = "".obs;

  final filters = const [
    StoreFilter(key: "vehicles", label: "Vehicles", count: 71),
    StoreFilter(key: "real_estate", label: "Real estate", count: 461),
    StoreFilter(key: "jobs", label: "Jobs", count: 1),
    StoreFilter(key: "electronics", label: "Electronics", count: 10),
    StoreFilter(key: "fashion", label: "Fashion", count: 6),
    StoreFilter(key: "home", label: "Home & Furniture", count: 12),
  ];

  final stores = <StoreVM>[
    StoreVM(
      name: "Stefan Ramjit",
      subtitle: "Interested in Buying, Selling or Renting? Contact us today...",
      location: "North East",
      ads: "20 ads",
      categoryKey: "vehicles",
      avatarUrl: "https://picsum.photos/id/1/200",
      verified: true,
    ),
    StoreVM(
      name: "Pride & Property",
      subtitle: "We offer comprehensive real estate services...",
      location: "North East",
      ads: "17 ads",
      categoryKey: "real_estate",
      avatarUrl: "https://picsum.photos/id/2/200",
      verified: true,
    ),
    StoreVM(
      name: "AutoMax Trinidad",
      subtitle: "Your trusted source for quality pre-owned vehicles...",
      location: "Central",
      ads: "45 ads",
      categoryKey: "vehicles",
      avatarUrl: "https://picsum.photos/id/3/200",
      verified: true,
    ),
  ].obs;

  List<StoreVM> get visibleStores => stores.where((s) {
    final filterOk = selectedFilter.value == filterAll
        ? true
        : s.categoryKey == selectedFilter.value;

    final searchOk =
        query.value.isEmpty ||
        s.name.toLowerCase().contains(query.value.toLowerCase());

    return filterOk && searchOk;
  }).toList();

  void setFilter(String key) => selectedFilter.value = key;

  void onSearchChanged(String v) => query.value = v;

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
