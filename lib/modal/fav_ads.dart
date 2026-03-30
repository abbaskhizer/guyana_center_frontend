class BrowseAdsItem {
  final String imageUrl;
  final String category;
  final String title;
  final String price;
  final String location;
  final String time;
  final String? rating;
  final bool featured;

  const BrowseAdsItem({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.price,
    required this.location,
    required this.time,
    this.rating,
    this.featured = false,
  });
}
