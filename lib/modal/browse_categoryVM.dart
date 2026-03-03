import 'package:flutter/material.dart';

class BrowseCategoryVM {
  final String? key;
  final String id;
  final String title;
  final String? assetImage;
  final String subtitle;
  final IconData? icon;
  final Color tint;

  const BrowseCategoryVM({
    this.key,
    required this.id,
    required this.title,
    required this.subtitle,
    this.icon,
    this.assetImage,
    required this.tint,
  });
}

// 1) browse_listing_vm.dart
class BrowseListingVM {
  final String id;
  final String title;
  final String price;
  final String location;
  final String category;
  final String imageUrl;
  final List<String> gallery; // for detail carousel
  final bool featured;

  // optional detail fields
  final String condition; // e.g. Negotiable
  final String trim; // e.g. Super GL
  final String fuel; // e.g. Dsl
  final String transmission; // e.g. Automatic
  final String description;

  BrowseListingVM({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.category,
    required this.imageUrl,
    required this.gallery,
    this.featured = false,
    this.condition = 'Negotiable',
    this.trim = 'Super GL',
    this.fuel = 'Dsl',
    this.transmission = 'Automatic',
    this.description = '',
  });
}
