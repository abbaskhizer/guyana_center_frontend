class ListingVM {
  final String categoryId;
  final String subType;
  final String title;
  final String price;
  final String location;
  final String imageUrl;
  final String? badge;
  final String timeAgo;

  const ListingVM({
    required this.categoryId,
    required this.subType,
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    this.badge,
    this.timeAgo = "1 day ago",
  });
}
