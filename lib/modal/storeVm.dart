class StoreVM {
  final String name;
  final String subtitle;
  final String location;
  final String ads;
  final String categoryKey;
  final String avatarUrl;
  final bool verified;

  StoreVM({
    required this.name,
    required this.subtitle,
    required this.location,
    required this.ads,
    required this.categoryKey,
    required this.avatarUrl,
    required this.verified,
  });
}

class StoreFilter {
  final String key;
  final String label;
  final int? count;

  const StoreFilter({required this.key, required this.label, this.count});
}
