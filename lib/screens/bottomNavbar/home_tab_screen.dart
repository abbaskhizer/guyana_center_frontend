import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/home_tab_controller.dart';
import 'package:guyana_center_frontend/widgets/mobile_top_bar.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/web_categories_grid.dart';
import 'package:guyana_center_frontend/widgets/featured_sections.dart';
import 'package:guyana_center_frontend/widgets/trust_sections.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeTabController(), permanent: true);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _isWebDesktop(context)
          ? Colors.white
          : theme.scaffoldBackgroundColor,
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
        MobileTopBar(),
        const SizedBox(height: 14),
        const _HeroSection(web: false),
        const SizedBox(height: 18),
        _SectionHeader(
          title: "Browse Categories",
          actionText: "See All",
          onTap: controller.openAllCategoriesScreen,
        ),
        const SizedBox(height: 10),

        /// ✅ HOME shows: All + 4 (total 5)
        SizedBox(
          height: 92,
          child: Obx(() {
            final list = controller.homeCategories;
            final selected = controller.selectedCategoryIndex.value;

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final item = list[i];
                final active = i == selected;

                return _CategoryCard(
                  assetImage: item.assetImage ?? "",
                  title: item.title,
                  active: active,
                  onTap: () {
                    controller.selectHomeCategory(i);
                    controller.openFromHomeCategory(i);
                  },
                );
              },
            );
          }),
        ),

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

        SizedBox(
          height: 252,
          child: Obx(() {
            final props = controller.properties;
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: props.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final p = props[i];
                return _PropertyCard(
                  title: p.title,
                  location: p.location,
                  price: p.price,
                  meta: p.meta,
                  image: p.image,
                  isFav: p.isFav,
                  onFavTap: () => controller.togglePropertyFav(i),
                );
              },
            );
          }),
        ),

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
            const SizedBox(width: 10),
            const Expanded(
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

class _WebLayout extends StatelessWidget {
  final HomeTabController controller;
  const _WebLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        // Hero section - centered
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: _HeroSection(web: true),
              ),
            ),
          ),
        ),

        /// ✅ WEB: Full-width FAFAFA background with padding
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFFFAFAFA),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Browse Categories section header
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 10),
                  child: _SectionHeader(
                    title: "Browse Categories",
                    actionText: "See All",
                    onTap: controller.openAllCategoriesScreen,
                  ),
                ),
                const SizedBox(height: 16),
                // Categories grid
                WebCategoriesGrid(controller: controller),
                const SizedBox(height: 32),
                const FeaturedVehiclesSection(),
                const SizedBox(height: 48),
                const RealEstateSection(),
                const SizedBox(height: 48),
                // Stats section in single white card
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 48,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatChip(
                          value: "50K+",
                          label: "Active Listings",
                          baseColor: const Color(0xFF16A34A),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: const Color(0xFFF3F4F6),
                      ),
                      const Expanded(
                        child: _StatChip(
                          value: "100K+",
                          label: "Happy Users",
                          baseColor: const Color(0xFFDC2626),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: const Color(0xFFF3F4F6),
                      ),
                      Expanded(
                        child: _StatChip(
                          value: "12",
                          label: "Categories",
                          baseColor: const Color(0xFFD97706),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: const Color(0xFFF3F4F6),
                      ),
                      const Expanded(
                        child: _StatChip(
                          value: "FREE",
                          label: "Always & Forever",
                          baseColor: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: const TopStoresSection(),
                  ),
                ),
                const SizedBox(height: 64),
                const WhyTrinisLoveSection(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Container(color: cs.surface, child: WebFooter()),
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

    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
      fontSize: web ? 54 : 28,
      height: web ? 1.06 : 1.12,
      fontWeight: FontWeight.w900,
      color: cs.onSurface,
    );

    final subtitle = theme.textTheme.bodyMedium?.copyWith(
      color: web ? const Color(0xFF9CA3AF) : cs.onSurface.withOpacity(0.55),
      height: 1.45,
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: web
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // ✅ WEB badge
        if (web)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFEAFBF0),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFF86EFAC), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF16A34A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '50,000+ active listings across Trinidad & Tobago',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // ✅ APP label
        if (!web)
          Text(
            "Your Local Marketplace",
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface.withOpacity(.55),
            ),
          ),

        SizedBox(height: web ? 26 : 10),

        RichText(
          textAlign: web ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: titleStyle,
            children: [
              TextSpan(
                text: "Find ",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: web ? 54 : 35,
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                ),
              ),
              TextSpan(
                text: "Anything.\n",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: web ? 54 : 35,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFE53935),
                ),
              ),
              TextSpan(
                text: "Sell ",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: web ? 54 : 35,
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                ),
              ),
              TextSpan(
                text: "Everything.\n",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: web ? 54 : 35,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFFF8A00),
                ),
              ),
              TextSpan(
                text: "Pay ",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: web ? 54 : 35,
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                ),
              ),
              TextSpan(
                text: "Nothing.",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: web ? 54 : 35,
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ✅ Subtitle different for Web & App (matches your 2 screenshots)
        Text(
          web
              ? 'The free classifieds marketplace for Trinis — cars, homes,\njobs, electronics & more.'
              : 'Buy and sell locally with zero fees. The simplest\nway to find great deals near you.',
          textAlign: web ? TextAlign.center : TextAlign.start,
          style: subtitle,
        ),

        const SizedBox(height: 26),

        SizedBox(
          width: web ? 720 : double.infinity,
          child: web ? const _WebSearchBar() : const _SearchBar(),
        ),
      ],
    );
  }
}

class _WebSearchBar extends StatelessWidget {
  const _WebSearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 56,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search cars, phones, houses, jobs...',
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFFCBD5E1),
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 18,
                color: Color(0xFFCBD5E1),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Search'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trending',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            _TrendChip(label: 'Toyota Hilux'),
            const SizedBox(width: 8),
            _TrendChip(label: '2BR House POS'),
            const SizedBox(width: 8),
            _TrendChip(label: 'iPhone 15'),
            const SizedBox(width: 8),
            _TrendChip(label: 'Driver Jobs'),
          ],
        ),
      ],
    );
  }
}

class _TrendChip extends StatelessWidget {
  final String label;
  const _TrendChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: const Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
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
  final String assetImage;
  final String title;
  final bool active;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.assetImage,
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final boxColor = active ? cs.primary : const Color(0xFFF3F4F6);
    final textColor = active ? cs.primary : cs.onSurface.withOpacity(.65);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 82,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  assetImage,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.broken_image_outlined,
                    color: active ? Colors.white : cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
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
                      alignment: Alignment.center,
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
  final String location;
  final String price;
  final String meta;
  final ImageProvider image;
  final bool isFav;
  final VoidCallback? onTap;
  final VoidCallback? onFavTap;

  const _PropertyCard({
    required this.title,
    required this.location,
    required this.price,
    required this.meta,
    required this.image,
    this.isFav = false,
    this.onTap,
    this.onFavTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(
                      image: image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: cs.surfaceVariant,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: Colors.white.withOpacity(0.92),
                        shape: const CircleBorder(),
                        elevation: 1,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onFavTap,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: isFav ? Colors.red : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFF0000),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        meta,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface, // background color from theme
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outlineVariant, // border color from theme
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: baseColor,
              fontSize: 15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
