import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';

class BrowseAdsListingScreen extends StatelessWidget {
  const BrowseAdsListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // top bar like screenshot
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Search Saved Items",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  Icon(Icons.notifications_none_rounded, color: cs.onSurface),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: cs.primary.withOpacity(.12),
                    child: Icon(Icons.person, color: cs.primary, size: 16),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search saved items...",
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: cs.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // filter row
            SizedBox(
              height: 36,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(text: "All", active: true),
                  const SizedBox(width: 10),
                  _FilterChip(text: "Vehicles"),
                  const SizedBox(width: 10),
                  _FilterChip(text: "Real estate"),
                  const SizedBox(width: 10),
                  _FilterChip(text: "Jobs"),
                  const SizedBox(width: 10),
                  _FilterChip(text: "Electronics"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // cards list (demo)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: const [
                  _AdCard(
                    title: "A&T Toyota Camry 98",
                    price: "\$14,500",
                    location: "Chaguanas",
                    imageUrl: "https://picsum.photos/600?random=41",
                  ),
                  SizedBox(height: 12),
                  _AdCard(
                    title: "Modern Studio Apartment",
                    price: "\$1,200/m",
                    location: "Port of Spain",
                    imageUrl: "https://picsum.photos/600?random=42",
                  ),
                  SizedBox(height: 12),
                  _AdCard(
                    title: "MacBook Pro M1",
                    price: "\$7,199",
                    location: "San Fernando",
                    imageUrl: "https://picsum.photos/600?random=43",
                  ),
                  SizedBox(height: 12),
                  _AdCard(
                    title: "Canon 80D DSLR Camera",
                    price: "\$2,600",
                    location: "Central",
                    imageUrl: "https://picsum.photos/600?random=44",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String text;
  final bool active;
  const _FilterChip({required this.text, this.active = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? cs.primary.withOpacity(.10) : cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: active ? cs.primary : cs.outlineVariant),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 12,
          color: active ? cs.primary : cs.onSurface.withOpacity(.65),
        ),
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  final String title;
  final String price;
  final String location;
  final String imageUrl;

  const _AdCard({
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: cs.surface.withOpacity(.9),
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 18,
                      color: Color(0xFFFF5A5A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: cs.onSurface.withOpacity(.45),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface.withOpacity(.55),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      price,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
