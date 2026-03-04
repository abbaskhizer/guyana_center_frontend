enum FavTab { ads, searches }

class FavItemVM {
  final String title;
  final String price;
  final String location;
  final String imageUrl;
  final String badge; // e.g. "New", "Urgent"
  final bool featured;

  FavItemVM({
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    this.badge = "New",
    this.featured = false,
  });
}

class SavedSearchVM {
  final String title; // e.g. "Apartment"
  final String subtitle; // e.g. "Vehicles 1"
  final String query; // e.g. "Used"
  final String location; // e.g. "Trinidad"

  SavedSearchVM({
    required this.title,
    required this.subtitle,
    required this.query,
    required this.location,
  });
}
