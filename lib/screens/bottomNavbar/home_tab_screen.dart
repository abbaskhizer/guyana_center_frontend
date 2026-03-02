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
    final controller = Get.put(HomeTabController(), permanent: true);
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      children: [
        _TopBar(controller: controller),
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

        Obx(() {
          final props = controller.properties;
          final p1 = props.isNotEmpty ? props[0] : null;
          final p2 = props.length > 1 ? props[1] : null;

          return Row(
            children: [
              Expanded(
                child: p1 == null
                    ? const SizedBox()
                    : _PropertyCard(
                        title: p1.title,
                        price: p1.price,
                        image: p1.image,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: p2 == null
                    ? const SizedBox()
                    : _PropertyCard(
                        title: p2.title,
                        price: p2.price,
                        image: p2.image,
                      ),
              ),
            ],
          );
        }),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _StatChip(
                value: "50K+",
                label: "Active Listings",
                baseColor: cs.primary,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _StatChip(
                value: "100K+",
                label: "Happy Users",
                baseColor: Color(0xFFFF0000),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatChip(
                value: "12",
                label: "Categories",
                baseColor: cs.secondary,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: _StatChip(
                value: "FREE",
                label: "Always Free",
                baseColor: Color(0xFFFF8A00),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller});

  final HomeTabController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(Icons.menu_rounded, color: cs.onSurface, size: 22),
          ),
        ),
        const SizedBox(width: 10),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
                color: cs.onSurface,
              ),
              children: [
                TextSpan(
                  text: "GUYANA",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
                TextSpan(
                  text: "CENTRAL",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFF8A00),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(
          height: 34,
          child: ElevatedButton(
            onPressed: controller.goTOLogin,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              "Login",
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onPrimary,
              ),
            ),
          ),
        ),
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
    final cs = theme.colorScheme;
    final w = MediaQuery.of(context).size.width;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [Expanded(child: _TopBar(controller: controller))],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: _HeroSection(web: true),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: _SectionHeader(
                  title: "Browse Categories",
                  actionText: "See All",
                  onTap: _noop,
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
                  onTap: _noop,
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
                  onTap: _noop,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: Obx(
                () => SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final p = controller.properties[index];
                    return _PropertyCard(
                      title: p.title,
                      price: p.price,
                      image: p.image,
                    );
                  }, childCount: controller.properties.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: w >= 1100 ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Row(
                  children: [
                    Expanded(
                      child: _StatChip(
                        value: "50K+",
                        label: "Active Listings",
                        baseColor: cs.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatChip(
                        value: "100K+",
                        label: "Happy Users",
                        baseColor: Color(0xFFFF0000),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatChip(
                        value: "12",
                        label: "Categories",
                        baseColor: cs.secondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: _StatChip(
                        value: "FREE",
                        label: "Always Free",
                        baseColor: Color(0xFFFF8A00),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 22,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: WebFooter(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _noop() {}
}

class _HeroSection extends StatelessWidget {
  final bool web;
  const _HeroSection({required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
      fontSize: web ? 44 : 28,
      height: 1.12,
      fontWeight: FontWeight.w900,
      color: cs.onSurface,
    );

    final subtitle = theme.textTheme.bodyMedium?.copyWith(
      color: cs.onSurface.withOpacity(0.55),
      height: 1.35,
      fontSize: web ? 14 : 12.5,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: web
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: web ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: titleStyle,
            children: [
              TextSpan(
                text: "Find ",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: "Anything.\n",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF0000),
                ),
              ),
              TextSpan(
                text: "Sell ",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: "Everything.\n",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF8A00),
                ),
              ),
              TextSpan(
                text: "Pay ",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: "Nothing.",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Buy and sell locally with ease. Take the simplest\nway to find and deal near you.",
          textAlign: web ? TextAlign.center : TextAlign.start,
          style: subtitle,
        ),
        const SizedBox(height: 16),
        SizedBox(width: web ? 560 : double.infinity, child: _SearchBar()),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextField(
      decoration: InputDecoration(
        hintText: "Search for anything...",
        prefixIcon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary, width: 1.4),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(6),
          child: SizedBox(
            width: 44,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(Icons.search_rounded, size: 18),
            ),
          ),
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
            fontWeight: FontWeight.w900,
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
              fontWeight: FontWeight.w800,
              color: cs.primary,
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

    final bgColor = active ? cs.primary : cs.surface;
    final borderColor = active ? cs.primary : cs.outlineVariant;

    final iconColor = active ? cs.onPrimary : cs.onSurfaceVariant;

    final textColor = active ? cs.primary : cs.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: iconColor),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ],
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
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withOpacity(0.06),
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
                  child: Image(
                    image: item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: cs.surfaceVariant,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
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
                        fontWeight: FontWeight.w900,
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
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: cs.onSurface.withOpacity(0.45),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.location,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: cs.onSurface.withOpacity(0.55),
                              fontWeight: FontWeight.w600,
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
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withOpacity(0.06),
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
              child: Image(
                image: image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: cs.surfaceVariant,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
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
  final Color baseColor;

  const _StatChip({
    required this.value,
    required this.label,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = baseColor.withOpacity(.30);

    return Container(
      height: 90, // ✅ same height for all
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // center vertically
        children: [
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: baseColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
