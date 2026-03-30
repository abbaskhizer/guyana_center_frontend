enum FavTab { ads, searches }

class FavItemVM {
  final String title;
  final String price;
  final String location;
  final String imageUrl;
  final String badge;
  final bool featured;

  FavItemVM({
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    required this.badge,
    this.featured = false,
  });
}

class SavedSearchVM {
  final String title;
  final String subtitle;
  final String query;
  final String location;

  SavedSearchVM({
    required this.title,
    required this.subtitle,
    required this.query,
    required this.location,
  });
}
