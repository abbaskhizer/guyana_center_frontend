import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWebDesktop = kIsWeb && screenWidth >= 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            // App-only header (shown on native app AND web mobile)
            if (!isWebDesktop) ...[
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.menu_rounded, color: cs.onSurface),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "GUYANACENTRAL",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            RichText(
              text: TextSpan(
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 28,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
                children: [
                  const TextSpan(text: "Find "),
                  TextSpan(
                    text: "Anything.\n",
                    style: TextStyle(color: cs.primary),
                  ),
                  const TextSpan(text: "Sell "),
                  const TextSpan(
                    text: "Everything.\n",
                    style: TextStyle(color: Color(0xFFFF8A00)),
                  ),
                  const TextSpan(text: "Pay Nothing."),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Buy and sell locally with ease. Take the simplest\n"
              "way to find and deal near you.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6B7280),
                height: 1.35,
                fontSize: 12.5,
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              decoration: InputDecoration(
                hintText: "Search for anything...",
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.search_rounded, size: 18),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            _SectionHeader(
              title: "Browse Categories",
              actionText: "See All",
              onTap: () {},
            ),
            const SizedBox(height: 10),

            Row(
              children: const [
                Expanded(
                  child: _CategoryCard(
                    icon: Icons.grid_view_rounded,
                    title: "All",
                    active: true,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _CategoryCard(
                    icon: Icons.videocam_rounded,
                    title: "Videos",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _CategoryCard(
                    icon: Icons.home_work_rounded,
                    title: "Property",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _CategoryCard(
                    icon: Icons.directions_car_filled_rounded,
                    title: "Cars",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _SectionHeader(
              title: "Featured Listings",
              actionText: "View All",
              onTap: () {},
            ),
            const SizedBox(height: 10),

            _ListingCard(
              badgeText: "Featured",
              badgeColor: cs.primary,
              title: "Toyota Land Cruiser 2022",
              location: "Georgetown",
              price: "\$45,000",
              image: const AssetImage("assets/images/car1.jpg"),
              onFav: () {},
            ),
            const SizedBox(height: 12),
            _ListingCard(
              badgeText: "Urgent",
              badgeColor: const Color(0xFFFF5A5A),
              title: "Mercedes-Benz C-Class",
              location: "East Bank",
              price: "\$38,500",
              image: const AssetImage("assets/images/car2.jpg"),
              onFav: () {},
            ),
            const SizedBox(height: 12),
            _ListingCard(
              badgeText: "New",
              badgeColor: const Color(0xFFFFB020),
              title: "BMW Steering Wheel Badge",
              location: "Georgetown",
              price: "\$120",
              image: const AssetImage("assets/images/parts.jpg"),
              onFav: () {},
            ),
            const SizedBox(height: 12),
            _ListingCard(
              badgeText: "New",
              badgeColor: const Color(0xFFFFB020),
              title: "Honda Civic Sport 2023",
              location: "Georgetown",
              price: "\$28,200",
              image: const AssetImage("assets/images/car3.jpg"),
              onFav: () {},
            ),

            const SizedBox(height: 18),

            _SectionHeader(
              title: "Popular Properties",
              actionText: "View All",
              onTap: () {},
            ),
            const SizedBox(height: 10),

            Row(
              children: const [
                Expanded(
                  child: _PropertyCard(
                    title: "Modern Villa with Pool",
                    price: "\$50,000",
                    image: AssetImage("assets/images/house1.jpg"),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _PropertyCard(
                    title: "Luxury Estate",
                    price: "\$1,200,000",
                    image: AssetImage("assets/images/house2.jpg"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: const [
                Expanded(
                  child: _StatChip(value: "50K+", label: "Listings"),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _StatChip(value: "100K+", label: "Users"),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _StatChip(value: "12", label: "Cities"),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _StatChip(value: "FREE", label: "Post Ads"),
                ),
              ],
            ),

            // Web desktop-only footer
            if (isWebDesktop) ...[
              const SizedBox(height: 40),
              const WebFooter(),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 14.5,
            color: cs.onSurface,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;

  const _CategoryCard({
    required this.icon,
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bg = active ? cs.primary.withOpacity(0.10) : cs.surface;
    final border = active
        ? cs.primary.withOpacity(0.25)
        : theme.dividerColor.withOpacity(0.35);

    final iconColor = active ? cs.primary : const Color(0xFF9AA3B2);
    final textColor = active ? cs.primary : const Color(0xFF6C768A);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: 6),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final String badgeText;
  final Color badgeColor;
  final String title;
  final String location;
  final String price;
  final ImageProvider image;
  final VoidCallback onFav;

  const _ListingCard({
    required this.badgeText,
    required this.badgeColor,
    required this.title,
    required this.location,
    required this.price,
    required this.image,
    required this.onFav,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image(image: image, fit: BoxFit.cover),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Material(
                    color: cs.surface.withOpacity(0.92),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onFav,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 18,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: Color(0xFF9AA3B2),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF6C768A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  price,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final String title;
  final String price;
  final ImageProvider image;

  const _PropertyCard({
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Image(image: image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;

  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withOpacity(0.22)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: cs.onSurface.withOpacity(0.55),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
