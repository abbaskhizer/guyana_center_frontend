import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/home_tab_controller.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeTabController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebLayout(controller: controller)
            : _MobileLayout(controller: controller),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final HomeTabController controller;
  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      children: [
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

        const _HeroSection(web: false),

        const SizedBox(height: 18),

        _SectionHeader(
          title: "Browse Categories",
          actionText: "See All",
          onTap: () {},
        ),
        const SizedBox(height: 10),

        Obx(() {
          final list = controller.categories;
          final show = list.length >= 4 ? list.take(4).toList() : list.toList();
          return Row(
            children: List.generate(show.length, (i) {
              final item = show[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: i == show.length - 1 ? 0 : 10,
                  ),
                  child: _CategoryCard(
                    icon: item.icon,
                    title: item.title,
                    active: item.active,
                  ),
                ),
              );
            }),
          );
        }),

        const SizedBox(height: 18),

        _SectionHeader(
          title: "Featured Listings",
          actionText: "View All",
          onTap: () {},
        ),
        const SizedBox(height: 10),

        Obx(
          () => Column(
            children: controller.featuredListings
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ListingCard(item: item, onFav: () {}),
                  ),
                )
                .toList(),
          ),
        ),

        const SizedBox(height: 18),

        _SectionHeader(
          title: "Popular Properties",
          actionText: "View All",
          onTap: () {},
        ),
        const SizedBox(height: 10),

        const Row(
          children: [
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

        const Row(
          children: [
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

        const SizedBox(height: 24),
      ],
    );
  }
}

class _WebLayout extends StatelessWidget {
  final HomeTabController controller;
  const _WebLayout({required this.controller});

  int _catCols(double w) {
    if (w >= 1300) return 6;
    if (w >= 1100) return 5;
    return 4;
  }

  int _listingCols(double w) {
    if (w >= 1400) return 4;
    if (w >= 1100) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 18, 16, 10),
                      child: _HeroSection(web: true),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                      child: _SectionHeader(
                        title: "Browse Categories",
                        actionText: "See All",
                        onTap: () {},
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: Obx(
                      () => SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = controller.categories[index];
                          return _CategoryCard(
                            icon: item.icon,
                            title: item.title,
                            active: item.active,
                          );
                        }, childCount: controller.categories.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _catCols(w),
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.55,
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
                      child: _SectionHeader(
                        title: "Featured Listings",
                        actionText: "View All",
                        onTap: () {},
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: Obx(
                      () => SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = controller.featuredListings[index];
                          return _ListingCard(item: item, onFav: () {});
                        }, childCount: controller.featuredListings.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _listingCols(w),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.95,
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
                      child: _SectionHeader(
                        title: "Real Estate",
                        actionText: "View All",
                        onTap: () {},
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      delegate: SliverChildListDelegate(const [
                        _PropertyCard(
                          title: "Modern Villa with Pool",
                          price: "\$50,000",
                          image: AssetImage("assets/images/house1.jpg"),
                        ),
                        _PropertyCard(
                          title: "Luxury Estate",
                          price: "\$1,200,000",
                          image: AssetImage("assets/images/house2.jpg"),
                        ),
                        _PropertyCard(
                          title: "City Apartment",
                          price: "\$250,000",
                          image: AssetImage("assets/images/house1.jpg"),
                        ),
                      ]),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: w >= 1100 ? 3 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.15,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 18)),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
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
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 26)),

                  const SliverToBoxAdapter(child: WebFooter()),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool web;
  const _HeroSection({required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final headline = theme.textTheme.headlineSmall?.copyWith(
      fontSize: web ? 44 : 28,
      height: 1.12,
      fontWeight: FontWeight.w900,
      color: cs.onSurface,
    );

    final subtitle = theme.textTheme.bodyMedium?.copyWith(
      color: const Color(0xFF6B7280),
      height: 1.35,
      fontSize: web ? 14 : 12.5,
      fontWeight: FontWeight.w500,
    );

    final content = Column(
      crossAxisAlignment: web
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: web ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: headline,
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
        const SizedBox(height: 10),
        Text(
          "Buy and sell locally with ease. Take the simplest\nway to find and deal near you.",
          textAlign: web ? TextAlign.center : TextAlign.start,
          style: subtitle,
        ),
        const SizedBox(height: 18),

        SizedBox(
          width: web ? 560 : double.infinity,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search for anything...",
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(6),
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
        ),

        if (web) ...[
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: const [
              _ChipTab(text: "Home", active: true),
              _ChipTab(text: "Trending"),
              _ChipTab(text: "Cars"),
              _ChipTab(text: "Property"),
              _ChipTab(text: "Jobs"),
            ],
          ),
        ],
      ],
    );

    return web
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: content,
          )
        : content;
  }
}

class _ChipTab extends StatelessWidget {
  final String text;
  final bool active;
  const _ChipTab({required this.text, this.active = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? cs.primary.withOpacity(0.10) : cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? cs.primary.withOpacity(0.25)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? cs.primary : const Color(0xFF6B7280),
          fontWeight: FontWeight.w700,
          fontSize: 12,
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
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
  final ListingVM item;
  final VoidCallback onFav;

  const _ListingCard({required this.item, required this.onFav});

  Color _badgeColor(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final b = (item.badge ?? "New").toLowerCase();
    if (b == "urgent") return const Color(0xFFFF5A5A);
    if (b == "featured") return primary;
    return const Color(0xFFFFB020);
  }

  String _badgeText() => item.badge ?? "New";

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
                  child: Image(image: item.image, fit: BoxFit.cover),
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
                      color: _badgeColor(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _badgeText(),
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
                        item.title,
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
                            item.location,
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
                  item.price,
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
